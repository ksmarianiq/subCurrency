// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {SubCurrency} from "../src/SubCurrency.sol";
import {DeploySubCurrency} from "../script/DeploySubCurrency.s.sol";

contract TestSubCurency is Test {
     event Sent(address from, address to, uint amount);
    error InsufficientBalance(uint requested, uint available);
    SubCurrency subCurrency;
    address USER = makeAddr("user");
    address USER2 = makeAddr("user2");

    function setUp() external {
        DeploySubCurrency deploySubCurrency = new DeploySubCurrency();
        subCurrency = deploySubCurrency.run();
       
        subCurrency.mint2(USER, 5); 
      
    }

    function testOwnerIsMessageSender() public {
        assertEq(subCurrency.getOwner(), msg.sender);
    }

    function testOnlyOwnerCanMint() public {
        vm.expectRevert();
        vm.prank(USER);
        subCurrency.mint(USER2, 10);
    }

    function testSendFailsWithoutEnoughBalance() public {
        require(subCurrency.getBalanceOf(USER) <2);
        vm.expectRevert();
        vm.prank(USER);
        subCurrency.send(USER2, 2);
    }

   function testSendUpdatesBalancesCorrectly() public {
     //require(subCurrency.getBalanceOf(USER) >2);
    // Obtenez les soldes avant l'envoi
    uint balanceBeforeSender = subCurrency.getBalanceOf(USER);
    uint balanceBeforeReceiver = subCurrency.getBalanceOf(USER2);

    // Exécutez la fonction send à partir de l'entité émettrice
    // vm.expectRevert();
    vm.prank(USER);
    subCurrency.send(USER2, 2);

    // Obtenez les soldes après l'envoi
    uint balanceAfterSender = subCurrency.getBalanceOf(USER);
    uint balanceAfterReceiver = subCurrency.getBalanceOf(USER2);

    // Vérifiez que les soldes sont correctement mis à jour
    //require(subCurrency.getBalanceOf(USER) >= 2);
    assert(balanceAfterSender == balanceBeforeSender - 2);
    assert(balanceAfterReceiver == balanceBeforeReceiver + 2);
}

function testRevertEmit() public{
    vm.expectEmit(true, true, false, true);
    emit Sent(USER, USER2, 5);
    vm.prank(USER);
    subCurrency.send(USER2, 5);
}
}
