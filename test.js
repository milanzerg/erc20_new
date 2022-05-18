// Right click on the script name and hit "Run" to execute
const { expect } = require("chai");

describe("Test 1", function () {
  it("test initial value", async function () {
    // Make sure contract is compiled and artifacts are generated
    const metadata = JSON.parse(await remix.call('fileManager', 'getFile', 'contracts/artifacts/Owner.json'))
    const signer = (new ethers.providers.Web3Provider(web3Provider)).getSigner()
    let Address = new ethers.ContractFactory(metadata.abi, metadata.data.bytecode.object, signer);
    let address_0 = await Address.deploy();

    console.log('value_zero Address: ' + address_0.address); // logs
    expect((address_0.address).length).to.equal(42); // length of the address should equal to 42
  });

});
