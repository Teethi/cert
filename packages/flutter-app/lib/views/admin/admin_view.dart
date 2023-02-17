import 'package:flutter_celo_composer/constants/routes.dart';
import 'package:flutter_celo_composer/services/auth/auth_service.dart';
import 'package:flutter_celo_composer/views/admin/admin_owner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_celo_composer/services/cloud/concession/cloud_concession.dart';
import 'package:flutter_celo_composer/services/cloud/concession/firebase_cloud_storage_concession.dart';

class AdminView extends StatefulWidget {
  const AdminView({super.key});

  @override
  State<AdminView> createState() => _AdminViewState();
}

class _AdminViewState extends State<AdminView> {
  late final FirebaseCloudStorageConcession _concessionsService;
  String get userId => AuthService.firebase().currentUser!.id;
  String get userEmail => AuthService.firebase().currentUser!.email;

  @override
  void initState() {
    _concessionsService = FirebaseCloudStorageConcession();
    super.initState();
  }

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
            'Welcome Admin',
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text("These are the list of all the applications"),
              StreamBuilder(
                stream: _concessionsService.allTrueConcessions(userId: userId),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.active:
                      if (snapshot.hasData) {
                        final allConcessions =
                            snapshot.data as Iterable<CloudConcession>;
                        if (allConcessions.isNotEmpty) {
                          return AdminOwner(
                            concessions: allConcessions,
                            onTap: (concession) {
                              Navigator.of(context).pushNamed(
                                student,
                                arguments: concession,
                              );
                            },
                          );
                        } else {
                          return Container(
                            alignment: Alignment.center,
                            child: const Text(
                              'No Data found.',
                              style: TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                        }
                      } else {
                        return const Text("No Data found.");
                      }
                    default:
                      return const CircularProgressIndicator();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
