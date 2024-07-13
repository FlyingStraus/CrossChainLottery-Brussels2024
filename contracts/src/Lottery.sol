// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.24;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import {VRFConsumerBaseV2Plus} from "chainlink/contracts/src/v0.8/vrf/dev/VRFConsumerBaseV2Plus.sol";
import {VRFV2PlusClient} from "chainlink/contracts/src/v0.8/vrf/dev/libraries/VRFV2PlusClient.sol";

// import {CCIPReceiver} from "@chainlink/contracts-ccip/src/v0.8/ccip/applications/CCIPReceiver.sol";
// import {Client} from "@chainlink/contracts-ccip/src/v0.8/ccip/libraries/Client.sol";

contract Lottery is ERC20, VRFConsumerBaseV2Plus{

    struct LotteryByToken {
        uint256 lastFinalization;
        uint256 finishedRounds;
        uint256 chainId;
        address vault;
        bool isFinilizing;
    }

    // uint256 public finilizationGap = 1 days;
    uint256 public finilizationGap = 0;
    uint256 public totalRounds = 10;

    mapping(address=>LotteryByToken) public stats;
    mapping(uint256=>address) public randomRequest;

    bytes32 public keyHash =
        0x787d74caea10b2b357790d5b5247c2f63d1d91572a9846f780606e4d953677ae; 
    uint256 public s_subscriptionId;

    uint32 public callbackGasLimit = 2_500_000;
    uint16 public requestConfirmations = 3;
    uint32 public numWords = 1;


    uint256 public mock=0;


    constructor( 
        uint256 subscriptionId,
        address wrapperAddress,
        address router
    ) ERC20("K", "K") VRFConsumerBaseV2Plus(wrapperAddress) 
    //  CCIPReceiver(router) 
     {
        s_subscriptionId = subscriptionId;
    }



    // function addLottery(address token, uint256 amount, uint256 rounds) external {
    //     LotteryByToken storage loc = stats[token];
        
    //     require(!loc.isFinilizing, "Finilizing is ongoing");
        
    //     if(loc.finishedRounds != 0 ){
            
        
    //     } else {
            
    //         loc.totalRounds = rounds;

    //     }
    //     loc.initBalance += amount;

    //     loc.rate = (loc.initBalance-loc.spentBalance) * ERC20(token).decimals() / rounds;

    //     ERC20(token).transferFrom(msg.sender,address(this), amount);
    //     // should use safeTransferFrom

    // }

    // function _ccipReceive(
    //     Client.Any2EVMMessage memory message
    // ) internal override {
    //     (bool success, ) = address(address(this)).call(message.data);
    //     require(success);
    // }

    function addLottery(address token, address vault, uint96 chainid) external {

        LotteryByToken storage loc = stats[token];
        loc.vault = vault;
        loc.chainId = chainid;
        loc.lastFinalization = block.timestamp;
    }


    function finalizeLottery(address token) external returns(uint256 requestId) {
        
        LotteryByToken storage loc = stats[token];

        if(loc.lastFinalization + finilizationGap < block.timestamp){
            revert("Too early broski");
        }

        requestId = s_vrfCoordinator.requestRandomWords(
            VRFV2PlusClient.RandomWordsRequest({
                keyHash: keyHash,
                subId: s_subscriptionId,
                requestConfirmations: requestConfirmations,
                callbackGasLimit: callbackGasLimit,
                numWords: numWords,
                extraArgs: VRFV2PlusClient._argsToBytes(
                    VRFV2PlusClient.ExtraArgsV1({
                        nativePayment: false
                    })
                )
            })
        );
        loc.isFinilizing = true;
        randomRequest[requestId] = token;
    }

    function fulfillRandomWords(uint256 _requestId, uint256[] calldata _randomWords) internal override {
        
        // require(randomRequest[_requestId] != address(0), "No such a request");
        
        address token = randomRequest[_requestId]; 
        randomRequest[_requestId] = address(0);

        LotteryByToken storage loc = stats[token];
        mock++;

    }
    
}