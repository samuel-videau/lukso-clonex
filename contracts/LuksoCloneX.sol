pragma solidity ^0.8.4;

import {LSP8IdentifiableDigitalAsset} from "@lukso/lsp-smart-contracts/contracts/LSP8IdentifiableDigitalAsset/LSP8IdentifiableDigitalAsset.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import {MerkleProof} from "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

import {_LSP4_METADATA_KEY} from "@lukso/lsp-smart-contracts/contracts/LSP4DigitalAssetMetadata/LSP4Constants.sol";

contract LuksoCloneX is LSP8IdentifiableDigitalAsset, ReentrancyGuard {
    bytes32 constant _LSP8_TOKEN_ID_TYPE = 0x715f248956de7ce65e94d9d836bfead479f7e70d69b718d47bfe7b00e05b4fe4;
    bytes32 constant _LSP8_TOKEN_METADATA_BASE_URI = 0x1a7628600c3bac7101f53697f48df381ddc36b9015e7d7c9c5633d1252aa2843;

    uint256 constant PUBLIC_PRICE_PER_TOKEN = 0.2 ether;
    uint256 constant PRIVATE_PRICE_PER_TOKEN = 0.1 ether;
    uint256 constant MAX_SUPPLY = 100;
    uint256 constant MAX_MINT_PER_ADDRESS = 3;
    uint256 constant PUBLIC_MINT_END_BLOCK = 3_000_000;
    uint256 constant PRIVATE_MINT_END_BLOCK = 2_000_000;

    mapping (address => uint256) private _mintedTokensPerAddress;

    bytes32 private _merkleRoot;

    constructor(address owner) LSP8IdentifiableDigitalAsset('LuksoCloneX', 'lCloneX', owner) {
        _setData(_LSP4_METADATA_KEY, bytes('ipfs://QmUkCsVu9pwXpbC3CmKNgQhZYnqHbcA7y3JxmdUmqrALcp'));
        _setData(_LSP8_TOKEN_ID_TYPE, hex"02");
        bytes memory zeroBytes = hex"00000000";
        bytes memory baseURI = abi.encodePacked(zeroBytes, bytes('ipfs://QmZh7P3YZNxFZUiHkXLNgAtdk2T6PAza3S15Jjg1DzxVGf'));
        _setData(_LSP8_TOKEN_METADATA_BASE_URI, baseURI);

        _merkleRoot = 0x9247fd44ab1e9cbaa8bb670ba0313dc5a8d881a17feff76643b2ca7e6504a23f;
    }

    function publicMint(
        address to,
        uint256 amount,
        bool allowNonLSP1Recipient
    ) external payable nonReentrant {
        require(msg.value == PUBLIC_PRICE_PER_TOKEN * amount, "Invalid LYX amount sent");
        require(block.number <= PUBLIC_MINT_END_BLOCK, "Public mint ended");
        require(block.number > PRIVATE_MINT_END_BLOCK, "Public mint not started yet");
        require(totalSupply() + amount <= MAX_SUPPLY, "Exceeds MAX_SUPPLY");
        require(_mintedTokensPerAddress[msg.sender] + amount <= MAX_MINT_PER_ADDRESS, "Exceeds MAX_MINT_PER_ADDRESS");

        for (uint256 i = 0; i < amount; i++) {
            uint256 tokenId = totalSupply() + 1;
            _mint(to, bytes32(tokenId), allowNonLSP1Recipient, "");
        }

        _mintedTokensPerAddress[msg.sender] += amount;
    }

    function privateMint(
        address to,
        uint256 amount,
        bool allowNonLSP1Recipient,
        bytes32[] calldata merkleProof
    ) external payable nonReentrant {
        require(MerkleProof.verify(merkleProof, _merkleRoot, keccak256(abi.encodePacked(msg.sender))), "Invalid merkle proof");
        require(msg.value == PRIVATE_PRICE_PER_TOKEN * amount, "Invalid LYX amount sent");
        require(block.number <= PRIVATE_MINT_END_BLOCK, "Private mint ended");
        require(totalSupply() + amount <= MAX_SUPPLY, "Exceeds MAX_SUPPLY");
        require(_mintedTokensPerAddress[msg.sender] + amount <= MAX_MINT_PER_ADDRESS, "Exceeds MAX_MINT_PER_ADDRESS");

        for (uint256 i = 0; i < amount; i++) {
            uint256 tokenId = totalSupply() + 1;
            _mint(to, bytes32(tokenId), allowNonLSP1Recipient, "");
        }

        _mintedTokensPerAddress[msg.sender] += amount;
    }
}
