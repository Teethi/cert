// import 'package:flutter/services.dart';
// import 'package:flutter_celo_composer/configs/themes.dart';
// import 'package:flutter_celo_composer/configs/web3_config.dart';
// import 'package:flutter_celo_composer/infrastructures/repository/secure_storage_repository.dart';
// import 'package:flutter_celo_composer/infrastructures/service/cubit/secure_storage_cubit.dart';
// import 'package:flutter_celo_composer/infrastructures/service/cubit/web3_cubit.dart';
// import 'package:flutter_celo_composer/module/auth/interfaces/screens/authentication_screen.dart';
// import 'package:flutter_celo_composer/module/auth/service/cubit/auth_cubit.dart';
// import 'package:flutter_celo_composer/prac.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:walletconnect_dart/walletconnect_dart.dart';
// import 'package:web3dart/web3dart.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_celo_composer/constants/routes.dart';
import 'package:flutter_celo_composer/helpers/loading/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_celo_composer/constants/routes.dart';
import 'package:flutter_celo_composer/services/auth/bloc/auth_bloc.dart';
import 'package:flutter_celo_composer/services/auth/bloc/auth_event.dart';
import 'package:flutter_celo_composer/services/auth/bloc/auth_state.dart';
import 'package:flutter_celo_composer/services/auth/firebase_auth_provider.dart';
import 'package:flutter_celo_composer/views/forgot_password_view.dart';
import 'package:flutter_celo_composer/views/login_view.dart';
import 'package:flutter_celo_composer/views/register_view.dart';
import 'package:flutter_celo_composer/views/verify_email_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scroll_page_view/scroll_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_celo_composer/constants/constants.dart';
import 'package:flutter_celo_composer/services/auth/auth_service.dart';
import 'package:flutter_celo_composer/views/admin/admin_data_view.dart';
import 'package:flutter_celo_composer/views/admin/admin_start.dart';
import 'package:flutter_celo_composer/views/admin/admin_view.dart';
import 'package:flutter_celo_composer/views/common_view.dart';
import 'package:flutter_celo_composer/views/concession/concession_register.dart';
import 'package:flutter_celo_composer/views/concession/concession_request.dart';
import 'package:flutter_celo_composer/views/concession/concession_status.dart';
import 'package:flutter_celo_composer/views/concession/concession_view.dart';
import 'package:flutter_celo_composer/views/events/events_committee.dart';
import 'package:flutter_celo_composer/views/events/events_details.dart';
import 'package:flutter_celo_composer/views/events/events_view.dart';


Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final showHome = prefs.getBool("showHome") ?? false;

  runApp(
    MaterialApp(
      title: 'SPIT',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: const Color(0xff15001c)),
      home: BlocProvider<AuthBloc>(
        create: (context) => AuthBloc(FirebaseAuthProvider()),
        child: HomePage(showHome: showHome),
      ),
      routes: {
        adminstart:(context) => const AdminStart(),
        eventView: (context) => const EventsView(),
        eventsDetails: (context) => const EventDetails(),
        eventsAdd: (context) => const EventsAdd(),
        student: (context) => const DataStudent(),
        admin: (context) => const AdminView(),
        concessionRegister: (context) => const ConcessionRegister(),
        concessionStatus: (context) => const ConcessionStatus(),
        concessionRequest: (context) => const ConcessionRequest(),
        common: (context) => const CommonView(),
        concession: (context) => const ConcessionView(),
      },
    ),
  );
}

