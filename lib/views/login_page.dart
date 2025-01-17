import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../controllers/auth_services.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(children: [
            SizedBox(
              height: 5.h,
            ),
            Text(
              "Login",
              style:
              GoogleFonts.sora(fontSize: 40, fontWeight: FontWeight.w700),
            ),
            SizedBox(
              height: 8.h,
            ),
            SizedBox(
                height: 7.h,
                width: 90.w,
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) =>
                  value!.isEmpty ? "Email cannot be empty." : null,
                  controller: _emailController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text("Email"),
                  ),
                )),
            SizedBox(
              height: 2.h,
            ),
            SizedBox(
                height: 7.h,
                width: 90.w,
                child: TextFormField(
                  validator: (value) => value!.length < 8
                      ? "Password should have atleast 8 characters."
                      : null,
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text("Password"),
                  ),
                )),
            SizedBox(
              height: 2.h,
            ),
            SizedBox(
                height: 6.h,
                width: 90.w,
                child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                    ),
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        AuthService()

                            .loginWithEmail(
                            _emailController.text, _passwordController.text)
                            .then((value) {
                          if (value == "Login Successful") {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Login Successful")));
                            Navigator.pushReplacementNamed(context, "/home");
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                value,
                                style: const TextStyle(color: Colors.white),
                              ),
                              backgroundColor: Colors.red.shade400,
                            ));
                          }
                        });
                      }
                    },
                    child: const Text(
                      "Login",
                      style: TextStyle(fontSize: 16,color: Colors.white),
                    ))),
            // SizedBox(
            //    height: 2.h,
            //  ),
            // SizedBox(
            //   height: 6.h,
            //   width: 90.w,
            //   child: OutlinedButton(
            //       onPressed: () {
            //         AuthService().continueWithGoogle().then((value) {
            //           if (value == "Google Login Successful") {
            //             ScaffoldMessenger.of(context).showSnackBar(
            //                 const SnackBar(content: Text("Google Login Successful")));
            //             Navigator.pushReplacementNamed(context, "/home");
            //           } else {
            //             ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            //               content: Text(
            //                 value,
            //                 style: const TextStyle(color: Colors.white),
            //               ),
            //               backgroundColor: Colors.red.shade400,
            //             ));
            //           }
            //         });
            //       },
            //       child: Row(
            //         mainAxisAlignment: MainAxisAlignment.center,
            //         children: [
            //           Image.asset(
            //             "images/google.png",
            //             height: 30,
            //             width: 30,
            //           ),
            //           SizedBox(
            //             width:  2.h,
            //           ),
            //           const Text(
            //             "Continue with Google",
            //             style: TextStyle(fontSize: 16),
            //           )
            //         ],
            //       )),
            // ),
            SizedBox(
              height: 2.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have and account?"),
                TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "/signup");
                    },
                    child: const Text("Sign Up"))
              ],
            )
          ]),
        ),
      ),
    );
  }
}