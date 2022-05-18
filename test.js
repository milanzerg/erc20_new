// Right click on the script name and hit "Run" to execute
const { expect } = require("chai");

describe("Test 1", function () {
  it("test initial value", async function () {
    // Make sure contract is compiled and artifacts are generated
    const metadata = JSON.parse(await remix.call('fileManager', 'getFile', 'contracts/artifacts/Owner.json'))
    const signer = (new ethers.providers.Web3Provider(web3Provider)).getSigner()
    let Value_zero = new ethers.ContractFactory(metadata.abi, metadata.data.bytecode.object, signer);
    let value_zero = await Value_zero.deploy();

    console.log('value_zero Address: ' + value_zero.address); // logs
    expect((value_zero.address).length).to.equal(42); // length of the address should equal to 42
  });

});
