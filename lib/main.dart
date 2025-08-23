import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:voting_client/pages/FlashPage.dart';
import 'package:voting_client/pages/HomePage.dart';
import 'package:voting_client/pages/LoginPage.dart';
import 'package:voting_client/utils/ApiProvider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => Apiprovider())],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final GoRouter _router = GoRouter(
      routes: [
        // GoRoute(path: "/", builder: (context, state) => HomePage()),
        GoRoute(path: "/", builder: (context, state) => FlashPage()),
        GoRoute(path: "/home", builder: (context, state) => HomePage()),
        GoRoute(path: "/login", builder: (context, state) => LoginPage()),
      ],
    );
    return MaterialApp.router(
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
  }
}
