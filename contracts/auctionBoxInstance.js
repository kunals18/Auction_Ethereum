import web3 from './web3';

// THE CONTRACT ADDRESS
const address = '0x1DA9a400417A2A927295A30FB6FdD03fd48829C9';

const abi = [
  {
    constant: false,
    inputs: [
      {
        name: '_title',
        type: 'string'
      },
      {
        name: '_startPrice',
        type: 'uint256'
      },
      {
        name: '_description',
        type: 'string'
      }
    ],
    name: 'createAuction',
    outputs: [],
    payable: false,
    stateMutability: 'nonpayable',
    type: 'function'
  },
  {
    constant: true,
    inputs: [
      {
        name: '',
        type: 'uint256'
      }
    ],
    name: 'auctions',
    outputs: [
      {
        name: '',
        type: 'address'
      }
    ],
    payable: false,
    stateMutability: 'view',
    type: 'function'
  },
  {
    constant: true,
    inputs: [],
    name: 'returnAllAuctions',
    outputs: [
      {
        name: '',
        type: 'address[]'
      }
    ],
    payable: false,
    stateMutability: 'view',
    type: 'function'
  }
];

const instance = new web3.eth.Contract(abi, address);

export default instance;
