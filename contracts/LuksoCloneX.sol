pragma solidity ^0.8.4;

import {LSP8IdentifiableDigitalAsset} from "@lukso/lsp-smart-contracts/contracts/LSP8IdentifiableDigitalAsset/LSP8IdentifiableDigitalAsset.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import {MerkleProof} from "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

import {_LSP4_METADATA_KEY, _LSP4_CREATORS_ARRAY_KEY, _LSP4_CREATORS_MAP_KEY_PREFIX} from "@lukso/lsp-smart-contracts/contracts/LSP4DigitalAssetMetadata/LSP4Constants.sol";

contract LuksoCloneX is LSP8IdentifiableDigitalAsset, ReentrancyGuard {
    bytes32 constant _LSP8_TOKEN_ID_TYPE = 0x715f248956de7ce65e94d9d836bfead479f7e70d69b718d47bfe7b00e05b4fe4;
    bytes32 constant _LSP8_TOKEN_METADATA_BASE_URI = 0x1a7628600c3bac7101f53697f48df381ddc36b9015e7d7c9c5633d1252aa2843;

    uint256 constant PUBLIC_PRICE_PER_TOKEN = 0.2 ether;
    uint256 constant PRIVATE_PRICE_PER_TOKEN = 0.1 ether;
    uint256 constant MAX_SUPPLY = 100;
    uint256 constant MAX_MINT_PER_WHITELISTED_ADDRESS = 3;
    uint256 constant PUBLIC_MINT_END_BLOCK = 3_000_000;
    uint256 constant PRIVATE_MINT_END_BLOCK = 2_000_000;

    bytes32 private constant _merkleRoot = 0x9247fd44ab1e9cbaa8bb670ba0313dc5a8d881a17feff76643b2ca7e6504a23f;

    mapping (address => uint256) private _mintedTokensPerWhitelistedAddress;

    constructor(address owner_) LSP8IdentifiableDigitalAsset('LuksoCloneX', 'lCloneX', owner_) {

        // 4ed94534e6e56a4cf8cea54daa9fc9b59751668459433f8dba993763d5dc6e20 is the hash of the URI JSON content
        bytes memory jsonUrl = abi.encodePacked(
            bytes4(keccak256('keccak256(utf8)')),
            hex"4ed94534e6e56a4cf8cea54daa9fc9b59751668459433f8dba993763d5dc6e20",
            bytes('ipfs://QmR6P52FwU8vVQRjqdi1AjHroVQRx35AzgFdTB3A9Jz5dx'));

        _setData(_LSP4_METADATA_KEY, jsonUrl);

        _setData(_LSP8_TOKEN_ID_TYPE, hex"02");

        bytes memory zeroBytes = hex"00000000";
        bytes memory baseURI = abi.encodePacked(zeroBytes, bytes('ipfs://QmZh7P3YZNxFZUiHkXLNgAtdk2T6PAza3S15Jjg1DzxVGf'));
        _setData(_LSP8_TOKEN_METADATA_BASE_URI, baseURI);

        // We set the length of the array to 1
        _setData(_LSP4_CREATORS_ARRAY_KEY, hex"01");

        // We set the first element of the array to the creator address
        _setData(0x114bd03b3a46d48759680d81ebb2b41400000000000000000000000000000000, hex"5870dC9aEB06E26A0C8130eF2C6C12d80b1E0375");

        // Set the creator map with interfaceId=66767497 and creator index 0
        bytes32 creatorsMapKey = bytes32(abi.encodePacked(_LSP4_CREATORS_MAP_KEY_PREFIX, 0x5870dC9aEB06E26A0C8130eF2C6C12d80b1E0375));
        _setData(creatorsMapKey , hex"667674970000000000000000");
    }

    function publicMint(
        address to,
        uint256 amount,
        bool allowNonLSP1Recipient
    ) external payable nonReentrant {
        uint256 tokenSupply = totalSupply(); // gas saving

        require(msg.value == PUBLIC_PRICE_PER_TOKEN * amount, "Invalid LYX amount sent");
        require(block.number <= PUBLIC_MINT_END_BLOCK, "Public mint ended");
        require(block.number > PRIVATE_MINT_END_BLOCK, "Public mint not started yet");
        require(tokenSupply + amount <= MAX_SUPPLY, "Exceeds MAX_SUPPLY");

        for (uint256 i = 0; i < amount; i++) {
            uint256 tokenId = ++tokenSupply;
            _mint(to, bytes32(tokenId), allowNonLSP1Recipient, "");
        }
    }

    function privateMint(
        address to,
        uint256 amount,
        bool allowNonLSP1Recipient,
        bytes32[] calldata merkleProof
    ) external payable nonReentrant {
        uint256 tokenSupply = totalSupply(); // gas saving

        require(MerkleProof.verify(merkleProof, _merkleRoot, keccak256(abi.encodePacked(msg.sender))), "Invalid merkle proof");
        require(msg.value == PRIVATE_PRICE_PER_TOKEN * amount, "Invalid LYX amount sent");
        require(block.number <= PRIVATE_MINT_END_BLOCK, "Private mint ended");
        require(tokenSupply + amount <= MAX_SUPPLY, "Exceeds MAX_SUPPLY");
        require(_mintedTokensPerWhitelistedAddress[msg.sender] + amount <= MAX_MINT_PER_WHITELISTED_ADDRESS, "Exceeds MAX_MINT_PER_ADDRESS");

        _mintedTokensPerWhitelistedAddress[msg.sender] += amount;

        for (uint256 i = 0; i < amount; i++) {
            uint256 tokenId = ++tokenSupply;
            _mint(to, bytes32(tokenId), allowNonLSP1Recipient, "");
        }
    }
}
