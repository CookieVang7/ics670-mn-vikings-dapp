const cut = artifacts.require("CoachProposal");

contract("CoachProposal", (accounts) => {
    it("get available coaches", async () => {
        const votingMechanismAddress = accounts[1];
        const contractInstance = await cut.new(votingMechanismAddress);
        const votingAddress = await contractInstance.VotingMechanismAddress();

        assert.equal(votingAddress,votingMechanismAddress, "Bruh");

        const result = await contractInstance.getAvailableCoaches();

        assert.equal(result.length, 5);
    })
})