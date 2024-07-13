// import {IRouterClient} from "@chainlink/contracts-ccip@1.4.0/src/v0.8/ccip/interfaces/IRouterClient.sol";
// import {OwnerIsCreator} from "@chainlink/contracts-ccip@1.4.0/src/v0.8/shared/access/OwnerIsCreator.sol";
// import {Client} from "@chainlink/contracts-ccip@1.4.0/src/v0.8/ccip/libraries/Client.sol";
// import {LinkTokenInterface} from "@chainlink/contracts@1.1.1/src/v0.8/shared/interfaces/LinkTokenInterface.sol";

// import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

// pragma solidity 0.8.24;

// contract Vault {

//     struct LotteryByToken {
//         uint256 initBalance;
//         uint256 rate;
//         uint256 chainId;
//         bool isFinilizing;
//     }

//     uint256 maxRounds = 10;
//     mapping(address=>LotteryByToken) public stats;
//     address public lottery;

//     uint96 public mainChainId = 0; 

//     constructor(address _lottery,address _router, address _link) {
//         lottery = _lottery;
//         s_router = IRouterClient(_router);
//         s_linkToken = LinkTokenInterface(_link);

//     }

//     //Took from Chainlink docs

//     function sendMessage(
//         uint64 destinationChainSelector,
//         address receiver,
//         string calldata text
//     ) external onlyOwner returns (bytes32 messageId) {
//         // Create an EVM2AnyMessage struct in memory with necessary information for sending a cross-chain message
//         Client.EVM2AnyMessage memory evm2AnyMessage = Client.EVM2AnyMessage({
//             receiver: abi.encode(receiver), // ABI-encoded receiver address
//             data: abi.encode(text), // ABI-encoded string
//             tokenAmounts: new Client.EVMTokenAmount[](0), // Empty array indicating no tokens are being sent
//             extraArgs: Client._argsToBytes(
//                 // Additional arguments, setting gas limit
//                 Client.EVMExtraArgsV1({gasLimit: 200_000})
//             ),
//             // Set the feeToken  address, indicating LINK will be used for fees
//             feeToken: address(s_linkToken)
//         });

//         // Get the fee required to send the message
//         uint256 fees = s_router.getFee(
//             destinationChainSelector,
//             evm2AnyMessage
//         );

//         if (fees > s_linkToken.balanceOf(address(this)))
//             revert NotEnoughBalance(s_linkToken.balanceOf(address(this)), fees);

//         // approve the Router to transfer LINK tokens on contract's behalf. It will spend the fees in LINK
//         s_linkToken.approve(address(s_router), fees);

//         // Send the message through the router and store the returned message ID
//         messageId = s_router.ccipSend(destinationChainSelector, evm2AnyMessage);

//         // Return the message ID
//         return messageId;
//     }

//     function addLotteryTokens(address token, uint256 amount) external {
//         LotteryByToken storage loc = stats[token];
//         if(loc.initBalance != 0 ){
//             revert("already ongoing");
//         }
//         require(amount>10, "amount is too small");
//         loc.chainId = block.chain.id;
//         loc.rate = amount / 10; 

//         bytes memory data = abi.encodeWithSignature("addLottery(address,address,uint96)", token, msg.sender, block.chainId);
        
//         sendMessage(mainChainId, lottery, data);


//     } 

    
// }