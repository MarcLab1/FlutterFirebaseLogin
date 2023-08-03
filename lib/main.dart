import 'package:flutter/material.dart';
import 'package:my_app/register/ui/register_page.dart';

import 'core/firebase_options.dart';
import 'loggedin/ui/loggedin_page.dart';
import 'login/ui/login_page.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase is kool',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.tealAccent),
        useMaterial3: true,
      ),
      initialRoute: '/',
      onGenerateRoute: (RouteSettings settings) {
        if (settings.name == '/') {
          return SlideRoute(page: LoginWidget(), settings: settings);
        }
        if (settings.name == '/loggedin') {
          return SlideRoute(page: LoggedinWidget(), settings: settings);
        }
        if (settings.name == '/register') {
          return SlideRoute(page: RegisterWidget(), settings: settings);
        }
      },
    );
  }
}

class SlideRoute extends PageRouteBuilder {
  final Widget page;
  final RouteSettings settings;
  SlideRoute({required this.page, required this.settings})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          settings: settings,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
}
