// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {Lottery} from "src/Lottery.sol";
import {VRFCoordinatorV2_5Mock} from "@chainlink/contracts/src/v0.8/vrf/mocks/VRFCoordinatorV2_5Mock.sol";

contract LotteryScript is Script {
    function setUp() public {}

    function run() public {
        uint256 privateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(privateKey);
        address lottery = new Lottery(55607761975270005991572083513631562303731954444650979753959851776198117606388,0x9DdfaCa8183c41ad55329BdeeD9F6A8d53168B1B,address(0));
    }

    function testChainlink() public {
        VRFCoordinatorV2_5Mock chainlinkVRF = new VRFCoordinatorV2_5Mock(100000000000000000,1000000000,4147459561472299);
        chainlinkVRF.createSubscription();
    }
}