class HomePage extends StatefulWidget {
  final bool showHome;
  const HomePage({Key? key, required this.showHome}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String get userEmail => AuthService.firebase().currentUser!.email;

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialize());

    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: Theme.of(context).textTheme.apply(
              bodyColor: Colors.white,
              displayColor: Colors.white,
            ),
      ),
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.isLoading) {
            LoadingScreen().show(
              context: context,
              text: state.loadingText ?? 'Please wait a moment',
            );
          } else {
            LoadingScreen().hide();
          }
        },
        builder: (context, state) {
          if (state is AuthStateLoggedIn) {
            if (userEmail == adminConcession) {
              return const AdminStart();
            } else if (userEmail == adminEvents) {
              return const EventsAdd();
            } else {
              return const CommonView();
            }
          } else if (state is AuthStateNeedsVerification) {
            return const VerifyEmailView();
          } else if (state is AuthStateLoggedOut) {
            return LoginView(showHome: widget.showHome,);
          } else if (state is AuthStateForgotPassword) {
            return const ForgotPasswordView();
          } else if (state is AuthStateRegistering) {
            return const RegisterView();
          } else {
            return const Scaffold(
              body: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

class OnBoarding extends StatefulWidget {
  final bool showHome;
  const OnBoarding({super.key, required this.showHome});
  static const titles = [
    'Notes',
    'Event Updates',
    'Concession',
    // 'Attendance'
  ];

  static const descriptions = [
    'Our notes feature offers a personalized experience for managing your notes with features such as writing, saving, sharing, updating and deleting. Keep track of your thoughts, ideas and information all in one place. Try it now for a simple and user-friendly note-taking solution.',
    'Stay informed on college events with our platform. Get comprehensive information on future events and never miss out. Check it out now.',
    'Our platform offers a digital railway concession application process for students with the ability to check the status of their application. No more waiting in lines or searching for paper forms, apply now for a quick and efficient experience.',
  ];
  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  late final ScrollPageController _controller;
  bool isLastPage = false;
  @override
  void initState() {
    _controller = ScrollPageController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: <Widget>[
            const SizedBox(
              height: 90,
            ),
            Image.asset(
              'assets/images/icon/spit_logo.png',
              height: 200,
            ),
            const SizedBox(
              height: 90,
            ),
            SizedBox(
              height: 250,
              child: ScrollPageView(
                allowImplicitScrolling: false,
                isTimer: false,
                checkedIndicatorColor: const Color(0xffff8c00),
                controller: _controller,
                onPageChanged: (index) {
                  setState(() {
                    isLastPage = index == 2;
                  });
                },
                children: [
                  for (var i = 0; i < OnBoarding.titles.length; i++)
                    Column(
                      children: [
                        Text(
                          OnBoarding.titles[i],
                          style: GoogleFonts.jost(
                            textStyle: const TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: Text(
                            OnBoarding.descriptions[i],
                            style: GoogleFonts.jost(
                              textStyle: const TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            const SizedBox(
              height: 90,
            ),
            if (isLastPage != true)
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 150,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () {
                        _controller.controller.jumpToPage(3);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xfffbd512),
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                        ),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                        ),
                      ),
                      child: const Text(
                        'Skip',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff141414)),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  SizedBox(
                    width: 150,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () {
                        _controller.controller.nextPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffff8c00),
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                        ),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                          ),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Next',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Color(0xff141414),
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          SvgPicture.asset(
                            'assets/images/icon/arrow_right.svg',
                            height: 13,
                            color: const Color(0xff141414),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            if (isLastPage == true)
              SizedBox(
                width: 300,
                height: 60,
                child: InkWell(
                  onTap: () async {
                    final prefs = await SharedPreferences.getInstance();
                    prefs.setBool("showHome", true);
                    if (!mounted) return;
                    Navigator.of(context).pop();
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
                          'Get started',
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
              ),
          ],
        ),
      ),
    );
  }
}













// Future<void> main() async {
//   /// Load env file
//   await dotenv.load();

//   runApp(
//     MaterialApp(
//       title: 'Sophon',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//           primarySwatch: Colors.blue,
//           scaffoldBackgroundColor: const Color(0xff15001c)),
//       home: 
//     MyApp(
//       walletConnect: await walletConnect,
//       greeterContract: await deployedGreeterContract,
//       web3client: web3Client,
//     ),
//       routes: {
//         // signup:(context) =>  SignUpPage(walletAddress: '',)
        
//       },
//     ),
//   );
// }

// class MyApp extends StatelessWidget {
//   const MyApp({
//     required this.walletConnect,
//     required this.greeterContract,
//     required this.web3client,
//     Key? key,
//   }) : super(key: key);
//   final WalletConnect walletConnect;
//   final DeployedContract greeterContract;
//   final Web3Client web3client;

//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: <BlocProvider<dynamic>>[
//         BlocProvider<Web3Cubit>(
//           create: (BuildContext context) => Web3Cubit(
//             web3Client: web3client,
//             greeterContract: greeterContract,
//           ),
//         ),
//         BlocProvider<AuthCubit>(
//           create: (BuildContext context) => AuthCubit(
//             storage: SecureStorageRepository(),
//             connector: walletConnect,
//           ),
//         ),
//         BlocProvider<SecureStorageCubit>(
//           create: (BuildContext context) => SecureStorageCubit(
//             storage: SecureStorageRepository(),
//           ),
//         ),
//       ],
//       child: MaterialApp(
//         title: 'Sophon',
//         debugShowCheckedModeBanner: false,
//         theme: buildDefaultTheme(context),
//         home: const MyHomePage(),
//       ),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({Key? key}) : super(key: key);

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   @override
//   Widget build(BuildContext context) {
//     /// Lock app to portrait mode
//     SystemChrome.setPreferredOrientations(<DeviceOrientation>[
//       DeviceOrientation.portraitUp,
//       DeviceOrientation.portraitDown,
//     ]);
//     return const AuthenticationScreen();
//   }
// }
