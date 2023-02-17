import 'package:flutter_celo_composer/services/auth/auth_service.dart';
import 'package:flutter_celo_composer/utilities/dialogs/delete_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_celo_composer/services/cloud/concession/cloud_concession.dart';
import 'package:flutter_celo_composer/services/cloud/concession/firebase_cloud_storage_concession.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ConcessionRegister extends StatefulWidget {
  const ConcessionRegister({super.key});

  @override
  State<ConcessionRegister> createState() => _ConcessionRegisterState();
}

class _ConcessionRegisterState extends State<ConcessionRegister> {
  DateTime? _dob;
  late final TextEditingController _address;
  final String _destStation = "Andheri";
  late final TextEditingController _nearestStation;
  late final TextEditingController _name;
  late final TextEditingController _lastName;
  late final String _email;
  String _gender = "Male";
  late final DateTime now;

  final currentUser = AuthService.firebase().currentUser!;

  CloudConcession? _concession;
  late final FirebaseCloudStorageConcession _concessionService;

  @override
  void initState() {
    now = DateTime.now();

    _concessionService = FirebaseCloudStorageConcession();
    _name = TextEditingController();
    _lastName = TextEditingController();
    _nearestStation = TextEditingController();
    _address = TextEditingController();
    _email = currentUser.email;

    _name.text = '';
    _lastName.text = '';
    _nearestStation.text = '';
    _address.text = '';

    super.initState();
  }

  Future<CloudConcession> createNewConcession() async {
    final existingConcession = _concession;
    if (existingConcession != null) {
      return existingConcession;
    }
    final userId = currentUser.id;
    final email = currentUser.email;
    final newConcession = await _concessionService.createNewConcession(
      userId: userId,
      name: "${_name.text} ${_lastName.text}",
      gender: _gender,
      email: email,
      nearestStation: _nearestStation.text,
      address: _address.text,
      dob: "${_dob!.day}/${_dob!.month}/${_dob!.year}",
      destinationStation: _destStation,
    );
    _concession = newConcession;
    return newConcession;
  }

  @override
  void dispose() {
    _name.dispose();
    _lastName.dispose();
    _address.dispose();
    _nearestStation.dispose();
    super.dispose();
  }

  void gender(String? selectedvalue) {
    if (selectedvalue is String) {
      setState(() {
        _gender = selectedvalue;
      });
    }
  }

