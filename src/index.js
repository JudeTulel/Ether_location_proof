const { Application, genesisBlockDevnet, configDevnet } = require('lisk-sdk');
const { LocationClaimTransaction } = require('./transactions/location_claim');

// Create the application instance
const app = new Application(genesisBlockDevnet, configDevnet);

// Register custom transactions
app.registerTransaction(LocationClaimTransaction);

// Start the application
app.run()
  .then(() => console.log('Blockchain running'))
  .catch(console.error);
