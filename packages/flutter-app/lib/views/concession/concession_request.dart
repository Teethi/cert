import 'package:flutter_celo_composer/utilities/dialogs/delete_dialog.dart';
import 'package:flutter_celo_composer/utilities/generics/get_arguments.dart';
import 'package:flutter/material.dart';
import 'package:flutter_celo_composer/services/cloud/concession/cloud_concession.dart';
import 'package:flutter_celo_composer/services/cloud/concession/firebase_cloud_storage_concession.dart';
import 'package:flutter_svg/flutter_svg.dart';

DateTime now = DateTime.now();
DateTime _date = DateTime(now.year, now.month, now.day);

class ConcessionRequest extends StatefulWidget {
  const ConcessionRequest({super.key});

  @override
  State<ConcessionRequest> createState() => _ConcessionRequestState();
}

class _ConcessionRequestState extends State<ConcessionRequest> {
  String _received = "false";
  String _completed = "false";
  String _classValue = "First";
  String _periodValue = "Monthly";

  final _dateOfApplication = "${_date.day}/${_date.month}/${_date.year}";

  CloudConcession? _concession;
  late final FirebaseCloudStorageConcession _concessionService;

  @override
  void initState() {
    _concessionService = FirebaseCloudStorageConcession();
    super.initState();
  }

  Future<void> getExistingConcession(BuildContext context) async {
    final widgetConcession = context.getArgument<CloudConcession>();

    if (widgetConcession != null) {
      _concession = widgetConcession;
    }
  }

  void _saveConcessionIfTextNotEmpty() async {
    final concession = _concession;
    if (concession != null) {
      await _concessionService.updateConcession(
        documentConcessionId: concession.documentConcessionId,
        trainClass: _classValue,
        period: _periodValue,
        dateOfApplication: _dateOfApplication,
        receivedStatus: _received,
        completedStatus: _completed,
      );
    }
  }

  void classCallBack(String? selectedvalue) {
    if (selectedvalue is String) {
      setState(() {
        _classValue = selectedvalue;
      });
    }
  }

  void periodCallBack(String? selectedvalue) {
    if (selectedvalue is String) {
      setState(() {
        _periodValue = selectedvalue;
      });
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
        title: const Expanded(
          child: Text(
            'Application Request',
            style: TextStyle(
              color: Colors.white,
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
            child: Row(
              children: [
                const Text('Date of Application',
                    style: TextStyle(
                      color: Color(0xff311b61),
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.visible),const SizedBox(
            width: 10,
          ),
                Text(_dateOfApplication),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 30.0, bottom: 18),
            child: Text('Class',
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
                    _classValue = "First";
                  });
                },
                child: Row(
                  children: [
                    _classValue == "First"
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
                      'First',
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
                    _classValue = "Second";
                  });
                },
                child: Row(
                  children: [
                    _classValue == "Second"
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
                      'Second',
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
          const SizedBox(
            height: 30,
          ),
          const Padding(
            padding: EdgeInsets.only(left: 30.0, bottom: 18),
            child: Text('Period',
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
                    _periodValue = "Monthly";
                  });
                },
                child: Row(
                  children: [
                    _periodValue == "Monthly"
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
                      'Monthly',
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
                    _periodValue = "Quaterly";
                  });
                },
                child: Row(
                  children: [
                    _periodValue == "Quaterly"
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
                      'Quaterly',
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
          const SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                onTap: () async {
                  _received = "true";
                  _completed = "false";
                  getExistingConcession(context);
                  _saveConcessionIfTextNotEmpty();
                  await applicationSentDialog(context);
                  if (!mounted) return;
                  Navigator.of(context).pop(true);
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
