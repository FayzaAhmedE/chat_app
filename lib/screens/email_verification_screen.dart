import 'package:chat_app/constants/app_colors.dart';
import 'package:chat_app/screens/login_screen.dart';
import 'package:chat_app/widgets/custom_elevated_button.dart';
import 'package:chat_app/widgets/custom_snack_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EmailVerificationScreen extends StatelessWidget {
  const EmailVerificationScreen({super.key});
  static String id = 'EmailVerificationScreen';

  @override
  Widget build(BuildContext context) {
    final String email =
        ModalRoute.of(context)!.settings.arguments as String? ?? '';
    return Scaffold(
      appBar: AppBar(backgroundColor: AppColors.kprimaryColor),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.kprimaryColor.withValues(alpha: 0.3),
                      blurRadius: 30,
                      spreadRadius: 2,
                      offset: Offset(0, 4), // Changes shadow position
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/check_email.png',
                    // height: 250,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'Check your inbox',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                'We sent a verification link to your email.',
                style: TextStyle(color: Colors.grey, fontSize: 16),
                textAlign: TextAlign.center,
              ),
              Text(
                email,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              Row(
                children: [
                  SizedBox(
                    width: 200,
                    child: CustomElevatedButton(
                      text: 'back',
                      textColor: Colors.black,
                      onPressed: () async {
                        Navigator.pushNamed(context, LoginScreen.id);
                      },
                    ),
                  ),
                  Spacer(flex: 1),
                  SizedBox(
                    width: 200,
                    child: CustomElevatedButton(
                      text: 'Continue',
                      bgColor: AppColors.kprimaryColor,
                      textColor: Colors.white,
                      onPressed: () async {
                        User? user = FirebaseAuth.instance.currentUser;
                        await user?.reload();
                        user = FirebaseAuth.instance.currentUser;
                        if (user != null && user.emailVerified) {
                          if (context.mounted) {
                            // ScaffoldMessenger.of(context).showSnackBar(
                            CustomSnackBar.showCustomSnackBar(
                              context,
                              'Account created successfully!',
                              backgroundColor: const Color(
                                0xFF4CA64C,
                              ), 
                              icon: Icons.check_circle_outline,
                            );
                            Navigator.pushReplacementNamed(
                              context,
                              LoginScreen.id,
                            );
                          }
                        } else {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Please verify your email via the link sent first!',
                                ),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                        Navigator.pushNamed(context, LoginScreen.id,
                        arguments: email,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
