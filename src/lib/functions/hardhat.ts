import hre, { network } from 'hardhat'
import { Network } from 'hardhat/types'

import { Plug } from '@/core/framework'

import { constants } from '@nftchance/plug-types'

export const [name, version] = ['PlugMock', '0.0.0']

export default async function () {
	const chainId = await getChainId(network)

	const [owner, notOwner] = await hre.viem.getWalletClients()

	const contract = await hre.viem.deployContract(name, [name, version])

	const publicClient = await hre.viem.getPublicClient()

	const util = new Plug(name, version, chainId, constants.types, contract)

	return {
		chainId,
		name,
		version,
		contract,
		util,
		owner,
		notOwner,
		publicClient
	}
}

export async function getChainId(network: Network) {
	return await network.provider.send('eth_chainId').then(parseInt)
}
