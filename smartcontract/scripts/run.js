const main = async () => {
  const [owner, randomPerson] = await hre.ethers.getSigners();
  const domainContractFactory = await hre.ethers.getContractFactory("Domains");
  const domainContract = await domainContractFactory.deploy("eth");
  await domainContract.deployed();
  console.log("Contract deployed to:", domainContract.address);
  console.log("Contract deployed by:", owner.address);

  let txn = await domainContract.register("jian", {
    value: hre.ethers.utils.parseEther("1"),
  });
  await txn.wait();

  const domainOwner = await domainContract.getAddress("jian");
  console.log("Owner of domain:", domainOwner);

  const balance = await hre.ethers.provider.getBalance(domainContract.address);
  console.log("Contract balance:", hre.ethers.utils.formatEther(balance));

  //trying to set a record that doesn't belong to me
  txn = await domainContract
    .connect(randomPerson)
    .setRecord("doom", "My domain now");
  await txn.wait();
};

const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (error) {
    console.log(error);
    process.exit(1);
  }
};

runMain();
