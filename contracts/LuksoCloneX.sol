pragma solidity ^0.8.4;

import {LSP8IdentifiableDigitalAsset} from "@lukso/lsp-smart-contracts/contracts/LSP8IdentifiableDigitalAsset/LSP8IdentifiableDigitalAsset.sol";
import {Counters} from '@openzeppelin/contracts/utils/Counters.sol';
import {ReentrancyGuard} from "@openzeppelin/contracts/security/ReentrancyGuard.sol";

import {_LSP4_METADATA_KEY} from "@lukso/lsp-smart-contracts/contracts/LSP4DigitalAssetMetadata/LSP4Constants.sol";

bytes32 constant _LSP8_TOKEN_ID_TYPE = 0x715f248956de7ce65e94d9d836bfead479f7e70d69b718d47bfe7b00e05b4fe4;
bytes32 constant _LSP8_TOKEN_METADATA_BASE_URI = 0x1a7628600c3bac7101f53697f48df381ddc36b9015e7d7c9c5633d1252aa2843;

contract LuksoCloneX is LSP8IdentifiableDigitalAsset, ReentrancyGuard {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    uint256 constant PRICE_PER_TOKEN = 0.2 ether;
    uint256 constant MAX_SUPPLY = 100;
    uint256 constant MAX_MINT_PER_ADDRESS = 3;
    uint256 constant PUBLIC_MINT_END_BLOCK = 3_000_000;

    mapping (address => uint256) private _mintedTokensPerAddress;

    constructor(address owner) LSP8IdentifiableDigitalAsset('LuksoCloneX', 'lCloneX', owner) {
        _setData(_LSP4_METADATA_KEY, bytes('ipfs://QmUkCsVu9pwXpbC3CmKNgQhZYnqHbcA7y3JxmdUmqrALcp'));
        _setData(_LSP8_TOKEN_ID_TYPE, hex"02");
        bytes memory zeroBytes = hex"00000000";
        bytes memory baseURI = abi.encodePacked(zeroBytes, bytes('ipfs://QmZh7P3YZNxFZUiHkXLNgAtdk2T6PAza3S15Jjg1DzxVGf'));
        _setData(_LSP8_TOKEN_METADATA_BASE_URI, baseURI);
    }

    function mint(
        address to,
        uint256 amount,
        bool allowNonLSP1Recipient
    ) external payable nonReentrant {
        require(msg.value >= PRICE_PER_TOKEN * amount, "Insufficient LYX sent");
        require(block.number <= PUBLIC_MINT_END_BLOCK, "Public mint ended");
        require(_tokenIds.current() + amount <= MAX_SUPPLY, "Exceeds MAX_SUPPLY");
        require(_mintedTokensPerAddress[msg.sender] + amount <= MAX_MINT_PER_ADDRESS, "Exceeds MAX_MINT_PER_ADDRESS");

        for (uint256 i = 0; i < amount; i++) {
            uint256 tokenId = _tokenIds.current();
            _mint(to, bytes32(tokenId), allowNonLSP1Recipient, "");
            _tokenIds.increment();
        }

        _mintedTokensPerAddress[msg.sender] += amount;

        if (msg.value > PRICE_PER_TOKEN * amount) {
            payable(msg.sender).transfer(msg.value - PRICE_PER_TOKEN * amount);
        }
    }
}
