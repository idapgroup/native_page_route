import 'package:flutter/material.dart';
import 'package:native_page_route/native_page_route.dart';
import 'package:native_page_route_example/main.dart';

class SecondAwesomeScreen extends StatelessWidget {
  const SecondAwesomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              child: const Text('First screen'),
              onPressed: () =>
                  Navigator.of(context).pushNamed(RouteKeys.firstScreen),
            ),
            TextButton(
              child: const Text('Second screen, shows only once in a row'),
              onPressed: () =>
                  Navigator.of(context).pushNamed(RouteKeys.secondScreen),
            ),
          ],
        ),
      ),
    );
  }
}

class FirstAwesomeScreen extends StatelessWidget {
  const FirstAwesomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SecondAwesomeScreen();
  }
}

abstract class RouteKeys {
  static const String firstScreen = 'firstScreen';
  static const String secondScreen = 'secondScreen';
}

// ignore: non_constant_identifier_names, body_might_complete_normally_nullable
Route<dynamic>? AppRouter(RouteSettings settings) {
  switch (settings.name) {
    case RouteKeys.firstScreen:
      return nativePageRoute(
        builder: (_) => const FirstAwesomeScreen(),
        settings: settings,
      );
    case RouteKeys.secondScreen:
      return notRepeatableNativePageRoute(
        builder: (_) => const SecondAwesomeScreen(),
        context: NavigationService.navigatorKey.currentContext!,
        settings: settings,
      );
  }
}
