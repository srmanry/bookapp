import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:libararybd/core/theme/dark_theme.dart';
import 'package:libararybd/core/theme/light_theme.dart';

import 'feature/auth/presentation/view/login_screen_view.dart';

void main() {
  runApp(const MyApp());
}

/*void main() => runApp(
  DevicePreview(
    enabled: !kReleaseMode,
    builder: (context) => MyApp(), // Wrap your app
  ),
);*/

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Shelf Story',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.light,
      debugShowCheckedModeBanner: false,
      home: const LoginScreenView(),
    );
  }
}
