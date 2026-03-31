import 'package:flutter/material.dart';
import 'package:flutter_assignment_login/core/theme/app_theme.dart';
import 'package:flutter_assignment_login/data/repositories/auth_repository.dart';
import 'package:flutter_assignment_login/data/services/auth_service.dart';
import 'package:flutter_assignment_login/data/storage/session_storage.dart';
import 'package:flutter_assignment_login/presentation/providers/auth_provider.dart';
import 'package:flutter_assignment_login/presentation/screens/auth_gate_screen.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AppBootstrap());
}

class AppBootstrap extends StatelessWidget {
  const AppBootstrap({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(create: (_) => DummyJsonAuthService()),
        Provider<SessionStorage>(create: (_) => SharedPrefsSessionStorage()),
        Provider<AuthRepository>(
          create: (context) => AuthRepositoryImpl(
            authService: context.read<AuthService>(),
            sessionStorage: context.read<SessionStorage>(),
          ),
        ),
        ChangeNotifierProvider<AuthProvider>(
          create: (context) =>
              AuthProvider(authRepository: context.read<AuthRepository>()),
        ),
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Assignment Login',
      theme: AppTheme.lightTheme,
      home: const AuthGateScreen(),
    );
  }
}
