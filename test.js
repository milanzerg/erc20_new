// Right click on the script name and hit "Run" to execute
const { expect } = require("chai");

describe("Test", function () {
  it("Some tests with chai", async function () {
    var a = 4;
    var b = 8;
    var sum = 12;
    expect(a).to.equal(4);
    expect(b).to.equal(8);
    expect(a+b).to.equal(sum);
  });
});
