import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phone_contact/views/add_contact_page.dart';
import 'package:phone_contact/views/home.dart';
import 'package:phone_contact/views/login_page.dart';
import 'package:phone_contact/views/sign_up_page.dart';
import 'package:sizer/sizer.dart';

import 'controllers/auth_services.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Contacts App',
          theme: ThemeData(
            textTheme: GoogleFonts.soraTextTheme(),
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange.shade800),
            useMaterial3: true,
          ),
          routes: {
            "/": (context) => CheckUser(),
            "/home": (context) => Homepage(),
            "/signup": (context) => SignUpPage(),
            "/login": (context) => LoginPage(),
            "/add": (context) => AddContact()
          },
        );
      },
    );
  }
}

class CheckUser extends StatefulWidget {
  const CheckUser({super.key});

  @override
  State<CheckUser> createState() => _CheckUserState();
}

class _CheckUserState extends State<CheckUser> {
  @override
  void initState() {
    AuthService().isLoggedIn().then((value) {
      if (value) {
        Navigator.pushReplacementNamed(context, "/home");
      } else {
        Navigator.pushReplacementNamed(context, "/login");
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}