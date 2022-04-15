import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:job_test/auth_wrap.dart';
import 'package:job_test/providers/auth_provider.dart';
import 'package:job_test/providers/image_list_provider.dart';
import 'package:job_test/screens/auth/sign_in.dart';
import 'package:job_test/screens/auth/sign_up.dart';
import 'package:job_test/screens/home_screen.dart';
import 'package:provider/provider.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
 await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ImageListProvider()),
        ChangeNotifierProvider(create: (_)=>AuthService())
      ],
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),

        routes: {
          '/': (context)=>const AuthWrap(),
          '/sign_in': (context)=>SignInScreen(),
          '/sign_up': (context)=>SignUpScreen(),
        },
      ),
    );
  }
}
