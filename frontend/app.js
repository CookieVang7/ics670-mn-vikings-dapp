document.addEventListener('DOMContentLoaded', async () => {
    // Initialize Web3
    if (window.ethereum) {
      window.web3 = new Web3(window.ethereum);
      try {
        await window.ethereum.enable();
      } catch (error) {
        console.error("User denied account access");
      }
    } else if (window.web3) {
      window.web3 = new Web3(window.web3.currentProvider);
    } else {
      console.error("No Ethereum provider detected");
    }
  
    // Load contract ABI
    const contractAddress = '0x...'; // Replace with your contract address
    const contractAbi = [ /* Your contract ABI */ ];
    const contract = new web3.eth.Contract(contractAbi, contractAddress);
  
    // Get account address
    const accounts = await web3.eth.getAccounts();
    const account = accounts[0];
  
    // Event listener for 'Get Balance' button click
    document.getElementById('getBalanceButton').addEventListener('click', async () => {
      try {
        // Call contract method
        const balance = await contract.methods.getBalance().call({ from: account });
        document.getElementById('output').innerText = `Balance: ${balance}`;
      } catch (error) {
        console.error(error);
      }
    });
  });