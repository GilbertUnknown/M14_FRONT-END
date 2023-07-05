import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:m12/darktheme.dart';
import 'package:m12/mainpage.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (_) => DarkThemeProvider(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<DarkThemeProvider>(context);
    return MaterialApp(
      title: 'Todos',
      theme: themeProvider.darkTheme == true
          ? themeProvider.dark
          : themeProvider.light,
      home: const MainPage(title: 'Todos'),
      debugShowCheckedModeBanner: false,
    );
  }
}