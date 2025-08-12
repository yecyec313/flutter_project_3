import 'package:flutter/material.dart';
import 'package:flutter_ali_nike/Theme.dart';
import 'package:flutter_ali_nike/data/repo/auth_repository.dart';
import 'package:flutter_ali_nike/data/repo/repository.dart';
import 'package:flutter_ali_nike/data/repo/repositoryBanner.dart';
import 'package:flutter_ali_nike/data/repo/repository_comment.dart';
import 'package:flutter_ali_nike/data/source/Data_Source/hive_managger.dart';

import 'package:flutter_ali_nike/ui/root.dart';

void main() async {
  await HiveManagger.init();
  WidgetsFlutterBinding.ensureInitialized();
  repositoryAuth.loadAuthInfo();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    repositoryP.getAll(0).then((value) {
      debugPrint(value.toString());
    }).catchError((e) {
      debugPrint(e.toString());
    });
    commentsRepository.getAll(id: 502).then((value) {
      debugPrint(value.toString());
    }).catchError((e) {
      debugPrint(e.toString());
    });

    bannerRepository.getAll().then((value) {
      debugPrint(value[1].imageUrl.toString());
    }).catchError((e) {
      debugPrint(e.toString());
    });
    const defaultTextStyle = TextStyle(color: Colors.black
        //  LightThemeColor.primaryTextColor
        );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        //hintcolor مربوط به نوشته داخل textfield هست
        hintColor: LightThemeColor.secondaryTextColor,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: LightThemeColor.primaryTextColor.withOpacity(0.1),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        textTheme: TextTheme(
            bodyMedium: defaultTextStyle,
            bodySmall: defaultTextStyle.apply(
                color: LightThemeColor.secondaryTextColor),
            titleLarge: defaultTextStyle.copyWith(fontWeight: FontWeight.bold)),
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        dividerTheme: const DividerThemeData(color: Colors.grey),
        colorScheme: const ColorScheme.light(
          primary: LightThemeColor.primaryColor,
          secondary: LightThemeColor.secondaryColor,
          onSecondary: Colors.white,
        ),
        useMaterial3: true,
      ),
      home: const Directionality(
          textDirection: TextDirection.rtl, child: RootScreen()),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
