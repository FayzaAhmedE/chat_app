import 'dart:developer';

import 'package:chat_app/constants/app_colors.dart';
import 'package:chat_app/screens/email_verification_screen.dart';
import 'package:chat_app/screens/login_screen.dart';
import 'package:chat_app/widgets/custom_elevated_button.dart';
import 'package:chat_app/widgets/custom_snack_bar.dart';
import 'package:chat_app/widgets/text_form_field_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  static String id = 'SignUpPage';

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  String? name, email, password, phone, confirmPassword;

  bool obscureTextPassword = true;
  bool obscureTextConfirmPassword = true;

  bool isLoading = false;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
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
                    SizedBox(height: 40),
                    Image.asset(
                      'assets/images/scholar.png',
                      width: 100,
                      height: 100,
                    ),
                    Text(
                      'Scholar Chat',
                      style: TextStyle(
                        fontSize: 30,
                        // fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'Pacifico',
                      ),
                    ),
                    SizedBox(height: 50),
                    Align(
                      alignment: AlignmentGeometry.centerLeft,
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w200,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    TextFormFieldWidget(
                      hint: 'Name',
                      icon: Icon(Icons.person),
                      onChanged: (value) {
                        name = value;
                      },
                    ),
                    TextFormFieldWidget(
                      hint: 'Email',
                      icon: Icon(Icons.email_outlined),
                      onChanged: (value) {
                        email = value;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!value.contains('@') || !value.contains('.')) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    TextFormFieldWidget(
                      hint: 'Phone number',
                      icon: Icon(Icons.phone_android_sharp),
                      onChanged: (value) {
                        phone = value;
                      },
                    ),
                    TextFormFieldWidget(
                      hint: 'Password',
                      obscureText: obscureTextPassword,
                      icon: (obscureTextPassword)
                          ? Icon(Icons.visibility_off)
                          : Icon(Icons.visibility),
                      onIconPressed: () {
                        setState(() {
                          obscureTextPassword = !obscureTextPassword;
                        });
                      },
                      onChanged: (value) {
                        password = value;
                      },
                      validator: (value) {
                        if (value == null || value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                    TextFormFieldWidget(
                      hint: 'Confirm password',
                      obscureText: obscureTextConfirmPassword,
                      icon: (obscureTextConfirmPassword)
                          ? Icon(Icons.visibility_off)
                          : Icon(Icons.visibility),
                      onIconPressed: () {
                        setState(() {
                          obscureTextConfirmPassword =
                              !obscureTextConfirmPassword;
                        });
                      },
                      onChanged: (value) {
                        confirmPassword = value;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                        }
                        if (value != password) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                    CustomElevatedButton(
                      text: 'Sign Up',
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          setState(() {
                            isLoading = true;
                          });
                          try {
                            final credential = await FirebaseAuth.instance
                                .createUserWithEmailAndPassword(
                                  email: email!.trim(),
                                  password: password!.trim(),
                                );

                            await credential.user?.sendEmailVerification();

                            await FirebaseFirestore.instance
                                .collection('users')
                                .doc(credential.user!.uid)
                                .set({
                                  'name': name,
                                  'email': email,
                                  'phone': phone,
                                  'createdAt': DateTime.now(),
                                });

                            log(
                              'Account created successfully! Check your email.',
                            );
                            if (context.mounted) {
                              CustomSnackBar.showCustomSnackBar(
                                context,
                                'Account created successfully! Check your email.',
                                backgroundColor: const Color(0xFF4CA64C),
                                icon: Icons.check_circle_outline,
                              );

                              Navigator.pushNamed(
                                context,
                                EmailVerificationScreen.id,
                                arguments: email,
                              );
                            }
                          } on FirebaseAuthException catch (e) {
                            String message = e.message ?? 'An error occurred';
                            if (e.code == 'weak-password') {
                              message = 'The password provided is too weak.';
                            } else if (e.code == 'email-already-in-use') {
                              message =
                                  'The account already exists for that email.';
                            }

                            if (context.mounted) {
                              CustomSnackBar.showCustomSnackBar(
                                context,
                                message,
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

                    SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "already have an accout? ",
                          style: TextStyle(fontSize: 12, color: Colors.white),
                        ),
                        GestureDetector(
                          onTap: () {
                            // Navigator.of(context).pushNamed('routeName');
                            Navigator.pushNamed(context, LoginScreen.id);
                          },
                          child: Text(
                            'sign In',
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
