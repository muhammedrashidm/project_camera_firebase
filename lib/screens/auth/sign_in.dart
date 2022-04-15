import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:job_test/widgets/text_field.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';

class SignInScreen extends StatelessWidget {
  SignInScreen({Key? key}) : super(key: key);

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      body: Consumer<AuthService>(
        builder: (BuildContext context, value, Widget? child) {
          return ModalProgressHUD(
            inAsyncCall: value.isLoading,
            child: Center(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 5),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                width: double.maxFinite,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Hero(
                      tag: 'logo',
                      child: FlutterLogo(
                        size: 80,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    AppTextField(
                        textEditingController: _emailController,
                        hintText: 'Email',
                        icon: Icons.email),
                    const SizedBox(
                      height: 10,
                    ),
                    AppTextField(
                      textEditingController: _passwordController,
                      hintText: 'Password',
                      icon: Icons.key,
                      isObscureText: true,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () async {
                        if (EmailValidator.validate(
                            _emailController.text.trim())) {
                          if (_emailController.text.trim().isNotEmpty &&
                              _passwordController.text.trim().length > 5) {
                            final user =
                                await authService.signInWithEmailAndPassword(
                                    _emailController.text.trim(),
                                    _passwordController.text.trim());
                            if (user == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("Invalid Credentials")));
                            } else {
                              Navigator.pushReplacementNamed(context, '/');
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        "Minimum 6 Digit Password required")));
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Invalid Email")));
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10)),
                        child: const Text(
                          'Sign In',
                          style: TextStyle(
                              fontSize: 40,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: double.maxFinite,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Don't Have An account?  ",
                            style: TextStyle(fontSize: 15),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context)
                                  .pushReplacementNamed('/sign_up');
                            },
                            child: const Text(
                              'Create One',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
