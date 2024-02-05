// SPDX-License-Identifier: MIT

pragma solidity 0.8.23;

import { PlugRouterSocket } from "../sockets/Plug.Router.Socket.sol";

/**
 * @title Plug Etcher
 * @notice This contract is the basis of the automatically generated Plug Etcher
 *         contract used to deploy and write the proper addresses. If you need to add
 *         a new etch into the vm stack for testing, you will do so through the file
 *         found at: /lib/functions/etcher.ts
 * @notice A good portion of this model comes from:
 *         https://github.com/Vectorized/multicaller/blob/main/src/MulticallerEtcher.sol
 *         I am not a Foundry expert. If there is a better way to do this, please let me
 *         know because this is a lot of work just to get a contract deployed when you're
 *         doing anything more than a simple in-and-out contract.
 * @author vectorized (twitter:@optimizoor)
 */
library PlugEtcher {
    bytes internal constant ROUTER_SOCKET_INITCODE =
        hex"60806040818152346200022d5763409feecd198054600382558062000205575b5090638b78c6d8198054620001f7576001905560006001817f8be0079c531659141344cd1fd0a4f28419497f9722a3daafe3b4186f6b6457e08180a3620000668462000232565b60108452602091828501906f141b1d59d49bdd5d195c94dbd8dad95d60821b8252805191620000958362000232565b6005835284830190640302e302e360dc1b82528454620001b35782516001600160401b039890608081018a8111828210176200019f578552818152858882015246858201526060309101525190209251902090805191858301937f8b73c3c69bb8fe3d512ecc4cf759cc79239f7b179b0ffacaa9a75d522b39400f85528284015260608301524660808301523060a083015260a0825260c0820196828810908811176200018b5786905251902090558162000158575b61168a8381620002658239f35b60027fc7f505b2f371ae2175ee4913f4499e1f2633a7b5936321eed1cdaeb6115181d292556001815280a138806200014b565b634e487b7160e01b84526041600452602484fd5b634e487b7160e01b88526041600452602488fd5b825162461bcd60e51b815260048101879052601a60248201527f54797065733a616c72656164792d696e697469616c697a65642e0000000000006044820152606490fd5b630dc149f06000526004601cfd5b600181811c14303b10156200021f5760ff1b1b386200001f565b63f92ee8a96000526004601cfd5b600080fd5b604081019081106001600160401b038211176200024e57604052565b634e487b7160e01b600052604160045260246000fdfe6080604052600436101561001e575b361561001c5761001c61125f565b005b60003560e01c806303af1f841461017e57806306fdde03146101795780630d6c3cbc1461017457806319cac9421461016f578063256929621461016a57806334bb3700146101655780633c5c283d14610160578063450e94e91461015b57806354d1f13d1461015657806354fd4d5014610151578063715018a61461014c578063716b28dc146101475780638175cccf146101425780638da5cb5b1461013d5780638ec766cf146101385780639f26286414610133578063c4d66de81461012e578063dfe86ac514610129578063f04e283e14610124578063f2fde38b1461011f578063f3bb40f71461011a5763fee81cf40361000e57610d92565b610c75565b610bd5565b610b85565b610b67565b610a05565b6109ed565b6109d5565b61097e565b610944565b61090a565b6108be565b6108a2565b61085b565b610821565b6107f7565b610744565b6106f5565b6106bb565b6106a3565b6105a2565b610507565b634e487b7160e01b600052604160045260246000fd5b606081019081106001600160401b038211176101b457604052565b610183565b608081019081106001600160401b038211176101b457604052565b604081019081106001600160401b038211176101b457604052565b60a081019081106001600160401b038211176101b457604052565b90601f801991011681019081106001600160401b038211176101b457604052565b60405190610238826101b9565b565b6001600160401b0381116101b45760051b60200190565b600435906001600160a01b038216820361026757565b600080fd5b35906001600160a01b038216820361026757565b6001600160401b0381116101b457601f01601f191660200190565b81601f82011215610267578035906102b282610280565b926102c0604051948561020a565b8284526020838301011161026757816000926020809301838601378301015290565b919060608382031261026757604051906102fb82610199565b81936103068161026c565b8352602081013560208401526040810135916001600160401b03831161026757604092610333920161029b565b910152565b9190606083820312610267576040519061035182610199565b819361035c8161026c565b835260208101356001600160401b0381116102675760409261037f91830161029b565b602084015201359081151582036102675760400152565b81601f82011215610267578035916020916103b08461023a565b936103be604051958661020a565b808552838086019160051b8301019280841161026757848301915b8483106103e95750505050505090565b82356001600160401b03811161026757869161040a84848094890101610338565b8152019201916103d9565b919091606081840312610267576040519061042f82610199565b81938135916001600160401b039283811161026757826104509183016102e2565b845260208101359283116102675761046e6040939284938301610396565b60208501520135910152565b929190926104878461023a565b91610495604051938461020a565b829480845260208094019060051b8301928284116102675780915b8483106104bf57505050505050565b82356001600160401b0381116102675786916104de8684938601610415565b8152019201916104b0565b9080601f83011215610267578160206105049335910161047a565b90565b34610267576020366003190112610267576004356001600160401b0381116102675761054161053c60209236906004016104e9565b610e26565b604051908152f35b60005b83811061055c5750506000910152565b818101518382015260200161054c565b9060209161058581518092818552858086019101610549565b601f01601f1916010190565b90602061050492818152019061056c565b34610267576000366003190112610267576105d26105be610e6f565b60405191829160208352602083019061056c565b0390f35b919091602081840312610267576040519060208201936001600160401b0394838110868211176101b457604052829482359081116102675761061892016104e9565b9052565b9190916040818403126102675760408051916001600160401b03918301828111848210176101b45760405282948135838111610267578161065e9184016105d6565b8452602082013592831161026757602092610333920161029b565b602060031982011261026757600435906001600160401b038211610267576105049160040161061c565b346102675760206105416106b636610679565b610e9b565b34610267576020366003190112610267576004356001600160401b038111610267576105416106f06020923690600401610396565b610efa565b6000806003193601126107415763389a75e1600c523381526202a30042016020600c2055337fdbf36a107da19e49527a7176a1babf963b4b0ff8cde35ee35d6cd8f1f9ac7e1d8280a280f35b80fd5b346102675760031960203682011261026757600435906001600160401b039081831161026757608090833603011261026757604051610782816101b9565b82600401358281116102675761079e906004369186010161029b565b81526024830135918211610267576107dd60646105d2946107c86107e7956004369184010161029b565b6020850152604481013560408501520161026c565b6060820152610f3d565b6040519081529081906020820190565b3461026757602061080f61080a36610679565b610fcb565b6040516001600160a01b039091168152f35b34610267576020366003190112610267576004356001600160401b0381116102675761054161085660209236906004016102e2565b611094565b6000806003193601126107415763389a75e1600c52338152806020600c2055337ffa7b8eab7da67f412cc9575ed43464468f9bfbae89d1675917346ca6d8fe3c928280a280f35b34610267576000366003190112610267576105d26105be6110f8565b600080600319360112610741576108d361128c565b638b78c6d8198181547f8be0079c531659141344cd1fd0a4f28419497f9722a3daafe3b4186f6b6457e08280a3600160ff1b905580f35b34610267576020366003190112610267576004356001600160401b0381116102675761054161093f6020923690600401610415565b611119565b34610267576020366003190112610267576004356001600160401b038111610267576105416109796020923690600401610338565b61117e565b3461026757600036600319011261026757638b78c6d819546040516001600160a01b039091168152602090f35b602060031982011261026757600435906001600160401b03821161026757610504916004016105d6565b346102675760206105416109e8366109ab565b6111e4565b34610267576020610541610a00366109ab565b611218565b60208060031936011261026757610a1a610251565b9063409feecd1980548060038355610b41575b5090638b78c6d819928354610b33576001600160a01b0316801560ff1b8117909355600092837f8be0079c531659141344cd1fd0a4f28419497f9722a3daafe3b4186f6b6457e08180a3610a7f610e6f565b610a876110f8565b8454610aee578391610ab391610a9b61022b565b91825284820152466040820152306060820152610f3d565b8455610abd578280f35b60027fc7f505b2f371ae2175ee4913f4499e1f2633a7b5936321eed1cdaeb6115181d292556001815280a138808280f35b60405162461bcd60e51b815260048101849052601a60248201527f54797065733a616c72656164792d696e697469616c697a65642e0000000000006044820152606490fd5b630dc149f06000526004601cfd5b600181811c14303b1015610b595760ff1b1b38610a2d565b63f92ee8a96000526004601cfd5b34610267576000366003190112610267576020600054604051908152f35b602036600319011261026757610b99610251565b610ba161128c565b63389a75e1600c52806000526020600c209081544211610bc757600061001c92556112a9565b636f5e88186000526004601cfd5b602036600319011261026757610be9610251565b610bf161128c565b8060601b15610c035761001c906112a9565b637448fbae6000526004601cfd5b6020808201906020835283518092526040830192602060408460051b8301019501936000915b848310610c475750505050505090565b9091929394958480610c65600193603f198682030187528a5161056c565b9801930193019194939290610c37565b6003196020368201811361026757600435906001600160401b0382116102675760408260040193819336030112610267578290610cb561080a368461061c565b610cdf610cd8610cd2610ccb6106b6368861061c565b95806112ee565b80611303565b369161047a565b93610ce8611338565b50600093855192610cf884611371565b955b848110610d0f57604051806105d28982610c11565b90919293949695610d208288610dc5565b5195600097898801985b89518051821015610d5a5790610d4f88610d4683600195610dc5565b518c5190611449565b898b51015201610d2a565b50509896600192985084610d719194929451611515565b610d7b828a610dc5565b52610d868189610dc5565b50019392919093610cfa565b3461026757602036600319011261026757610dab610251565b63389a75e1600c52600052602080600c2054604051908152f35b8051821015610dd95760209160051b010190565b634e487b7160e01b600052603260045260246000fd5b60406102389193929381519481610e10879351809260208087019101610549565b820190602082015203602081018552018361020a565b6060906000908051905b818310610e44575050506020815191012090565b909192610e66600191610e60610e5a8786610dc5565b51611119565b90610def565b93019190610e30565b60405190610e7c826101d4565b601082526f141b1d59d49bdd5d195c94dbd8dad95d60821b6020830152565b6020610ea78251611218565b910151602081519101206040519060208201927f64df7f9145818d3d1b73d5697b766d27eea3f471d0f4c2546b698b2465fa5c5684526040830152606082015260608152610ef4816101b9565b51902090565b6060906000908051905b818310610f18575050506020815191012090565b909192610f34600191610e60610f2e8786610dc5565b5161117e565b93019190610f04565b8051602081519101209060208101516020815191012090604081015190606060018060a01b0391015116906040519260208401947f8b73c3c69bb8fe3d512ecc4cf759cc79239f7b179b0ffacaa9a75d522b39400f865260408501526060840152608083015260a082015260a0815260c081018181106001600160401b038211176101b45760405251902090565b610fd581516111e4565b6020918201516040805190939092600192859181840190611020565b50505050506001608060006020935afa51913d156110125760006060525290565b638baa579f6000526004601cfd5b6000525182528181511461106d57604181511461104c5750505050602060016080600080938692610ff1565b606080820151600090811a9094529101519052600190849060206080610ff1565b015160ff81901c601b019091526001600160ff1b0316606052600183600060206080610ff1565b60018060a01b038151169060406020820151910151602081519101206040519160208301937fba015bd32610c44647c4bcbb8c645ee60d5957ae5e7aa37e56c897d9295af65a855260408401526060830152608082015260808152610ef4816101ef565b60405190611105826101d4565b60058252640302e302e360dc1b6020830152565b6111238151611094565b9060406111336020830151610efa565b9101516040519160208301937ff45e38fd9718e32908043cec8ab84b6a035da2a109dea20e89a3b0f74a8c6755855260408401526060830152608082015260808152610ef4816101ef565b60018060a01b0381511690604060208201516020815191012091015115156040519160208301937f11d2e7ce7b01636231a80046eb2467257c3ea77c5a408e6ddd3d0899cfbc7379855260408401526060830152608082015260808152610ef4816101ef565b6111f060005491611218565b60405190602082019261190160f01b84526022830152604282015260428152610ef4816101b9565b6112229051610e26565b60405160208101917f85ac49fd7161ef1a4a4fe02063b7587cdff3c2cac35b5da2a01a601ea428f2088352604082015260408152610ef481610199565b60003560e01c63bc197c81811463f23a6e6182141763150b7a028214176112835750565b6020526020603cf35b638b78c6d81954330361129b57565b6382b429006000526004601cfd5b638b78c6d819805490916001600160a01b03169081907f8be0079c531659141344cd1fd0a4f28419497f9722a3daafe3b4186f6b6457e0600080a3801560ff1b179055565b903590601e1981360301821215610267570190565b903590601e198136030182121561026757018035906001600160401b03821161026757602001918160051b3603831361026757565b6040519061134582610199565b6000604083815161135581610199565b8381528360208201526060838201528152606060208201520152565b9061137b8261023a565b611388604051918261020a565b8281528092611399601f199161023a565b019060005b8281106113aa57505050565b80606060208093850101520161139e565b3d156113e6573d906113cc82610280565b916113da604051938461020a565b82523d6000602084013e565b606090565b602081830312610267578051906001600160401b038211610267570181601f8201121561026757805161141d81610280565b9261142b604051948561020a565b81845260208284010111610267576105049160208085019101610549565b91906000809160018060a01b038281875116926114d4602080986114c0828c01519660606040805197866114968a9889019c8d6308d7667160e11b90528560248b015260848a019061056c565b946023198987030160448a015282511685528082015190850152015191816040820152019061056c565b90606483015203601f19810183528261020a565b51925af1916114e16113bb565b92159081611507575b5061150157908161050492825183010191016113eb565b506115c8565b6040015115159050386114ea565b6000919082916040820151906115696034604051809360206115408184019788815193849201610549565b8201906bffffffffffffffffffffffff199060601b16602082015203601481018452018261020a565b82516001600160a01b031660205a940151915193f1906115876113bb565b911561150157565b6040519061159c826101d4565b601b82527f506c7567436f72653a7461726765742d70616e69636b65642d307800000000006020830152565b6004815110611646576020810180519091906001600160e01b031916634e487b7160e01b146115f5575190fd5b61164290602461160361158f565b91015160208201908151906030600f81818416019260041c160160081b179061ffff191617905260405191829162461bcd60e51b835260048301610591565b0390fd5b60405162461bcd60e51b815260206004820152600f60248201526e141b1d59d0dbdc994e9c995d995c9d608a1b6044820152606490fdfea164736f6c6343000817000a";

    bytes32 internal constant ROUTER_SOCKET_SALT =
        0x0000000000000000000000000000000000000000466f9e41a2a8f23f86c2535a;

    address internal constant ROUTER_SOCKET_ADDRESS =
        0x00b09C89Ace100AB7A4Dc47ebfBd1E7997920062;

    /**
     * @notice Deploy (if needed) and return the PlugRouterSocket contract instance.
     * @return $routerSocket The PlugRouterSocket contract instance.
     */
    function routerSocket() internal returns (PlugRouterSocket $routerSocket) {
        if (_extcodesize(ROUTER_SOCKET_ADDRESS) == 0) {
            address reality =
                _safeCreate2(ROUTER_SOCKET_SALT, ROUTER_SOCKET_INITCODE);
            require(
                reality == ROUTER_SOCKET_ADDRESS, "Etcher: Reality check failed"
            );
        }
        $routerSocket = PlugRouterSocket(payable(ROUTER_SOCKET_ADDRESS));
    }

    /**
     * @notice Deploys a contract via 0age's immutable create 2 factory for testing.
     * @param $salt The salt to use for the deployment.
     * @param $initializationCode The initialization code for the contract.
     * @return $deployment The address of the deployed contract.
     */
    function _safeCreate2(
        bytes32 $salt,
        bytes memory $initializationCode
    )
        private
        returns (address $deployment)
    {
        // Canonical address of 0age's immutable create 2 factory.
        address c2f = 0x0000000000FFe8B47B3e2130213B802212439497;
        if (_extcodesize(c2f) == 0) {
            bytes memory ic2fBytecode =
                hex"60806040526004361061003f5760003560e01c806308508b8f1461004457806364e030871461009857806385cf97ab14610138578063a49a7c90146101bc575b600080fd5b34801561005057600080fd5b506100846004803603602081101561006757600080fd5b503573ffffffffffffffffffffffffffffffffffffffff166101ec565b604080519115158252519081900360200190f35b61010f600480360360408110156100ae57600080fd5b813591908101906040810160208201356401000000008111156100d057600080fd5b8201836020820111156100e257600080fd5b8035906020019184600183028401116401000000008311171561010457600080fd5b509092509050610217565b6040805173ffffffffffffffffffffffffffffffffffffffff9092168252519081900360200190f35b34801561014457600080fd5b5061010f6004803603604081101561015b57600080fd5b8135919081019060408101602082013564010000000081111561017d57600080fd5b82018360208201111561018f57600080fd5b803590602001918460018302840111640100000000831117156101b157600080fd5b509092509050610592565b3480156101c857600080fd5b5061010f600480360360408110156101df57600080fd5b508035906020013561069e565b73ffffffffffffffffffffffffffffffffffffffff1660009081526020819052604090205460ff1690565b600083606081901c33148061024c57507fffffffffffffffffffffffffffffffffffffffff0000000000000000000000008116155b6102a1576040517f08c379a00000000000000000000000000000000000000000000000000000000081526004018080602001828103825260458152602001806107746045913960600191505060405180910390fd5b606084848080601f0160208091040260200160405190810160405280939291908181526020018383808284376000920182905250604051855195965090943094508b93508692506020918201918291908401908083835b6020831061033557805182527fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe090920191602091820191016102f8565b51815160209384036101000a7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff018019909216911617905260408051929094018281037fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe00183528085528251928201929092207fff000000000000000000000000000000000000000000000000000000000000008383015260609890981b7fffffffffffffffffffffffffffffffffffffffff00000000000000000000000016602183015260358201969096526055808201979097528251808203909701875260750182525084519484019490942073ffffffffffffffffffffffffffffffffffffffff81166000908152938490529390922054929350505060ff16156104a7576040517f08c379a000000000000000000000000000000000000000000000000000000000815260040180806020018281038252603f815260200180610735603f913960400191505060405180910390fd5b81602001825188818334f5955050508073ffffffffffffffffffffffffffffffffffffffff168473ffffffffffffffffffffffffffffffffffffffff161461053a576040517f08c379a00000000000000000000000000000000000000000000000000000000081526004018080602001828103825260468152602001806107b96046913960600191505060405180910390fd5b50505073ffffffffffffffffffffffffffffffffffffffff8116600090815260208190526040902080547fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff001660011790559392505050565b6000308484846040516020018083838082843760408051919093018181037fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe001825280845281516020928301207fff000000000000000000000000000000000000000000000000000000000000008383015260609990991b7fffffffffffffffffffffffffffffffffffffffff000000000000000000000000166021820152603581019790975260558088019890985282518088039098018852607590960182525085519585019590952073ffffffffffffffffffffffffffffffffffffffff81166000908152948590529490932054939450505060ff909116159050610697575060005b9392505050565b604080517fff000000000000000000000000000000000000000000000000000000000000006020808301919091523060601b6021830152603582018590526055808301859052835180840390910181526075909201835281519181019190912073ffffffffffffffffffffffffffffffffffffffff81166000908152918290529190205460ff161561072e575060005b9291505056fe496e76616c696420636f6e7472616374206372656174696f6e202d20636f6e74726163742068617320616c7265616479206265656e206465706c6f7965642e496e76616c69642073616c74202d206669727374203230206279746573206f66207468652073616c74206d757374206d617463682063616c6c696e6720616464726573732e4661696c656420746f206465706c6f7920636f6e7472616374207573696e672070726f76696465642073616c7420616e6420696e697469616c697a6174696f6e20636f64652ea265627a7a723058202bdc55310d97c4088f18acf04253db593f0914059f0c781a9df3624dcef0d1cf64736f6c634300050a0032";
            /// @solidity memory-safe-assembly
            assembly {
                let m := mload(0x40)
                mstore(m, 0xb4d6c782) // `etch(address,bytes)`.
                mstore(add(m, 0x20), c2f)
                mstore(add(m, 0x40), 0x40)
                let n := mload(ic2fBytecode)
                mstore(add(m, 0x60), n)
                for { let i := 0 } lt(i, n) { i := add(0x20, i) } {
                    mstore(
                        add(add(m, 0x80), i),
                        mload(add(add(ic2fBytecode, 0x20), i))
                    )
                }
                let vmAddress := 0x7109709ECfa91a80626fF3989D68f67F5b1DD12D
                if iszero(
                    call(
                        gas(),
                        vmAddress,
                        0,
                        add(m, 0x1c),
                        add(n, 0x64),
                        0x00,
                        0x00
                    )
                ) { revert(0, 0) }
            }
        }
        /// @solidity memory-safe-assembly
        assembly {
            let m := mload(0x40)
            let n := mload($initializationCode)
            mstore(m, 0x64e03087) // `safeCreate2(bytes32,bytes)`.
            mstore(add(m, 0x20), $salt)
            mstore(add(m, 0x40), 0x40)
            mstore(add(m, 0x60), n)
            // prettier-ignore
            for { let i := 0 } lt(i, n) { i := add(i, 0x20) } {
                mstore(
                    add(add(m, 0x80), i),
                    mload(add(add($initializationCode, 0x20), i))
                )
            }
            if iszero(call(gas(), c2f, 0, add(m, 0x1c), add(n, 0x64), m, 0x20))
            {
                returndatacopy(m, m, returndatasize())
                revert(m, returndatasize())
            }
            $deployment := mload(m)
        }
    }

    /**
     * @notice Determine and retrieve the extcodesize of `deployment`.
     * @param $deployment The address to check.
     * @return $result The size of the code at `deployment`.
     */
    function _extcodesize(address $deployment)
        private
        view
        returns (uint256 $result)
    {
        /// @solidity memory-safe-assembly
        assembly {
            $result := extcodesize($deployment)
        }
    }
}
