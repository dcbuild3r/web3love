// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.10;

import "solmate/tokens/ERC721.sol";

error DoesNotExist();

contract Web3Love is ERC721 {
    uint256 public totalSupply = 1;

    mapping(uint256 => Card) public getCard;

    struct Card {
        string ipfsMeta;
        uint256 inResponseTo;
        address author;
    }

    constructor() payable ERC721("Web3Love Cards", "W3L") {}

    function mint(
        string memory _ipfsMeta,
        uint256 _inResponseTo,
        address _recipient
    ) public payable {
        getCard[totalSupply] = Card({
            ipfsMeta: _ipfsMeta,
            inResponseTo: _inResponseTo,
            author: msg.sender
        });

        unchecked {
            _mint(_recipient, totalSupply++);
        }
    }

    function tokenURI(uint256 id) public view override returns (string memory) {
        if (ownerOf[id] == address(0)) revert DoesNotExist();

        return string(abi.encodePacked("ipfs://", getCard[id].ipfsMeta));
    }
}
