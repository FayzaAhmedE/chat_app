import 'dart:developer';

import 'package:chat_app/constants/app_colors.dart';
import 'package:chat_app/screens/home_page.dart';
import 'package:chat_app/screens/signup_screen.dart';
import 'package:chat_app/widgets/custom_elevated_button.dart';
import 'package:chat_app/widgets/text_form_field_widget.dart';
import 'package:chat_app/widgets/custom_snack_bar.dart'; // تأكدي من مسار استيراد الـ SnackBar عندك
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static String id = 'LoginPage';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool obscureText = true;
  String? email, password;

  bool isLoading = false;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  

  @override
  Widget build(BuildContext context) {
    // final String email =
    //     ModalRoute.of(context)!.settings.arguments as String? ?? '';


    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        backgroundColor: AppColors.kprimaryColor,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: SizedBox(
              width: double.infinity,
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 90),
                    Image.asset(
                      'assets/images/scholar.png',
                      width: 100,
                      height: 100,
                    ),
                    const Text(
                      'Scholar Chat',
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                        fontFamily: 'Pacifico',
                      ),
                    ),
                    const SizedBox(height: 50),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Sign in',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w200,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    TextFormFieldWidget(
                      hint: 'Email',
                      obscureText: false,
                      icon: const Icon(Icons.email_outlined),
                      onChanged: (value) {
                        email = value;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                    ),

                    TextFormFieldWidget(
                      hint: 'Password',
                      obscureText: obscureText,
                      icon: Icon(
                        obscureText ? Icons.visibility_off : Icons.visibility,
                      ),
                      onIconPressed: () {
                        setState(() {
                          obscureText = !obscureText;
                        });
                      },
                      onChanged: (value) {
                        password = value;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 20),

                    CustomElevatedButton(
                      text: 'Sign in',
                      textColor: Colors.black,
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          setState(() {
                            isLoading = true;
                          });
                          try {
                            final credential = await FirebaseAuth.instance
                                .signInWithEmailAndPassword(
                                  email: email!.trim(),
                                  password: password!.trim(),
                                );

                            if (!credential.user!.emailVerified) {
                              if (context.mounted) {
                                CustomSnackBar.showCustomSnackBar(
                                  context,
                                  'Please verify your email address first!',
                                  backgroundColor: const Color(
                                    0xFFF0AD4E,
                                  ), // تحذير
                                  icon: Icons.warning_amber_rounded,
                                );
                              }
                              return;
                            }

                            if (context.mounted) {
                              CustomSnackBar.showCustomSnackBar(
                                context,
                                'Signed in successfully!',
                                backgroundColor: const Color(
                                  0xFF4CA64C,
                                ), 
                                icon: Icons.check_circle_outline,
                              );
                              Navigator.pushReplacementNamed(
                                context,
                                HomePage.id,
                                arguments: email,
                              );
                            }
                          } on FirebaseAuthException catch (e) {
                            String errorMessage = 'Login failed';

                            if (e.code == 'user-not-found' ||
                                e.code == 'wrong-password' ||
                                e.code == 'invalid-credential') {
                              errorMessage = 'Invalid email or password. Please check your data.';
                            } else if (e.code == 'invalid-email') {
                              errorMessage =
                                  'The email address is badly formatted.';
                            } else if (e.code == 'user-disabled') {
                              errorMessage = 'This user has been disabled.';
                            }

                            if (context.mounted) {
                              CustomSnackBar.showCustomSnackBar(
                                context,
                                errorMessage,
                                backgroundColor: const Color(0xFFD9534F),
                                icon: Icons.error_outline,
                              );
                            }
                          } catch (e) {
                            log(e.toString());
                          }
                           setState(() {
                            isLoading = false;
                          });
                        }
                      },
                    ),

                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "don't have an account? ",
                          style: TextStyle(fontSize: 12, color: Colors.white),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, SignupScreen.id);
                          },
                          child: const Text(
                            'sign Up',
                            style: TextStyle(fontSize: 12, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
