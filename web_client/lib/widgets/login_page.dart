import 'package:flutter/material.dart';
import 'package:web_client/services/authentication_service.dart';

class LoginPage extends StatelessWidget {
  final AuthenticationService authService;

  const LoginPage({
    required this.authService,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
          onTap: () => authService
              .signInWithGoogle()
              .then((_) => Navigator.of(context).pushReplacementNamed('/')),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image(
                image: AssetImage('assets/logo/google.png'),
                height: 30.0,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text('Sign by Google', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
