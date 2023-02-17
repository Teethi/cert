import 'package:flutter_celo_composer/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_celo_composer/services/auth/bloc/auth_bloc.dart';
import 'package:flutter_celo_composer/services/auth/bloc/auth_event.dart';
import 'package:flutter_celo_composer/services/auth/bloc/auth_state.dart';
import 'package:flutter_celo_composer/utilities/dialogs/error_dialog.dart';
import 'package:flutter_celo_composer/utilities/dialogs/password_reset_email_sent_dialog.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({Key? key}) : super(key: key);

  @override
  _ForgotPasswordViewState createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateForgotPassword) {
          if (state.hasSentEmail) {
            _controller.clear();
            await showPasswordResetSentDialog(context);
          }
          if (state.exception != null) {
            if (!mounted) return;
            await showErrorDialog(
              context,
              "loc.forgot_password_view_generic_error",
            );
          }
        }
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Stack(
              children: [
                Positioned(
                  top: 26,
                  child: IconButton(
                    icon: SvgPicture.asset(
                      'assets/images/icon/back_arrow.svg',
                      color: Colors.white,
                      width: 19,
                    ),
                    onPressed: () {
                      context.read<AuthBloc>().add(
                            const AuthEventLogOut(),
                          );
                    },
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 26,
                  child: IconButton(
                    icon: SvgPicture.asset(
                      'assets/images/icon/help.svg',
                      color: Colors.white,
                      width: 19,
                    ),
                    onPressed: () {
                      //
                    },
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(
                      height: 100,
                    ),
                    Text(
                      'Forgot Password?',
                      style: GoogleFonts.jost(
                        textStyle: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 21,
                    ),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Please enter your ',
                                style: GoogleFonts.dmSans(
                                  textStyle: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white,
                                  ),
                                ),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                'email address',
                                style: GoogleFonts.dmSans(
                                  textStyle: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400,
                                    color: Color.fromARGB(255, 255, 140, 0),
                                  ),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          Text(
                            "to reset the password",
                            style: GoogleFonts.dmSans(
                              textStyle: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                color: Color.fromARGB(255, 255, 255, 255),
                              ),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ]),
                    const SizedBox(
                      height: 34,
                    ),
                    Container(
                      height: 60,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xffcc4c4c4),
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.only(left: 18, right: 30),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Center(
                              child: Text(
                                'Email ID',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 30,
                            color: primaryWhite,
                          ),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0),
                                child: TextField(
                                  keyboardType: TextInputType.emailAddress,
                                  autocorrect: false,
                                  autofocus: true,
                                  controller: _controller,
                                  enableSuggestions: true,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white,
                                  ),
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    InkWell(
                      onTap: () async {
                        final email = _controller.text;
                        context
                            .read<AuthBloc>()
                            .add(AuthEventForgotPassword(email: email));

                        if (email.length < 12) {
                          await showErrorDialog(
                            context,
                            "Please Enter a valid Email ID",
                          );
                          return;
                        }
                      },
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                          color: const Color(0xfffbd512),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              'Continue',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Color(0xff141414),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Icon(
                              Icons.arrow_forward,
                              color: Color(0xff141414),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "We'll sent a password reset link to ",
                            style: GoogleFonts.dmSans(
                              textStyle: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w400,
                                color: Color.fromARGB(255, 255, 255, 255),
                              ),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            "your Email",
                            style: GoogleFonts.dmSans(
                              textStyle: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w400,
                                color: Color.fromARGB(255, 255, 255, 255),
                              ),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ])
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
