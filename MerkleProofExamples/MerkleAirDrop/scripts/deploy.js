const { MerkleTree } = require("merkletreejs")
const keccak256 = require("keccak256")
const { ethers } = require("hardhat")
const toWei = (num) => ethers.utils.parseEther(num.toString())
const fromWei = (num) => ethers.utils.formatEther(num)

async function main() {
  //construct array of accounts to simulate whitelisted accounts for erc20 airdrop
  const [deployer, claimant1, claimant2, claimant3] = await ethers.getSigners()
  const TOKENS_IN_POOL = 10 // 1 million tokens

  //Construct merkle proof
  const leaves = [claimant1.address, claimant2.address, claimant3.address].map(
    (x) => keccak256(x)
  )
  const tree = new MerkleTree(leaves, keccak256, { sort: true })
  const root = tree.getHexRoot()
  let leaf = keccak256(claimant1.address)

  //test proof
  let proof = tree.getHexProof(leaf)
  console.log(tree.verify(proof, leaf, root)) // true

  //deploy contracts- [ERC20, MerkleDistributor]
  const DamnUselessTokenFactory = await ethers.getContractFactory(
    "DamnUselessToken",
    deployer
  )
  const MerkleDistributorFactory = await ethers.getContractFactory(
    "MerkleDistributor",
    deployer
  )

  this.token = await DamnUselessTokenFactory.deploy()
  this.distributor = await MerkleDistributorFactory.deploy(
    this.token.address,
    root
  )

  //Mint tokens and transfer balance to merkle distributor
  await this.token.transfer(this.distributor.address, TOKENS_IN_POOL)

  //Claim tokens with whitelisted accounts
  await this.distributor.claim(claimant1.address, proof)

  leaf = keccak256(claimant2.address)
  proof = tree.getHexProof(leaf)

  await this.distributor.claim(claimant2.address, proof)

  leaf = keccak256(claimant3.address)
  proof = tree.getHexProof(leaf)
  await this.distributor.claim(claimant3.address, proof)

  console.log(await this.token.balanceOf(claimant1.address))
  console.log(await this.token.balanceOf(this.distributor.address))
}

main().catch((error) => {
  console.error(error)
  process.exitCode = 1
})
