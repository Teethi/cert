import 'package:flutter_celo_composer/constants/constants.dart';
import 'package:flutter_celo_composer/services/auth/auth_service.dart';
import 'package:flutter_celo_composer/utilities/dialogs/delete_dialog.dart';
import 'package:flutter_celo_composer/utilities/generics/get_arguments.dart';
import 'package:flutter/material.dart';
import 'package:flutter_celo_composer/services/cloud/concession/cloud_concession.dart';
import 'package:flutter_celo_composer/services/cloud/concession/firebase_cloud_storage_concession.dart';

class DataStudent extends StatefulWidget {
  const DataStudent({super.key});

  @override
  State<DataStudent> createState() => _DataStudentState();
}

class _DataStudentState extends State<DataStudent> {
  String _nameData = "";
  String _emailData = "";
  String _genderData = "";
  String _nearestStationData = "";
  String _addressData = "";
  String _dobData = "";
  String _classValueData = "";
  String _periodValueData = "";
  String _applicationDateData = "";
  String _applicationSent = "";
  String _applicationCanBeCollected = "";
  String _destinationStationData = "";

  CloudConcession? _concession;
  late final FirebaseCloudStorageConcession _concessionService;

  final currentUser = AuthService.firebase().currentUser!;
  @override
  void initState() {
    _concessionService = FirebaseCloudStorageConcession();
    super.initState();
  }

  Future<void> getExistingConcession(BuildContext context) async {
    final widgetConcession = context.getArgument<CloudConcession>();
    _concession = widgetConcession;
    

    if (widgetConcession != null) {
      _nameData = widgetConcession.name;
      _emailData = widgetConcession.email;
      _genderData = widgetConcession.gender;
      _nearestStationData = widgetConcession.nearestStation;
      _addressData = widgetConcession.address;
      _dobData = widgetConcession.dob;
      _classValueData = widgetConcession.trainClass;
      _periodValueData = widgetConcession.period;
      _applicationDateData = widgetConcession.dateOfApplication;
      _applicationSent = widgetConcession.receivedStatus;
      _applicationCanBeCollected = widgetConcession.completedStatus;
      _destinationStationData = widgetConcession.destinationStation;
    }
  }

  void _saveConcessionIfTextNotEmpty() async {
    final concession = _concession;
    if (concession != null) {
      await _concessionService.updateConcession(
        documentConcessionId: concession.documentConcessionId,
        trainClass: _classValueData,
        period: _periodValueData,
        dateOfApplication: _applicationDateData,
        receivedStatus: _applicationSent,
        completedStatus: _applicationCanBeCollected,
      );
    }
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
      backgroundColor: const Color(0xfff1f4f8),
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
        title: const Text(
          'Student Details',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
          overflow: TextOverflow.visible,
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
          children: <Widget>[
              FutureBuilder(
                future: getExistingConcession(context),
                builder: ((context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.done:
                      return Column(
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
                                child: Row(
                                  children: [
                                    const Text('Name',
                                        style: TextStyle(
                                          color: Color(0xff311b61),
                                          fontSize: 17,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        textAlign: TextAlign.left,
                                        overflow: TextOverflow.visible),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(_nameData),
                                  ],
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
                                child: Row(
                                  children: [
                                    const Text('Gender',
                                        style: TextStyle(
                                          color: Color(0xff311b61),
                                          fontSize: 17,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        textAlign: TextAlign.left,
                                        overflow: TextOverflow.visible),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(_genderData),
                                  ],
                                ),
                              )
                            ],
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                                top: 23, left: 30, right: 30, bottom: 23),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                            ),
                            alignment: Alignment.centerLeft,
                            height: 50,
                            width: 330,
                            decoration: commonBoxDecoration,
                            child: Row(
                              children: [
                                const Text('Email',
                                    style: TextStyle(
                                      color: Color(0xff311b61),
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.left,
                                    overflow: TextOverflow.visible),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(_emailData),
                              ],
                            ),
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
                                child: Row(
                                  children: [
                                    const Text('Class',
                                        style: TextStyle(
                                          color: Color(0xff311b61),
                                          fontSize: 17,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        textAlign: TextAlign.left,
                                        overflow: TextOverflow.visible),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(_classValueData),
                                  ],
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
                                child: Row(
                                  children: [
                                    const Text('Period',
                                        style: TextStyle(
                                          color: Color(0xff311b61),
                                          fontSize: 17,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        textAlign: TextAlign.left,
                                        overflow: TextOverflow.visible),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(_periodValueData),
                                  ],
                                ),
                              )
                            ],
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                              top: 23,
                              bottom: 20,
                              left: 30,
                              right: 30,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                            ),
                            alignment: Alignment.centerLeft,
                            height: 50,
                            width: 330,
                            // color: Colors.red,
                            decoration: commonBoxDecoration,
                            child: Row(
                              children: [
                                const Text('Date of Birth',
                                    style: TextStyle(
                                      color: Color(0xff311b61),
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.left,
                                    overflow: TextOverflow.visible),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(_dobData),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                              bottom: 20,
                              left: 30,
                              right: 30,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                            ),
                            alignment: Alignment.centerLeft,
                            height: 50,
                            width: 330,
                            // color: Colors.red,
                            decoration: commonBoxDecoration,
                            child: Row(
                              children: [
                                const Text('Nearest Station',
                                    style: TextStyle(
                                      color: Color(0xff311b61),
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.left,
                                    overflow: TextOverflow.visible),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(_nearestStationData),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                                left: 30, right: 30, bottom: 20),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                            ),
                            alignment: Alignment.centerLeft,
                            height: 50,
                            width: 330,
                            // color: Colors.red,
                            decoration: commonBoxDecoration,
                            child: Row(
                              children: [
                                const Text('Address',
                                    style: TextStyle(
                                      color: Color(0xff311b61),
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.left,
                                    overflow: TextOverflow.visible),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(_addressData),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                                left: 30, right: 30, bottom: 20),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                            ),
                            alignment: Alignment.centerLeft,
                            height: 50,
                            width: 330,
                            // color: Colors.red,
                            decoration: commonBoxDecoration,
                            child: Row(
                              children: [
                                const Text('Destination Station',
                                    style: TextStyle(
                                      color: Color(0xff311b61),
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.left,
                                    overflow: TextOverflow.visible),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(_destinationStationData),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                                left: 30, right: 30, bottom: 40),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                            ),
                            alignment: Alignment.centerLeft,
                            height: 50,
                            width: 330,
                            // color: Colors.red,
                            decoration: commonBoxDecoration,
                            child: Row(
                              children: [
                                const Text('Application Date',
                                    style: TextStyle(
                                      color: Color(0xff311b61),
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.left,
                                    overflow: TextOverflow.visible),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(_applicationDateData),
                              ],
                            ),
                          ),
                        ],
                      );
                    default:
                      return const CircularProgressIndicator();
                  }
                }),
              ),
              if(currentUser.email==adminConcession)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTap: () async {
                      final complete = await completed(context);
                      if (complete == true) {
                        _applicationCanBeCollected = "true";
                        _saveConcessionIfTextNotEmpty();
                        if (!mounted) return;
                        Navigator.pop(context);
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
                        'Completed',
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
        ),
      ),
    );
  }
}
