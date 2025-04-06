import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/welcome_screen.dart';
import 'screens/photoupload_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/chat_screen.dart'; // ✅ Chatbot Integration
import 'screens/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyDOuR1FwGoJlsWYywM2oPzrnGAZltgYowc",
      appId: "1:584219747686:android:d08ef76bb3fda436a014a7",
      messagingSenderId: "584219747686",
      projectId: "bjbjbjb-c4dfb",
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Stress Detection App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.blueGrey[50],
      ),
      home: AuthCheck(), // ✅ Navigate Based on Authentication
    );
  }
}

class AuthCheck extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SplashScreen(); // ✅ Show Splash While Checking Auth
        } else if (snapshot.hasData) {
          return HomeScreen(); // ✅ User Logged In -> Go to Home
        } else {
          return WelcomePage(); // ✅ No User -> Go to Welcome/Login
        }
      },
    );
  }
}
