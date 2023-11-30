import deploy, { name, version } from '../lib/functions/hardhat'
import { loadFixture } from '@nomicfoundation/hardhat-toolbox/network-helpers'

import { expect } from 'chai'
import { encodeFunctionData, getAddress } from 'viem'

const BASE_AUTH =
	'0x0000000000000000000000000000000000000000000000000000000000000000'

describe('Plug', function () {
	it('pass: instantiate a PlugUtil class instance', async function () {
		const { chainId, contract, util } = await loadFixture(deploy)

		expect(util).to.not.be.null.and.not.be.undefined
		expect(util.info).to.not.be.null

		expect(util.info?.domain).to.eql({
			chainId: chainId,
			verifyingContract: contract.address,
			name,
			version
		})
	})

	// * Run a test from start to finish for a LivePin.
	it('pass: getLivePinSigner', async function () {
		const { util, contract, owner } = await loadFixture(deploy)

		// * Create a Pin.
		const pin = {
			neutral: getAddress(owner.account.address),
			live: BASE_AUTH,
			fuses: [],
			salt: BASE_AUTH
		} as const

		// * Sign the pin to make it executable.
		const signedPin = await util.sign(owner, 'Pin', pin)

		if (!signedPin) expect.fail('Live intent does not exist.')

		// * Retrieve the object that will be passed onchain.
		const LivePin = signedPin.intent

		if (!LivePin) expect.fail('Plug could not be signed.')

		// * Make sure the intent signer matched the recovered signer.
		expect(getAddress(owner.account.address)).to.eq(
			await signedPin.address({})
		)
		expect(
			await signedPin.verify({
				address: getAddress(owner.account.address)
			})
		).to.be.true
		expect(getAddress(owner.account.address)).to.eq(
			await contract.read.getLivePinSigner([LivePin])
		)
	})

	// * Run a test from start to finish for a LivePlugs.
	it('pass: getLivePlugsSigner(LivePlug memory signedPlug)', async function () {
		const { util, contract, owner, notOwner } = await loadFixture(deploy)

		// * Create a Pin.
		const pin = {
			neutral: getAddress(owner.account.address),
			live: BASE_AUTH,
			fuses: [],
			salt: BASE_AUTH
		} as const

		// * Sign the pin to make it executable.
		const signedPin = await util.sign(owner, 'Pin', pin)

		if (!signedPin) expect.fail('Live intent does not exist.')

		// * Retrieve the object that will be passed onchain.
		const LivePin = signedPin.intent

		if (!LivePin) expect.fail('Plug could not be signed.')

		expect(await contract.read.getLivePinSigner([LivePin])).to.eq(
			getAddress(owner.account.address)
		)

		const encodedTransaction = encodeFunctionData({
			abi: contract.abi,
			functionName: 'mutedEcho'
		})

		const signedPlug = await util.sign(notOwner, 'Plugs', {
			breaker: {
				nonce: 1n,
				queue: 0n
			},
			plugs: [
				{
					pins: [LivePin],
					current: {
						ground: getAddress(owner.account.address),
						voltage: 21000n,
						data: encodedTransaction
					}
				}
			]
		})

		if (!signedPlug) expect.fail('Live intent does not exist.')
		if (!signedPlug.intent) expect.fail('Plug does not exist.')

		const LivePlug = signedPlug.intent

		expect(await contract.read.getLivePlugsSigner([LivePlug])).to.eq(
			getAddress(notOwner.account.address)
		)
	})

	it('fail: signedPlugs: mutedEcho()', async function () {
		const { util, contract, owner } = await loadFixture(deploy)

		const encodedTransaction = encodeFunctionData({
			abi: contract.abi,
			functionName: 'mutedEcho'
		})

		const signedPlugs = await util.sign(owner, 'Plugs', {
			breaker: {
				nonce: 1n,
				queue: 0n
			},
			plugs: [
				{
					pins: [],
					current: {
						ground: contract.address,
						voltage: 21000n,
						data: encodedTransaction
					}
				}
			]
		})

		if (!signedPlugs) expect.fail('Live intent does not exist.')

		// * Retrieve the object that will be passed onchain.
		const LivePlugs = signedPlugs.intent

		if (!LivePlugs) expect.fail('Plug could not be signed.')

		await expect(contract.write.plug([[LivePlugs]])).to.be.rejectedWith(
			'EchoMuted'
		)
	})
})