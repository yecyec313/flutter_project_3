import 'package:flutter/material.dart';
import 'package:nike_ecommerce_flutter/data/favorite_manager.dart';
import 'package:nike_ecommerce_flutter/data/repo/auth_repository.dart';
import 'package:nike_ecommerce_flutter/theme.dart';
import 'package:nike_ecommerce_flutter/ui/root.dart';

void main() async {
  await FavoriteManager.init();
  WidgetsFlutterBinding.ensureInitialized();
  authRepository.loadAuthInfo();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    const defaultTextStyle = TextStyle(
        fontFamily: 'IranYekan', color: LightThemeColors.primaryTextColor);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        hintColor: LightThemeColors.secondaryTextColor,
        inputDecorationTheme: InputDecorationTheme(
            border: const OutlineInputBorder(),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color:
                        LightThemeColors.primaryTextColor.withOpacity(0.1)))),
        appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            elevation: 0,
            foregroundColor: LightThemeColors.primaryTextColor),
        scaffoldBackgroundColor: Colors.white,
        snackBarTheme: SnackBarThemeData(
            contentTextStyle: defaultTextStyle.apply(color: Colors.white)),
        textTheme: TextTheme(
            titleMedium: defaultTextStyle.apply(
                color: LightThemeColors.secondaryTextColor),
            bodyMedium: defaultTextStyle,
            labelLarge: defaultTextStyle,
            bodySmall: defaultTextStyle.apply(
                color: LightThemeColors.secondaryTextColor),
            titleLarge: defaultTextStyle.copyWith(
                fontWeight: FontWeight.bold, fontSize: 18)),
        colorScheme: const ColorScheme.light(
            primary: LightThemeColors.primaryColor,
            secondary: LightThemeColors.secondaryColor,
            onSecondary: Colors.white,
            surfaceVariant: Color(0xffF5F5F5)),
      ),
      home: const Directionality(
          textDirection: TextDirection.rtl, child: RootScreen()),
    );
  }
}
