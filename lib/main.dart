import 'package:chat_app/firebase_options.dart';
import 'package:chat_app/screens/email_verification_screen.dart';
import 'package:chat_app/screens/home_page.dart';
import 'package:chat_app/screens/login_screen.dart';
import 'package:chat_app/screens/signup_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat App',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      debugShowCheckedModeBanner: false,

     routes: {
      LoginScreen.id :(context) => LoginScreen(),
      SignupScreen.id :(context) => SignupScreen(),
      HomePage.id :(context) => HomePage(),
      EmailVerificationScreen.id :(context) => EmailVerificationScreen()
     },
      initialRoute: LoginScreen.id ,
    );
  }
}


