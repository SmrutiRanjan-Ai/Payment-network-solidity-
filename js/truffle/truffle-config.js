module.exports = {
rpc: {
host:"localhost",
port:8543
},
networks: {
development: {
host: "localhost", //our network is running on localhost
port: 3000, // port where your blockchain is running
network_id: "*",
from: "0x9ac35a1da4cccfde9979a1ccd34a95852ebca3fe", // use the account-id generated during the setup process
gas: 20000000
}
}
};
