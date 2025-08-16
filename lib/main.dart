import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:voting_client/pages/FlashPage.dart';
import 'package:voting_client/pages/HomePage.dart';
import 'package:voting_client/pages/LoginPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final GoRouter _router = GoRouter(
      // routes: [GoRoute(path: "/", builder: (context, state) => FlashPage())],
      routes: [GoRoute(path: "/", builder: (context, state) => HomePage())],
    );
    return MaterialApp.router(
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
  }
}
