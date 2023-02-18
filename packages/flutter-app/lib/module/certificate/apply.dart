import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';

class SignUpPage extends StatefulWidget {
  final String walletAddress;

  SignUpPage({
    required this.walletAddress,
    Key? key,
  }) : super(key: key);
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _universityController = TextEditingController();
  final TextEditingController _monthController = TextEditingController();
  final TextEditingController _degreeController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _course = TextEditingController();
  late Client httpClient;
  late Web3Client ethClient;

  @override
  void initState() {
    super.initState();
    httpClient = Client();
    ethClient = Web3Client(
        'https://polygon-mumbai.g.alchemy.com/v2/UVQD7tAU7RwKHWZ7Pv3E7nbwMAJEsWLF',
        httpClient);
    // getbalance(widget.walletAddress);
  }

  Future<DeployedContract> loadContract() async {
    
    String abiCode =
        await rootBundle.loadString('assets/CertificateRegistry.json');
    String contractAddress = '0xf2548Ed43a974b611B128850436a23CC984CF7f3';
    final DeployedContract contract = DeployedContract(
        ContractAbi.fromJson(abiCode, 'CertificateRegistry'),
        EthereumAddress.fromHex(contractAddress));
    return contract;
  }



  Future<void> submit(String functionName, List<dynamic> args) async {
    try{
      EthPrivateKey credentials = EthPrivateKey.fromHex(
        '0a92e926d459c9c85d96ba0ef9e83cea283012ea3e405dbe4155a5f5cd90f416');
    DeployedContract contract = await loadContract();
    final ethFunction = contract.function(functionName);
    await ethClient.sendTransaction(
        credentials,
        Transaction.callContract(
            contract: contract, function: ethFunction, parameters: args),
        fetchChainIdFromNetworkId: true);
    }
    catch(e){
      print(e);
    }
    
  }

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
      appBar: AppBar(title: const Text('Apply')),
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
            'Please enter your details to request for the certificate:',
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _firstNameController,
            decoration: const InputDecoration(
              labelText: 'First Name',
              border: OutlineInputBorder(),
            ),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your first name';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _universityController,
            decoration: const InputDecoration(
              labelText: 'University Name',
              border: OutlineInputBorder(),
            ),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your University Name';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _course,
            decoration: const InputDecoration(
              labelText: 'Course Name',
              border: OutlineInputBorder(),
            ),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your University Name';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _monthController,
            decoration: const InputDecoration(
              labelText: 'Month',
              border: OutlineInputBorder(),
            ),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your Month of Graduation';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _yearController,
            decoration: const InputDecoration(
              labelText: 'Year',
              border: OutlineInputBorder(),
            ),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your Year of Graduation';
              }
              return null;
            },
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                setState(() {
                  _isLoading = true;
                });
                try {
                  await submit('applyForCertificate', [
                    _firstNameController.text,
                    _universityController.text,
                    _course.text,
                    _monthController.text,
                    BigInt.from(int.parse(_yearController.text)),
                    false,
                    true,
                    widget.walletAddress
                  ]);

                  setState(() {
                    _isLoading = false;
                  });
                  Navigator.pop(context, true);
                } catch (e) {
                  print(e);
                  setState(() {
                    _isLoading = false;
                    _errorMessage = e.toString();
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $_errorMessage')),
                  );
                }
              }
            },
            child: const Text('Submit'),
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
}
