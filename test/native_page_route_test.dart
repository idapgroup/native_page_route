import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:native_page_route/native_page_route.dart';

abstract class RouteKeys {
  static const String repeatable = 'repeatable';
  static const String nonRepeatable = 'nonRepeatable';
}

// ignore: non_constant_identifier_names, body_might_complete_normally_nullable
Route<dynamic>? AppRouter(RouteSettings settings, BuildContext? context) {
  switch (settings.name) {
    case RouteKeys.repeatable:
      return nativePageRoute(
        builder: (_) => Container(),
        settings: settings,
      );
    case RouteKeys.nonRepeatable:
      return notRepeatableNativePageRoute(
        builder: (_) => Container(),
        context: context!,
        settings: settings,
      );
  }
}

GlobalKey<NavigatorState> navigationKey() {
  return GlobalKey<NavigatorState>();
}

class MyApp extends StatelessWidget {
  final GlobalKey<NavigatorState> navKey;
  final String initial;

  const MyApp({super.key, required this.navKey, required this.initial});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Native route example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      navigatorKey: navKey,
      initialRoute: initial,
      onGenerateRoute: (settings) => AppRouter(settings, navKey.currentContext),
    );
  }
}

class PreparedApp {
  Widget app;
  GlobalKey<NavigatorState> key;

  PreparedApp(this.app, this.key);
}

PreparedApp preparedApp(String initial) {
  final key = navigationKey();
  final app = MyApp(navKey: key, initial: initial);

  runApp(app);

  return PreparedApp(app, key);
}

void main() {
  testWidgets('Context exists', (tester) async {
    final prepared = preparedApp(RouteKeys.repeatable);
    await tester.pumpWidget(prepared.app);
    final contextExists = prepared.key.currentContext != null;

    expect(contextExists, true);
  });

  testWidgets(
    'If you try create notRepeatableNativePageRoute twice in row should return null',
    (tester) async {
      final prepared = preparedApp(RouteKeys.nonRepeatable);
      await tester.pumpWidget(prepared.app);
      final route = notRepeatableNativePageRoute(
        builder: (_) => Container(),
        settings: RouteSettings(name: RouteKeys.nonRepeatable),
        context: prepared.key.currentContext!,
      );

      expect(route, null);
    },
  );

  testWidgets(
    'If you try create nativePageRoute twice in a row it should return route',
    (tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      final prepared = preparedApp(RouteKeys.repeatable);
      await tester.pumpWidget(prepared.app);

      final route = nativePageRoute(
        builder: (_) => Container(),
        settings: RouteSettings(name: RouteKeys.repeatable),
      );

      expect(route is CupertinoPageRoute, true);
      debugDefaultTargetPlatformOverride = null;
    },
  );

  testWidgets(
    'If you try create nativePageRoute on iOS platform it should return CupertinoRoute',
    (tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;

      final route = nativePageRoute(
        builder: (_) => Container(),
        settings: RouteSettings(name: RouteKeys.nonRepeatable),
      );

      expect(route is CupertinoPageRoute<dynamic>, true);
      debugDefaultTargetPlatformOverride = null;
    },
  );

  testWidgets(
    'If you try create nativePageRoute on Android platform it should return MaterialRoute',
    (tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;

      final route = nativePageRoute(
        builder: (_) => Container(),
        settings: RouteSettings(name: RouteKeys.nonRepeatable),
      );

      expect(route is MaterialPageRoute<dynamic>, true);
      debugDefaultTargetPlatformOverride = null;
    },
  );

  testWidgets(
    'If you try create notRepeatableNativePageRoute on iOS platform it should return CupertinoRoute',
    (tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      final prepared = preparedApp(RouteKeys.nonRepeatable);
      await tester.pumpWidget(prepared.app);

      final route = notRepeatableNativePageRoute(
        builder: (_) => Container(),
        settings: RouteSettings(name: RouteKeys.repeatable),
        context: prepared.key.currentContext!,
      );

      expect(route is CupertinoPageRoute<dynamic>, true);
      debugDefaultTargetPlatformOverride = null;
    },
  );

  testWidgets(
    'If you try create notRepeatableNativePageRoute on Android platform it should return MaterialRoute',
    (tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;

      final prepared = preparedApp(RouteKeys.nonRepeatable);
      await tester.pumpWidget(prepared.app);

      final route = notRepeatableNativePageRoute(
        builder: (_) => Container(),
        settings: RouteSettings(name: RouteKeys.repeatable),
        context: prepared.key.currentContext!,
      );

      expect(route is MaterialPageRoute<dynamic>, true);
      debugDefaultTargetPlatformOverride = null;
    },
  );
}
