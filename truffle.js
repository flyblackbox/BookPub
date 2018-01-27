module.exports = {
  networks: {
    development: {
      host: 'localhost',
      port: 8545,
      network_id: '*', // Match any network id
      gas: 5000000,
    },
    rinkeby: {
      host: 'localhost', // Connect to geth on the specified
      port: 8545,
      from: '0xbf0aef7fad9839565bf78e0c6cbea1810726347d',
      network_id: 4,
      gas: 4612388, // Gas limit used for deploys
    },
  },
};
