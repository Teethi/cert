import 'package:flutter_celo_composer/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_celo_composer/services/auth/auth_exceptions.dart';
import 'package:flutter_celo_composer/services/auth/bloc/auth_bloc.dart';
import 'package:flutter_celo_composer/services/auth/bloc/auth_event.dart';
import 'package:flutter_celo_composer/services/auth/bloc/auth_state.dart';
import 'package:flutter_celo_composer/utilities/dialogs/error_dialog.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  late bool _passwordVisible;

  @override
  void initState() {
    _passwordVisible = false;
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateRegistering) {
          if (state.exception is WeakPasswordAuthException) {
            await showErrorDialog(
              context,
              "loc.register_error_weak_password",
            );
          } else if (state.exception is EmailAlreadyInUseAuthException) {
            await showErrorDialog(
              context,
              "loc.register_error_email_already_in_use",
            );
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(
              context,
              "loc.register_error_generic",
            );
          } else if (state.exception is InvalidEmailAuthException) {
            await showErrorDialog(
              context,
              "loc.register_error_invalid_email",
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
                    Container(
                      width: 90,
                      height: 90,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xffff8c00),
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          'assets/images/icon/profile.svg',
                          color: Colors.black,
                          width: 50,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 29,
                    ),
                    Text(
                      'Signup',
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
                      height: 12,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        'Create an account so you can manage your college curriculum',
                        style: GoogleFonts.dmSans(
                          textStyle: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(
                      height: 34,
                    ),
                    Container(
                      height: 60,
                      decoration: BoxDecoration(
                        // color: Color(0xff1f1f1f),
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
                              // color: Color(0xff1f1f1f),
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
                                  controller: _email,
                                  keyboardType: TextInputType.emailAddress,
                                  enableSuggestions: true,
                                  autocorrect: false,
                                  autofocus: true,
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
                      height: 19,
                    ),
                    Container(
                      height: 60,
                      decoration: BoxDecoration(
                        // color: Color(0xff1f1f1f),
                        border: Border.all(
                          color: const Color(0xffcc4c4c4),
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.only(left: 18, right: 18),
                            decoration: BoxDecoration(
                              // color: Color(0xff1f1f1f),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Center(
                              child: Text(
                                'Password',
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
                                  controller: _password,
                                  obscureText: !_passwordVisible,
                                  enableSuggestions: false,
                                  autocorrect: false,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white,
                                  ),
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          !_passwordVisible
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                          color: Theme.of(context)
                                              .primaryColorDark,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _passwordVisible =
                                                !_passwordVisible;
                                          });
                                        },
                                      )),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 22,
                    ),
                    Row(
                      children: [
                        TextButton(
                          onPressed: () {
                            context.read<AuthBloc>().add(
                                  const AuthEventLogOut(),
                                );
                          },
                          child: Text(
                            'Already Signed Up?',
                            style: GoogleFonts.dmSans(
                              textStyle: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    InkWell(
                      onTap: () async {
                        final email = _email.text;
                        final password = _password.text;

                        if (email.length < 12) {
                          await showErrorDialog(
                            context,
                            "Please Enter a valid Email ID",
                          );
                          return;
                        }

                        final spit = email.substring(email.length - 11);
                        if (spit != '@spit.ac.in') {
                          await showErrorDialog(
                            context,
                            "Register through spit email id only",
                          );
                        } else {
                          context.read<AuthBloc>().add(
                                AuthEventRegister(
                                  email,
                                  password,
                                ),
                              );
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
                              'Register',
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
