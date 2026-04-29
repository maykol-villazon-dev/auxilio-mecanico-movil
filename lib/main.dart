import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme/app_theme.dart';
import 'routes/app_routes.dart';
import 'providers/auth_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Auxilio Mecánico',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      
      // Control de sesión inicial
      initialRoute: AppRoutes.splash,
      routes: AppRoutes.routes,
    );
  }
}
