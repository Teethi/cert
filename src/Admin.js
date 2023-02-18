/** @format */

import React from 'react';
import { useState } from 'react';
// import { uploadFileToIPFS, uploadJSONToIPFS } from "./pinata";
// import Marketplace from '../Marketplace.json';
import { useLocation } from 'react-router';
import { ethers } from 'ethers';
// import  Done , { contract } from './Done';
let contract;
function Admin() {
  let [account, setAccount] = useState('');
  const { ethereum } = window;
  const connectMetamask = async () => {
    if (window.ethereum !== 'undefined') {
      const accounts = await ethereum.request({
        method: 'eth_requestAccounts',
      });
      setAccount(accounts[0]);
    }
  };

  const connectContract = async () => {
    const Address = '0xF2c8C4160Ba9A39791322faa24f392ae14D0e605';
    const ABI = [
      {
        inputs: [],
        stateMutability: 'nonpayable',
        type: 'constructor',
      },
      {
        anonymous: false,
        inputs: [
          {
            indexed: true,
            internalType: 'address',
            name: 'owner',
            type: 'address',
          },
          {
            indexed: true,
            internalType: 'address',
            name: 'approved',
            type: 'address',
          },
          {
            indexed: true,
            internalType: 'uint256',
            name: 'tokenId',
            type: 'uint256',
          },
        ],
        name: 'Approval',
        type: 'event',
      },
      {
        anonymous: false,
        inputs: [
          {
            indexed: true,
            internalType: 'address',
            name: 'owner',
            type: 'address',
          },
          {
            indexed: true,
            internalType: 'address',
            name: 'operator',
            type: 'address',
          },
          {
            indexed: false,
            internalType: 'bool',
            name: 'approved',
            type: 'bool',
          },
        ],
        name: 'ApprovalForAll',
        type: 'event',
      },
      {
        anonymous: false,
        inputs: [
          {
            indexed: false,
            internalType: 'address',
            name: 'user',
            type: 'address',
          },
          {
            indexed: false,
            internalType: 'uint256',
            name: 'serialNumber',
            type: 'uint256',
          },
        ],
        name: 'CertificateApproved',
        type: 'event',
      },
      {
        anonymous: false,
        inputs: [
          {
            indexed: false,
            internalType: 'uint256',
            name: 'tokenId',
            type: 'uint256',
          },
          {
            indexed: false,
            internalType: 'string',
            name: 'cid',
            type: 'string',
          },
          {
            indexed: false,
            internalType: 'uint256',
            name: 'date',
            type: 'uint256',
          },
          {
            indexed: false,
            internalType: 'address',
            name: 'from',
            type: 'address',
          },
          {
            indexed: false,
            internalType: 'address',
            name: 'to',
            type: 'address',
          },
        ],
        name: 'CertificateNFTCreated',
        type: 'event',
      },
      {
        anonymous: false,
        inputs: [
          {
            indexed: false,
            internalType: 'string',
            name: 'cid',
            type: 'string',
          },
          {
            indexed: false,
            internalType: 'uint256',
            name: 'date',
            type: 'uint256',
          },
          {
            indexed: false,
            internalType: 'uint256',
            name: 'price',
            type: 'uint256',
          },
          {
            indexed: false,
            internalType: 'address',
            name: 'from',
            type: 'address',
          },
        ],
        name: 'CertificateTemplateCreated',
        type: 'event',
      },
      {
        anonymous: false,
        inputs: [
          {
            indexed: true,
            internalType: 'address',
            name: 'from',
            type: 'address',
          },
          {
            indexed: true,
            internalType: 'address',
            name: 'to',
            type: 'address',
          },
          {
            indexed: true,
            internalType: 'uint256',
            name: 'tokenId',
            type: 'uint256',
          },
        ],
        name: 'Transfer',
        type: 'event',
      },
      {
        inputs: [],
        name: '_nftsid',
        outputs: [
          {
            internalType: 'uint256',
            name: '_value',
            type: 'uint256',
          },
        ],
        stateMutability: 'view',
        type: 'function',
      },
      {
        inputs: [
          {
            internalType: 'string',
            name: 'name',
            type: 'string',
          },
          {
            internalType: 'string',
            name: 'uniName',
            type: 'string',
          },
          {
            internalType: 'string',
            name: 'course',
            type: 'string',
          },
          {
            internalType: 'string',
            name: 'month',
            type: 'string',
          },
          {
            internalType: 'uint256',
            name: 'year',
            type: 'uint256',
          },
          {
            internalType: 'bool',
            name: 'isApproved',
            type: 'bool',
          },
          {
            internalType: 'bool',
            name: 'isApplied',
            type: 'bool',
          },
          {
            internalType: 'address',
            name: 'user',
            type: 'address',
          },
        ],
        name: 'applyForCertificate',
        outputs: [],
        stateMutability: 'nonpayable',
        type: 'function',
      },
      {
        inputs: [
          {
            internalType: 'address',
            name: 'to',
            type: 'address',
          },
          {
            internalType: 'uint256',
            name: 'tokenId',
            type: 'uint256',
          },
        ],
        name: 'approve',
        outputs: [],
        stateMutability: 'nonpayable',
        type: 'function',
      },
      {
        inputs: [
          {
            internalType: 'bool',
            name: 'isApproved',
            type: 'bool',
          },
          {
            internalType: 'address',
            name: 'user',
            type: 'address',
          },
        ],
        name: 'approveCertificate',
        outputs: [],
        stateMutability: 'nonpayable',
        type: 'function',
      },
      {
        inputs: [
          {
            internalType: 'address',
            name: 'owner',
            type: 'address',
          },
        ],
        name: 'balanceOf',
        outputs: [
          {
            internalType: 'uint256',
            name: '',
            type: 'uint256',
          },
        ],
        stateMutability: 'view',
        type: 'function',
      },
      {
        inputs: [
          {
            internalType: 'string',
            name: '',
            type: 'string',
          },
        ],
        name: 'certificateTemplateList',
        outputs: [
          {
            internalType: 'string',
            name: 'cid',
            type: 'string',
          },
          {
            internalType: 'uint256',
            name: 'date',
            type: 'uint256',
          },
          {
            internalType: 'uint256',
            name: 'price',
            type: 'uint256',
          },
          {
            internalType: 'address',
            name: 'from',
            type: 'address',
          },
        ],
        stateMutability: 'view',
        type: 'function',
      },
      {
        inputs: [
          {
            internalType: 'address',
            name: '',
            type: 'address',
          },
        ],
        name: 'certificates',
        outputs: [
          {
            internalType: 'string',
            name: 'name',
            type: 'string',
          },
          {
            internalType: 'string',
            name: 'uniName',
            type: 'string',
          },
          {
            internalType: 'string',
            name: 'month',
            type: 'string',
          },
          {
            internalType: 'string',
            name: 'course',
            type: 'string',
          },
          {
            internalType: 'uint256',
            name: 'year',
            type: 'uint256',
          },
          {
            internalType: 'bool',
            name: 'isApproved',
            type: 'bool',
          },
          {
            internalType: 'bool',
            name: 'isApplied',
            type: 'bool',
          },
          {
            internalType: 'address',
            name: 'user',
            type: 'address',
          },
        ],
        stateMutability: 'view',
        type: 'function',
      },
      {
        inputs: [
          {
            internalType: 'string',
            name: '_cid',
            type: 'string',
          },
          {
            internalType: 'uint256',
            name: '_price',
            type: 'uint256',
          },
        ],
        name: 'createCertificateTemplate',
        outputs: [],
        stateMutability: 'nonpayable',
        type: 'function',
      },
      {
        inputs: [
          {
            internalType: 'uint256',
            name: 'tokenId',
            type: 'uint256',
          },
        ],
        name: 'getApproved',
        outputs: [
          {
            internalType: 'address',
            name: '',
            type: 'address',
          },
        ],
        stateMutability: 'view',
        type: 'function',
      },
      {
        inputs: [],
        name: 'getCertificateInfo',
        outputs: [
          {
            internalType: 'string',
            name: '',
            type: 'string',
          },
          {
            internalType: 'string',
            name: '',
            type: 'string',
          },
          {
            internalType: 'string',
            name: '',
            type: 'string',
          },
          {
            internalType: 'string',
            name: '',
            type: 'string',
          },
          {
            internalType: 'uint256',
            name: '',
            type: 'uint256',
          },
          {
            internalType: 'bool',
            name: '',
            type: 'bool',
          },
          {
            internalType: 'bool',
            name: '',
            type: 'bool',
          },
          {
            internalType: 'address',
            name: '',
            type: 'address',
          },
        ],
        stateMutability: 'view',
        type: 'function',
      },
      {
        inputs: [
          {
            internalType: 'address',
            name: 'owner',
            type: 'address',
          },
          {
            internalType: 'address',
            name: 'operator',
            type: 'address',
          },
        ],
        name: 'isApprovedForAll',
        outputs: [
          {
            internalType: 'bool',
            name: '',
            type: 'bool',
          },
        ],
        stateMutability: 'view',
        type: 'function',
      },
      {
        inputs: [
          {
            internalType: 'string',
            name: '_cid',
            type: 'string',
          },
          {
            internalType: 'address',
            name: '_to',
            type: 'address',
          },
        ],
        name: 'mintCertificateNFT',
        outputs: [],
        stateMutability: 'nonpayable',
        type: 'function',
      },
      {
        inputs: [],
        name: 'name',
        outputs: [
          {
            internalType: 'string',
            name: '',
            type: 'string',
          },
        ],
        stateMutability: 'view',
        type: 'function',
      },
      {
        inputs: [
          {
            internalType: 'uint256',
            name: 'tokenId',
            type: 'uint256',
          },
        ],
        name: 'ownerOf',
        outputs: [
          {
            internalType: 'address',
            name: '',
            type: 'address',
          },
        ],
        stateMutability: 'view',
        type: 'function',
      },
      {
        inputs: [
          {
            internalType: 'address',
            name: 'from',
            type: 'address',
          },
          {
            internalType: 'address',
            name: 'to',
            type: 'address',
          },
          {
            internalType: 'uint256',
            name: 'tokenId',
            type: 'uint256',
          },
        ],
        name: 'safeTransferFrom',
        outputs: [],
        stateMutability: 'nonpayable',
        type: 'function',
      },
      {
        inputs: [
          {
            internalType: 'address',
            name: 'from',
            type: 'address',
          },
          {
            internalType: 'address',
            name: 'to',
            type: 'address',
          },
          {
            internalType: 'uint256',
            name: 'tokenId',
            type: 'uint256',
          },
          {
            internalType: 'bytes',
            name: 'data',
            type: 'bytes',
          },
        ],
        name: 'safeTransferFrom',
        outputs: [],
        stateMutability: 'nonpayable',
        type: 'function',
      },
      {
        inputs: [
          {
            internalType: 'address',
            name: 'operator',
            type: 'address',
          },
          {
            internalType: 'bool',
            name: 'approved',
            type: 'bool',
          },
        ],
        name: 'setApprovalForAll',
        outputs: [],
        stateMutability: 'nonpayable',
        type: 'function',
      },
      {
        inputs: [
          {
            internalType: 'bytes4',
            name: 'interfaceId',
            type: 'bytes4',
          },
        ],
        name: 'supportsInterface',
        outputs: [
          {
            internalType: 'bool',
            name: '',
            type: 'bool',
          },
        ],
        stateMutability: 'view',
        type: 'function',
      },
      {
        inputs: [],
        name: 'symbol',
        outputs: [
          {
            internalType: 'string',
            name: '',
            type: 'string',
          },
        ],
        stateMutability: 'view',
        type: 'function',
      },
      {
        inputs: [
          {
            internalType: 'uint256',
            name: 'tokenId',
            type: 'uint256',
          },
        ],
        name: 'tokenURI',
        outputs: [
          {
            internalType: 'string',
            name: '',
            type: 'string',
          },
        ],
        stateMutability: 'view',
        type: 'function',
      },
      {
        inputs: [
          {
            internalType: 'address',
            name: 'from',
            type: 'address',
          },
          {
            internalType: 'address',
            name: 'to',
            type: 'address',
          },
          {
            internalType: 'uint256',
            name: 'tokenId',
            type: 'uint256',
          },
        ],
        name: 'transferFrom',
        outputs: [],
        stateMutability: 'nonpayable',
        type: 'function',
      },
    ];

    console.log('done');
    const provider = new ethers.providers.Web3Provider(window.ethereum);
    console.log('done');
    
      const signer = provider.getSigner();
      console.log('donasde');
      contract = new ethers.Contract(Address, ABI, signer);
    console.log(contract.address);
  };
  const changeData = async () => {
    const txResponse = await contract.getCertificateInfo();
    console.log(txResponse);
    const { 0: a, 1: b, 2: c, 3: d, 4: e, 5: f, 6: g, 7: h } = txResponse;
    // const txReceipt = await txResponse.wait();
    console.log(a);
  };

  return (
    <div>
      <button onClick={changeData}> store </button>
      <button onClick={connectMetamask}>CONNECT TO METAMASK</button>
      <button onClick={connectContract}>CONNECT TO CONTRACT</button> <br />{' '}
      <br />
      <p>{account}</p>
    </div>
  );
}

export default Admin;
