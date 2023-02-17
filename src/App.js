/** @format */

// import Navbar from "./Navbar";
import { useState } from 'react';
// import { uploadFileToIPFS, uploadJSONToIPFS } from "./pinata";
// import Marketplace from '../Marketplace.json';
import { useLocation } from 'react-router';
import { ethers } from 'ethers';

export default function App() {
  const [formParams, updateFormParams] = useState({
    name: '',
    uniName: '',
    course: '',
    month: '',
    year: 0,
    isApproved: false,
    isPending: false,
    address: '',
  });
  const [fileURL, setFileURL] = useState(null);
  // const ethers = require("ethers");
  const [message, updateMessage] = useState('');
  let [account, setAccount] = useState('');
  let [contractData, setContractData] = useState('');
  // const location = useLocation();
  const { ethereum } = window;
  const connectMetamask = async () => {
    if (window.ethereum !== 'undefined') {
      const accounts = await ethereum.request({
        method: 'eth_requestAccounts',
      });
      setAccount(accounts[0]);
    }
  };

  let contract;
  const connectContract = async () => {
    const Address = '0x52B788A262cbf7D918851eF6852C80dC96dd598c';
    const ABI = [
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
    ];
    console.log('done');
    const provider = new ethers.providers.Web3Provider(window.ethereum);
    const signer = provider.getSigner();
    console.log('donasde');
    contract = new ethers.Contract(Address, ABI, signer);
    console.log(contract.address);
  };

  const getData = async () => {
    const phrase = await contract.applyForCertificate(
      formParams.name,
      formParams.uniName,
      formParams.month,
      formParams.course,
      formParams.year,
      false,
      true,
      '0'
    );
    const arr = await phrase.wait();
    console.log(arr);
  };

  const changeData = async () => {
    const txResponse = await contract.getCertificateInfo();
    // const txReceipt = await txResponse.wait();
    console.log(txResponse)
  };

  // //This function uploads the NFT image to IPFS
  // async function OnChangeFile(e) {
  //     var file = e.target.files[0];
  //     //check for file extension
  //     try {
  //         //upload the file to IPFS
  //         const response = await uploadFileToIPFS(file);
  //         if(response.success === true) {
  //             console.log("Uploaded image to Pinata: ", response.pinataURL)
  //             setFileURL(response.pinataURL);
  //         }
  //     }
  //     catch(e) {
  //         console.log("Error during file upload", e);
  //     }
  // }

  // //This function uploads the metadata to IPFS
  // async function uploadMetadataToIPFS() {
  //     const {name, description, price} = formParams;
  //     //Make sure that none of the fields are empty
  //     if( !name || !description || !price || !fileURL)
  //         return;

  //     const nftJSON = {
  //         name, description, price, image: fileURL
  //     }

  //     try {
  //         //upload the metadata JSON to IPFS
  //         const response = await uploadJSONToIPFS(nftJSON);
  //         if(response.success === true){
  //             console.log("Uploaded JSON to Pinata: ", response)
  //             return response.pinataURL;
  //         }
  //     }
  //     catch(e) {
  //         console.log("error uploading JSON metadata:", e)
  //     }
  // }

  // async function listNFT(e) {
  //     e.preventDefault();

  //     //Upload data to IPFS
  //     try {
  //         const metadataURL = await uploadMetadataToIPFS();
  //         //After adding your Hardhat network to your metamask, this code will get providers and signers
  //         const provider = new ethers.providers.Web3Provider(window.ethereum);
  //         const signer = provider.getSigner();
  //         updateMessage("Please wait.. uploading (upto 5 mins)")

  //         //Pull the deployed contract instance
  //         let contract = new ethers.Contract(Marketplace.address, Marketplace.abi, signer)

  //         //massage the params to be sent to the create NFT request
  //         const price = ethers.utils.parseUnits(formParams.price, 'ether')
  //         let listingPrice = await contract.applyForCertificate()
  //         listingPrice = listingPrice.toString()

  //         //actually create the NFT
  //         let transaction = await contract.createToken(metadataURL, price, { value: listingPrice })
  //         await transaction.wait()

  //         alert("Successfully listed your NFT!");
  //         updateMessage("");
  //         updateFormParams({ name: '', description: '', price: ''});
  //         window.location.replace("/")
  //     }
  //     catch(e) {
  //         alert( "Upload error"+e )
  //     }
  // }

  // console.log("Working", process.env);
  return (
    <>
      <div class="mb-3">
        <label
          for="exampleFormControlInput1"
          class="form-label"
          onChange={(e) =>
            updateFormParams({ ...formParams, name: e.target.value })
          }
          value={formParams.name}>
          Name
        </label>
        <input
          type="email"
          class="form-control"
          id="exampleFormControlInput1"
          placeholder="name@example.com"
          onChange={(e) =>
            updateFormParams({ ...formParams, uniName: e.target.value })
          }
          value={formParams.uniName}/>
      
      </div>
      <div class="mb-3">
        <label
          for="exampleFormControlInput1"
          class="form-label">
          uniNAme
        </label>
        <input
          type="email"
          class="form-control"
          id="exampleFormControlInput1"
          placeholder="name@example.com"
          onChange={(e) =>
            updateFormParams({ ...formParams, name: e.target.value })
          }
          value={formParams.name}/>
     
      </div>
      <div class="mb-3">
        <label
          for="exampleFormControlInput1"
          class="form-label">
          Email address
        </label>
        <input
          type="email"
          class="form-control"
          id="exampleFormControlInput1"
          placeholder="name@example.com"
        />
      </div>
      <div class="mb-3">
        <label
          for="exampleFormControlInput1"
          class="form-label">
          Email address
        </label>
        <input
          type="email"
          class="form-control"
          id="exampleFormControlInput1"
          placeholder="name@example.com"
        />
      </div>
      <div class="mb-3">
        <label
          for="exampleFormControlInput1"
          class="form-label">
          Email address
        </label>
        <input
          type="email"
          class="form-control"
          id="exampleFormControlInput1"
          placeholder="name@example.com"
        />
      </div>
      <div class="mb-3">
        <label
          for="exampleFormControlInput1"
          class="form-label">
          Email address
        </label>
        <input
          type="email"
          class="form-control"
          id="exampleFormControlInput1"
          placeholder="name@example.com"
        />
      </div>
      <button onClick={getData}> store </button>
      <button onClick={connectMetamask}>CONNECT TO METAMASK</button>
      <button onClick={connectContract}>CONNECT TO CONTRACT</button> <br />{' '}
      <br />
      <p>{account}</p>
      {/* <button
        type="button"
        class="btn btn-primary"
        onClick={getData}>
        Primary
      </button>
      <button onClick={changeData}>CONNECT TO CONTRACT</button>\
      <p>{contractData}</p> */}
    </>
  );
}
