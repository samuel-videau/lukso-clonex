pragma solidity ^0.8.4;

import {LSP8IdentifiableDigitalAsset} from "@lukso/lsp-smart-contracts/contracts/LSP8IdentifiableDigitalAsset/LSP8IdentifiableDigitalAsset.sol";
import {_LSP4_METADATA_KEY} from "@lukso/lsp-smart-contracts/contracts/LSP4DigitalAssetMetadata/LSP4Constants.sol";

bytes32 constant _LSP8_TOKEN_ID_TYPE = 0x715f248956de7ce65e94d9d836bfead479f7e70d69b718d47bfe7b00e05b4fe4;
bytes32 constant _LSP8_TOKEN_METADATA_BASE_URI = 0x1a7628600c3bac7101f53697f48df381ddc36b9015e7d7c9c5633d1252aa2843;

contract LuksoCloneX is LSP8IdentifiableDigitalAsset {
    constructor(address owner) LSP8IdentifiableDigitalAsset('LuksoCloneX', 'lCloneX', owner) {
        _setData(_LSP4_METADATA_KEY, bytes('ipfs://QmUkCsVu9pwXpbC3CmKNgQhZYnqHbcA7y3JxmdUmqrALcp'));

        // Setting the token id type to 2 (for token id being uint256)
        _setData(_LSP8_TOKEN_ID_TYPE, hex"02");

        bytes memory zeroBytes = hex"00000000";
        bytes memory baseURI = abi.encodePacked(zeroBytes, bytes('ipfs://QmZh7P3YZNxFZUiHkXLNgAtdk2T6PAza3S15Jjg1DzxVGf'));
        _setData(_LSP8_TOKEN_METADATA_BASE_URI, baseURI);
    }
}