import 'package:flutter_celo_composer/constants/routes.dart';
import 'package:flutter_celo_composer/utilities/dialogs/generic_dialog.dart';
// import 'package:flutter_celo_composer/enums/menu_action.dart';
// import 'package:flutter_celo_composer/extensions/buildcontext/loc.dart';
// import 'package:flutter_celo_composer/services/auth/bloc/auth_bloc.dart';
// import 'package:flutter_celo_composer/services/auth/bloc/auth_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_celo_composer/enums/menu_action.dart';
import 'package:flutter_celo_composer/utilities/dialogs/logout_dialog.dart';
import 'package:flutter_celo_composer/views/concession/concession_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:async';

import 'package:flutter_celo_composer/configs/themes.dart';
import 'package:flutter_celo_composer/infrastructures/service/cubit/web3_cubit.dart';
import 'package:flutter_celo_composer/module/auth/interfaces/screens/authentication_screen.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';

import '../module/certificate/apply.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    required this.session,
    required this.connector,
    required this.uri,
    Key? key,
  }) : super(key: key);

  final dynamic session;
  final WalletConnect connector;
  final String uri;
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String accountAddress = '';
  String networkName = '';
  TextEditingController greetingTextController = TextEditingController();

  ButtonStyle buttonStyle = ButtonStyle(
    elevation: MaterialStateProperty.all(0),
    backgroundColor: MaterialStateProperty.all(
      Colors.white.withAlpha(60),
    ),
    shape: MaterialStateProperty.all(
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
    ),
  );
  void updateGreeting() {
    launchUrlString(widget.uri, mode: LaunchMode.externalApplication);

    context.read<Web3Cubit>().updateGreeting(greetingTextController.text);
    greetingTextController.text = '';
  }

  @override
  void initState() {
    super.initState();

    /// Execute after frame is rendered to get the emit state of InitializeProviderSuccess
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => context.read<Web3Cubit>().initializeProvider(
            connector: widget.connector,
            session: widget.session,
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return BlocListener<Web3Cubit, Web3State>(
      listener: (BuildContext context, Web3State state) {
        if (state is SessionTerminated) {
          Future<void>.delayed(const Duration(seconds: 2), () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute<void>(
                builder: (BuildContext context) => const AuthenticationScreen(),
              ),
            );
          });
        } else if (state is UpdateGreetingFailed) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        } else if (state is FetchGreetingFailed) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        } else if (state is InitializeProviderSuccess) {
          setState(() {
            accountAddress = state.accountAddress;
            networkName = state.networkName;
          });
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xffe7edf2),
        appBar: AppBar(
          backgroundColor: const Color(0xff15001C),
          actions: [
            PopupMenuButton<MenuAction>(
              onSelected: (value) async {
                switch (value) {
                  case MenuAction.logout:
                    final shouldLogout = await showLogOutDialog(context);
                    if (!mounted) return;
                    if (shouldLogout) {
                      context.read<Web3Cubit>().closeConnection;
                    }
                }
              },
              itemBuilder: (context) {
                return [
                  const PopupMenuItem<MenuAction>(
                    value: MenuAction.logout,
                    child: Text('Logout'),
                  ),
                ];
              },
            )
          ],
          toolbarHeight: 180,
          automaticallyImplyLeading: false,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
          title: Column(
            children: const [
              Text(
                'Welcome,',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.visible,
              ),
              Text(
                'No more diploma fraud with GradCheck.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          flexibleSpace: Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(
              left: 31.0,
            ),
          ),
        ),
        body: ListView(
          children: <Widget>[
            const SizedBox(
              height: 15,
            ),
            Container(
              // gradient
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xff15001c),
                    Color(0xff6100ff),
                  ],
                ),
              ),
              margin: const EdgeInsets.symmetric(
                horizontal: 10,
              ),
              padding: const EdgeInsets.symmetric(
                vertical: 5,
              ),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Text('My Profile',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              )),
                          const SizedBox(
                            height: 14,
                          ),
                          InkWell(
                            onTap: () {
                              // Navigator.of(context).pushNamedAndRemoveUntil(
                              //   concession,
                              //   (route) => true,
                              // );
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: 50,
                              width: 200,
                              decoration: BoxDecoration(
                                color: const Color(0xffff8c00),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Column(
                                children: <Widget>[
                                  if (accountAddress.isNotEmpty)
                                    Text(
                                      'Address: ${accountAddress.substring(0, 8)}...${accountAddress.substring(accountAddress.length - 8, accountAddress.length)}',
                                      style:
                                          theme.textTheme.titleMedium!.copyWith(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  const SizedBox(height: 10),
                                  Text(
                                    'Network: $networkName',
                                    style:
                                        theme.textTheme.titleMedium!.copyWith(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            child: SizedBox(
                              width: 150,
                              child: ElevatedButton.icon(
                                onPressed:
                                    context.read<Web3Cubit>().closeConnection,
                                icon: const Icon(
                                  Icons.power_settings_new,
                                ),
                                label: Text(
                                  'Disconnect',
                                  style: theme.textTheme.titleMedium!
                                      .copyWith(color: Colors.black),
                                ),
                                style: ButtonStyle(
                                  elevation: MaterialStateProperty.all(0),
                                  backgroundColor: MaterialStateProperty.all(
                                    Colors.grey.shade400,
                                  ),
                                  shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Image.asset(
                      'assets/images/icon/form.png',
                      height: 90,
                      width: 90,
                    ),
                  ]),
            ),
            const SizedBox(
              height: 17,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 27.0, bottom: 8, top: 3),
              child: Text('Explore Features',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 21,
                    fontWeight: FontWeight.w600,
                  )),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => SignUpPage(walletAddress: accountAddress,),
                      ),
                    );
                    // Navigator.of(context).pushNamedAndRemoveUntil(
                    //   eventView,
                    //   (route) => true,
                    // );
                  },
                  child: Container(
                      width: 160,
                      margin: const EdgeInsets.symmetric(
                        vertical: 10,
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 15,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: const Color(0xffe4eaef),
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
                            blurRadius: 5.0,
                            offset: Offset(-4, -4),
                          ),
                        ],
                      ),
                      // height: 100,
                      // width: 100,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 15,
                          ),
                          Center(
                            child: SvgPicture.asset(
                                'assets/images/icon/events.svg',
                                height: 60,
                                width: 60),
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Text('Apply',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      )),
                                  SizedBox(
                                    width: 2,
                                  ),
                                  Icon(
                                    Icons.arrow_forward,
                                    size: 19,
                                  ),
                                ],
                              ),
                              const Text('Apply for certificates',
                                  style: TextStyle(
                                    color: Color(0xff656565),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  )),
                            ],
                          ),
                        ],
                      )),
                ),
                InkWell(
                  onTap: () {},
                  child: Container(
                      width: 160,
                      margin: const EdgeInsets.symmetric(
                        vertical: 10,
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 15,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: const Color(0xffe4eaef),
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
                            blurRadius: 5.0,
                            offset: Offset(-4, -4),
                          ),
                        ],
                      ),
                      // height: 100,
                      // width: 100,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 15,
                          ),
                          Center(
                            child: SvgPicture.asset(
                                'assets/images/icon/notes.svg',
                                height: 60,
                                width: 60),
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Text('My Certificates',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      )),
                                  SizedBox(
                                    width: 2,
                                  ),
                                  Icon(
                                    Icons.arrow_forward,
                                    size: 19,
                                  ),
                                ],
                              ),
                              const Text('Certificates You Own',
                                  style: TextStyle(
                                    color: Color(0xff656565),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  )),
                            ],
                          ),
                        ],
                      )),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  onTap: () {},
                  child: Container(
                      width: 160,
                      margin: const EdgeInsets.symmetric(
                        vertical: 10,
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 15,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: const Color(0xffe4eaef),
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
                            blurRadius: 5.0,
                            offset: Offset(-4, -4),
                          ),
                        ],
                      ),
                      // height: 100,
                      // width: 100,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 15,
                          ),
                          Center(
                            child: SvgPicture.asset(
                                'assets/images/icon/attendance.svg',
                                height: 60,
                                width: 60),
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Text('Pending',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      )),
                                  SizedBox(
                                    width: 2,
                                  ),
                                  Icon(
                                    Icons.arrow_forward,
                                    size: 19,
                                  ),
                                ],
                              ),
                              const Text('Applications that are pending',
                                  style: TextStyle(
                                    color: Color(0xff656565),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  )),
                            ],
                          ),
                        ],
                      )),
                ),
                InkWell(
                  onTap: () {},
                  child: Container(
                      width: 160,
                      margin: const EdgeInsets.symmetric(
                        vertical: 10,
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 15,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: const Color(0xffe4eaef),
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
                            blurRadius: 5.0,
                            offset: Offset(-4, -4),
                          ),
                        ],
                      ),
                      // height: 100,
                      // width: 100,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 15,
                          ),
                          Center(
                            child: SvgPicture.asset(
                                'assets/images/icon/notifications.svg',
                                height: 60,
                                width: 60),
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Text('Notifications',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      )),
                                  SizedBox(
                                    width: 2,
                                  ),
                                  Icon(
                                    Icons.arrow_forward,
                                    size: 19,
                                  ),
                                ],
                              ),
                              const Text('Coming soon!',
                                  style: TextStyle(
                                    color: Color(0xff656565),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  )),
                            ],
                          ),
                        ],
                      )),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
