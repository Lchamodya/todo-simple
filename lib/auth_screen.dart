import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'auth_guard.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final LocalAuthentication _localAuth = LocalAuthentication();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _authenticate());
  }

  Future<void> _authenticate() async {
    try {
      bool authenticated = await _localAuth.authenticate(
        localizedReason: 'Authenticate to access the app',
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );

      if (authenticated) {
        setState(() {
          AuthGuard.isAuthenticated = true;
        });
        _navigateToHome();
      } else {
        _exitApp(); // Exit the app if authentication fails
      }
    } catch (e) {
      _exitApp(); // Exit the app on exception
    }
  }

  void _navigateToHome() {
    Navigator.pushReplacementNamed(context, '/home');
  }

  void _exitApp() {
    Future.delayed(const Duration(milliseconds: 500), () {
      SystemNavigator.pop(); // Exit the app
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // Disable back navigation
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.lock, size: 100, color: Colors.grey),
              SizedBox(height: 20),
              Text('Secure App', style: TextStyle(fontSize: 24)),
              SizedBox(height: 10),
              Text('Authenticating...', style: TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }
}
