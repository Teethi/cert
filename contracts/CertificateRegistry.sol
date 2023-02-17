// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
//B-CELO
contract CertificateRegistry {
    // Define the struct to store certificate information
    struct Certificate {
        string name;
        string uniName;
        string month;
         string course;
        uint256 year;
       
        bool isApproved;
        bool isApplied;
        address user;
    }

    // Mapping to store certificate information
    mapping(address => Certificate) public certificates;

    // Event to emit upon approval of a certificate
    event CertificateApproved(address user, uint256 serialNumber);

    // Function for users to apply for a certificate
    function applyForCertificate(
        string memory name,
        string memory uniName,
        string memory course,
        string memory month,
        uint256 year,
        bool isApproved,
        bool isApplied,
        address user
    ) public {
        user= msg.sender;
        certificates[msg.sender] = Certificate(name, uniName, course, month, year, false, true, user);
    }

    // Function for the institution/organization to approve a certificate
    function approveCertificate(
        bool isApproved,address user
    ) public {
        Certificate storage certificate = certificates[user];
        require(
            !certificate.isApproved,
            "Certificate has already been approved"
        );
        certificate.isApproved = true;
        certificate.user = user;
        // emit CertificateApproved(user);
    }
 
    // Function for users to get their certificate serial number and QR code
    function getCertificateInfo() public view returns (string memory, string memory, string memory, string memory, uint256,bool, bool, address) {
        Certificate storage certificate = certificates[msg.sender];
     
        // bytes32 qrCode = keccak256(
        //     abi.encodePacked(certificate.serialNumber, msg.sender)
        // );
        return (certificate.name,certificate.uniName, certificate.course, certificate.month, certificate.year, true, false, msg.sender);
    }

    // Function for organizations to verify a certificate
    // function verifyCertificate(
    //     uint256 serialNumber,
    //     address user
    // ) public view returns (bool) {
    //     Certificate storage certificate = certificates[user];
    //     return
    //         certificate.isApproved && certificate.serialNumber == serialNumber;
    // }
}