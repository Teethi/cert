import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';




// class CertificateVerificationPage extends StatefulWidget {
//   final String contractAddress;
//   final String privateKey;

//   CertificateVerificationPage({required this.contractAddress, required this.privateKey});

//   @override
//   _CertificateVerificationPageState createState() => _CertificateVerificationPageState();
// }
// class _CertificateVerificationPageState extends State<CertificateVerificationPage> {
//   final TextEditingController _walletAddressController = TextEditingController();
//   final TextEditingController _serialNumberController = TextEditingController();
//   final _formKey = GlobalKey<FormState>();

//   bool _isSignedUp = false;
//   String _name = '';
//   String _degree = '';

//   @override
//   void dispose() {
//     _walletAddressController.dispose();
//     _serialNumberController.dispose();
//     super.dispose();
//   }

//   Future<void> _verifyCertificate() async {
//     if (!_formKey.currentState!.validate()) {
//       return;
//     }
//     final walletAddress = _walletAddressController.text;
//     final serialNumber = _serialNumberController.text;
//     // final contract = await CeloUtils.loadContract();

//     setState(() {
//       _isSignedUp = false;
//     });

//     try {
//       final isSignedUp = await contract.call('isSignedUp', [walletAddress]);
//       if (isSignedUp) {
//         final certificate = await contract.call('getCertificate', [walletAddress, serialNumber]);
//         setState(() {
//           _isSignedUp = true;
//           _name = certificate[0];
//           _degree = certificate[1];
//         });
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Wallet address is not signed up.')));
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Certificate Verification'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               TextFormField(
//                 controller: _walletAddressController,
//                 decoration: const InputDecoration(labelText: 'Wallet Address'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter a wallet address.';
//                   }
//                   if (!CeloUtils.isValidAddress(value)) {
//                     return 'Invalid wallet address.';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: _serialNumberController,
//                 decoration: const InputDecoration(labelText: 'Serial Number'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter a serial number.';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 16.0),
//               ElevatedButton(
//                 onPressed: _verifyCertificate,
//                 child: const Text('Verify Certificate'),
//               ),
//               const SizedBox(height: 16.0),
//               if (_isSignedUp)
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: [
//                     const Text('Certificate Details'),
//                     const SizedBox(height: 8.0),
//                     Text('Name: $_name'),
//                     Text('Degree: $_degree'),
//                   ],
//                 ),
//               if (!_isSignedUp)
//                 ElevatedButton(
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => CertificateSignUpPage()),
//                     );
//                   },
//                   child: const Text('Sign Up'),
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }








class SignUpPage extends StatefulWidget {
  final String walletAddress;

  SignUpPage({required this.walletAddress});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();

  bool _isLoading = false;
  String _errorMessage = '';

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _isLoading ? _buildLoadingIndicator() : _buildForm(),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const SizedBox(height: 16),
          const Text(
            'Please enter your details to sign up:',
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _firstNameController,
            decoration: const InputDecoration(
              labelText: 'First Name',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your first name';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _lastNameController,
            decoration: const InputDecoration(
              labelText: 'Last Name',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your last name';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: 'Email Address',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email address';
              }
              if (!EmailValidator.validate(value)) {
                return 'Please enter a valid email address';
              }
              return null;
            },
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: _onSubmit,
            child: const Text('Sign Up'),
          ),
          const SizedBox(height: 16),
          Text(
            _errorMessage,
            style: const TextStyle(color: Colors.red),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  void _onSubmit() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final firstName = _firstNameController.text;
      final lastName = _lastNameController.text;
      final email = _emailController.text;

      // final credentials = await ethCredentials(widget.walletAddress);

      // final contract = await loadContract();
      // final result = await contract
      //     .function('registerUser')
          // .call([firstName, lastName, email], credentials: credentials);

      // if (result != null) {
        // Navigator.pop(context);
      // } else {
        // setState(() {
          // _isLoading = false;
          // _errorMessage = 'Failed to sign up';
        // });
      // }
    }
  }
}