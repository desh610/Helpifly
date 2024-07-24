import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth
import 'package:flutter_bloc/flutter_bloc.dart'; // Import BlocProvider
import 'package:helpifly/bloc/app_bloc/app_cubit.dart';
import 'package:helpifly/bloc/forum_bloc/forum_cubit.dart';
import 'package:helpifly/bloc/login_bloc/login_cubit.dart';
import 'package:helpifly/bloc/signup_bloc/signup_cubit.dart';
import 'package:helpifly/views/home_screen.dart';
import 'package:helpifly/views/login_screen.dart';
import 'package:helpifly/views/main_screen.dart';
import 'package:helpifly/views/signup_screen.dart';
import 'package:helpifly/views/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter is initialized
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => SignupCubit()),
        BlocProvider(create: (context) => LoginCubit()),
        BlocProvider(create: (context) => AppCubit()),
        BlocProvider(create: (context) => ForumCubit()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Helpifly',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            // Show splash screen while loading
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SplashScreen(); // A splash screen that you can implement
            }
            
            // Check if user is logged in
            if (snapshot.hasData) {
              // User is logged in, show home screen
              return MainScreen();
            } else {
              // User is not logged in, show login screen
              return LoginScreen();
            }
          },
        ),
        routes: {
          '/signup': (context) => SignupScreen(),
          // Add other routes as needed
        },
      ),
    );
  }
}
