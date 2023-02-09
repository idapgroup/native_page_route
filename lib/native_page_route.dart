library native_page_route;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Creates a page route for use in an native style.
///
/// [maintainState]
/// https://api.flutter.dev/flutter/widgets/ModalRoute/maintainState.html
///
/// [fullscreenDialog]
/// https://api.flutter.dev/flutter/widgets/PageRoute/fullscreenDialog.html
///
/// [iosTitle]
/// https://api.flutter.dev/flutter/cupertino/CupertinoPageRoute/title.html
///
PageRoute<T> nativePageRoute<T>({
  required WidgetBuilder builder,
  required RouteSettings settings,
  bool? maintainState,
  bool? fullscreenDialog,
  String? iosTitle,
}) {
  if (defaultTargetPlatform == TargetPlatform.iOS) {
    return CupertinoPageRoute<T>(
      builder: builder,
      settings: settings,
      maintainState: maintainState ?? true,
      fullscreenDialog: fullscreenDialog ?? false,
      title: iosTitle,
    );
  } else {
    return MaterialPageRoute<T>(
      builder: builder,
      settings: settings,
      maintainState: maintainState ?? true,
      fullscreenDialog: fullscreenDialog ?? false,
    );
  }
}

/// Creates a page route for use in an native style, that cannot be displayed twice in a row
///
/// [maintainState]
/// https://api.flutter.dev/flutter/widgets/ModalRoute/maintainState.html
///
/// [fullscreenDialog]
/// https://api.flutter.dev/flutter/widgets/PageRoute/fullscreenDialog.html
///
/// [iosTitle]
/// https://api.flutter.dev/flutter/cupertino/CupertinoPageRoute/title.html
///
PageRoute<T>? notRepeatableNativePageRoute<T>({
  required WidgetBuilder builder,
  required RouteSettings settings,
  required BuildContext context,
  bool? maintainState,
  bool? fullscreenDialog,
  String? iosTitle,
}) {
  assert(
    settings.name != null,
    'You need to pass name of route when you push your controller on stack.',
  );
  String? name;

  Navigator.of(context).popUntil((route) {
    name = route.settings.name;
    return true;
  });

  if (name == settings.name) {
    return null;
  }

  return nativePageRoute(
    builder: builder,
    settings: settings,
    maintainState: maintainState,
    fullscreenDialog: fullscreenDialog,
    iosTitle: iosTitle,
  );
}