  InputDecoration getCommonInputDecoration(String text, Widget? prefixIcon) {
    return InputDecoration(
      hintText: text,
      prefixIcon: prefixIcon,
      hintStyle: const TextStyle(
        color: Color(0xff979797),
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      border: InputBorder.none,
      focusedBorder: InputBorder.none,
      enabledBorder: InputBorder.none,
      contentPadding: const EdgeInsets.all(10),
    );
  }

  final commonBoxDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(20),
    // color: Color(0xffe4eaef),
    // color: Colors.red,
    gradient: const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0xfff5f7fa),
        Color(0xffe7edf2),
      ],
    ),

    boxShadow: const [
      BoxShadow(
        color: Color(0xffabc2d4),
        spreadRadius: 0.0,
        blurRadius: 6.0,
        offset: Offset(4, 4),
      ),
      BoxShadow(
        color: Colors.white,
        spreadRadius: 0.0,
        blurRadius: 6.0,
        offset: Offset(-4, -4),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xff15001C),
        toolbarHeight: 115,
        automaticallyImplyLeading: false,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        centerTitle: true,
        title: const Expanded(
          child: Text(
            'Railway Concession Form',
            style: TextStyle(
              color: Color(0xff2af6ff),
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.visible,
          ),
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: const Icon(
            Icons.arrow_back_ios,
          ),
        ),
        flexibleSpace: Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(
            left: 31.0,
          ),
        ),
      ),
      body: ListView(
        children: [
          const SizedBox(
            height: 25,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: const EdgeInsets.only(left: 30),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                height: 50,
                alignment: Alignment.centerLeft,
                width: MediaQuery.of(context).size.width * 0.35,
                decoration: commonBoxDecoration,
                child: TextField(
                  style: const TextStyle(
                    color: Color(0xff000028),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  controller: _name,
                  decoration: getCommonInputDecoration("First Name", null),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(right: 30),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                alignment: Alignment.centerLeft,
                height: 50,
                width: MediaQuery.of(context).size.width * 0.35,
                decoration: commonBoxDecoration,
                child: TextField(
                  controller: _lastName,
                  decoration: getCommonInputDecoration("Last Name", null),
                ),
              )
            ],
          ),
          Container(
            margin:
                const EdgeInsets.only(top: 23, left: 30, right: 30, bottom: 23),
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            alignment: Alignment.centerLeft,
            height: 50,
            width: MediaQuery.of(context).size.width * 0.35,
            decoration: commonBoxDecoration,
            child: Text(currentUser.email),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 30.0, bottom: 18),
            child: Text('Gender',
                style: TextStyle(
                  color: Color(0xff311b61),
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.left,
                overflow: TextOverflow.visible),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    _gender = "Male";
                  });
                },
                child: Row(
                  children: [
                    _gender == "Male"
                        ? SvgPicture.asset(
                            'assets/images/icon/checked.svg',
                            width: 17,
                            height: 17,
                          )
                        : Container(
                            width: 17,
                            height: 17,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: const Color(0xff000028),
                                width: 1,
                              ),
                            ),
                          ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text(
                      'Male',
                      style: TextStyle(
                        color: Color(0xff311b61),
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    _gender = "Female";
                  });
                },
                child: Row(
                  children: [
                    _gender == "Female"
                        ? SvgPicture.asset(
                            'assets/images/icon/checked.svg',
                            width: 17,
                            height: 17,
                          )
                        : Container(
                            width: 17,
                            height: 17,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: const Color(0xff000028),
                                width: 1,
                              ),
                            ),
                          ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text(
                      'Female',
                      style: TextStyle(
                        color: Color(0xff311b61),
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    _gender = "Other";
                  });
                },
                child: Row(
                  children: [
                    _gender == "Other"
                        ? SvgPicture.asset(
                            'assets/images/icon/checked.svg',
                            width: 17,
                            height: 17,
                          )
                        : Container(
                            width: 17,
                            height: 17,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: const Color(0xff000028),
                                width: 1,
                              ),
                            ),
                          ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text(
                      'Other',
                      style: TextStyle(
                        color: Color(0xff311b61),
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          InkWell(
            onTap: () async {
              DateTime? dob = await showDatePicker(
                context: context,
                initialDate: DateTime(2002, 01, 01),
                firstDate: DateTime(1900),
                lastDate: DateTime(now.year),
              );
              if (dob == null) {
                return;
              }
              setState(() => _dob = dob);
            },
            child: Container(
              margin: const EdgeInsets.only(
                top: 23,
                left: 30,
                right: 30,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 22,
              ),
              alignment: Alignment.centerLeft,
              height: 50,
              // width: MediaQuery.of(context).size.width * 0.35,
              // color: Colors.red,
              decoration: commonBoxDecoration,
              child: Text(
                _dob == null
                    ? "Date of Birth"
                    : "${_dob!.day}/${_dob!.month}/${_dob!.year}",
                style: TextStyle(
                  color: _dob == null
                      ? const Color(0xff979797)
                      : const Color(0xff101828),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(
              top: 23,
              left: 30,
              right: 30,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            alignment: Alignment.centerLeft,
            height: 50,
            width: MediaQuery.of(context).size.width * 0.35,
            // color: Colors.red,
            decoration: commonBoxDecoration,
            child: TextField(
              controller: _nearestStation,
              decoration: getCommonInputDecoration("Nearest Station", null),
            ),
          ),
          Container(
            margin:
                const EdgeInsets.only(top: 23, left: 30, right: 30, bottom: 40),
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            alignment: Alignment.centerLeft,
            height: 50,
            width: MediaQuery.of(context).size.width * 0.35,
            // color: Colors.red,
            decoration: commonBoxDecoration,
            child: TextField(
              controller: _address,
              decoration: getCommonInputDecoration(
                  "Add your residential address", null),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                onTap: () async {
                  if (_name.text != "" &&
                      _lastName.text != "" &&
                      _address.text != "" &&
                      _address.text != "" &&
                      _gender != "" &&
                      _dob != null &&
                      _nearestStation.text != "") {
                    createNewConcession();
                    await showRegistrationDialog(context);
                    if (!mounted) return;
                    Navigator.pop(context);
                  } else {
                    await showFieldsNecessary(context);
                  }
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 50,
                  width: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: const Color(0xff000028),
                  ),
                  child: const Text(
                    'Apply',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}


// Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               const Text("Name"),
//               TextField(
//                 controller: _name,
//                 enableSuggestions: true,
//                 autocorrect: false,
//                 decoration: const InputDecoration(
//                   hintText: "Your full name",
//                 ),
//               ),

//               const Text("Gender"),
//               DropdownButton<String>(
//                 value: _gender,
//                 items: const [
//                   DropdownMenuItem(
//                     value: "Female",
//                     child: Text("Female"),
//                   ),
//                   DropdownMenuItem(
//                     value: "Male",
//                     child: Text("Male"),
//                   ),
//                   DropdownMenuItem(
//                     value: "Other",
//                     child: Text("Other"),
//                   ),
//                 ],
//                 onChanged: gender,
//               ),
//               //
//               const Text("Email"),
//               Text(currentUser.email),

//               const Text("Nearest Station"),
//               TextField(
//                 controller: _nearestStation,
//                 enableSuggestions: true,
//                 autocorrect: false,
//                 decoration: const InputDecoration(
//                   hintText: "Station nearest to your Home",
//                 ),
//               ),

//               const Text("Address"),
//               TextField(
//                 controller: _address,
//                 enableSuggestions: true,
//                 autocorrect: false,
//                 keyboardType: TextInputType.multiline,
//                 maxLines: null,
//                 decoration: const InputDecoration(
//                   hintText: "Residential Address",
//                 ),
//               ),

//               const Text("Date of Birth"),
//               Text("${_dob.day}/${_dob.month}/${_dob.year}"),
//               ElevatedButton(
//                 child: const Text("Select Date"),
//                 onPressed: () async {
//                   DateTime? dob = await showDatePicker(
//                     context: context,
//                     initialDate: _dob,
//                     firstDate: DateTime(1900),
//                     lastDate: DateTime(now.year),
//                   );
//                   if (dob == null) {
//                     return;
//                   }
//                   setState(() => _dob = dob);
//                 },
//               ),

//               const Text("Destination Station"),
//               Text(_destStation),

//               ElevatedButton(
//                 onPressed: (() async {
//                   createNewConcession();
//                   await showRegistrationDialog(context);
//                   if (!mounted) return;
//                   Navigator.pop(context);
//                 }),
//                 child: const Text("Register"),
//               ),
//             ],
//           ),
//         ),
//       ),
  