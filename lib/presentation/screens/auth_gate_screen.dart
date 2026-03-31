import 'package:flutter/material.dart';
import 'package:flutter_assignment_login/presentation/providers/auth_provider.dart';
import 'package:flutter_assignment_login/presentation/screens/home_screen.dart';
import 'package:flutter_assignment_login/presentation/screens/login_screen.dart';
import 'package:provider/provider.dart';

class AuthGateScreen extends StatefulWidget {
  const AuthGateScreen({super.key});

  @override
  State<AuthGateScreen> createState() => _AuthGateScreenState();
}

class _AuthGateScreenState extends State<AuthGateScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AuthProvider>().init();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    if (!authProvider.isInitialized || authProvider.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (authProvider.isAuthenticated) {
      return const HomeScreen();
    }

    return const LoginScreen();
  }
}
