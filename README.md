<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

# Native page route

Wraps creation of native page route in simple function. Also provide function with preventing of creation the same route twice. Is fully tested on mobile (Android/iOS).

## Usage

To use this plugin, add `native_page_route` as a [dependency in your pubspec.yaml file](https://flutter.dev/docs/development/platform-integration/platform-channels).

### Examples
Here are small example that show you how to use this library.

#### Creation of native page route
```dart
// Creating a platform page route.
nativePageRoute(
    builder: (context) => const YourAwesomeScreen(),
    settings: RouteSettings(name: 'YourAwesomeScreenConstantName', arguments: SomeArguments()),
    maintainState: true,
    fullscreenDialog: true,
    iosTitle: 'Awesome',
);

// Creating an platform page route, that returns null if this screen already presented.
notRepeatableNativePageRoute(
    builder: (context) => const YourAwesomeScreen(),
    context: context,
    settings: RouteSettings(name: 'YourAwesomeScreenConstantName', arguments: SomeArguments()),
    maintainState: true,
    fullscreenDialog: true,
    iosTitle: 'Awesome',
);
```