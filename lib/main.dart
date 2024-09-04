import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:live_locator/GlobalProvider.dart';
import 'package:live_locator/home_page.dart';
import 'package:provider/provider.dart';

//----------------------------------------------------------------------------//
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp(homeScreen: HomePage()));
}

//----------------------------------------------------------------------------//
class MyApp extends StatefulWidget {
  final Widget? homeScreen;
  const MyApp({Key? key, this.homeScreen}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

//----------------------------------------------------------------------------//
class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LocationProvider()),
      ],
      child: MaterialApp(
        scrollBehavior: MyCustomScrollBehavior(),
        useInheritedMediaQuery: true,
        theme: ThemeData(
          primarySwatch: Colors.indigo,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        debugShowCheckedModeBanner: false,
        home: widget.homeScreen,
      ),
    );
  }
}

//---------------------------------MyHttpOverrides----------------------------//
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

//----------------------------------------------------------------------------//
class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
  };
}
