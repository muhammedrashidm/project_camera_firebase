import 'package:flutter/material.dart';
import 'package:job_test/providers/auth_provider.dart';
import 'package:job_test/screens/auth/sign_in.dart';
import 'package:job_test/screens/home_screen.dart';
import 'package:provider/provider.dart';

import 'models/user_modal.dart';

class AuthWrap extends StatelessWidget {
  const AuthWrap({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return StreamBuilder<User?>(
        stream: authService.user,
          builder: (_,AsyncSnapshot<User?> snapshot){
          if(snapshot.connectionState == ConnectionState.active){

            final User? user = snapshot.data;

            return user == null ? SignInScreen(): HomeScreen();
          }else{
          return  Scaffold(body: Center(child: CircularProgressIndicator(),),);
          }
      });

  }
}
