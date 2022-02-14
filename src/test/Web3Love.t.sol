// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.10;

import "forge-std/Vm.sol";
import "ds-test/test.sol";
import "../Web3Love.sol";

contract ContractTest is DSTest {
    Vm internal constant hevm = Vm(HEVM_ADDRESS);
    Web3Love internal token;

    event Transfer(
        address indexed from,
        address indexed to,
        uint256 indexed id
    );

    function setUp() public {
        token = new Web3Love();
    }

    function testMint(address recipient, string calldata ipfsMeta) public {
        hevm.expectEmit(true, false, false, true);
        emit Transfer(address(0), address(recipient), 1);

        token.mint(ipfsMeta, 0, recipient);

        assertEq(token.balanceOf(address(recipient)), 1);
        assertEq(
            token.tokenURI(1),
            string(abi.encodePacked("ipfs://", ipfsMeta))
        );

        (string memory _ipfsMeta, uint256 _inResponseTo, address author) = token
            .getCard(1);

        assertEq(ipfsMeta, _ipfsMeta);
        assertEq(0, _inResponseTo);
        assertEq(address(this), author);
    }

    function testReply(
        address recipient,
        address replyRecipient,
        string calldata ipfsMeta,
        string calldata replyIpfsMeta
    ) public {
        token.mint(ipfsMeta, 0, recipient);

        token.mint(replyIpfsMeta, 1, replyRecipient);

        assertEq(token.balanceOf(address(replyRecipient)), 1);
        (, uint256 _inResponseTo, ) = token.getCard(2);

        assertEq(_inResponseTo, 1);
    }
}
