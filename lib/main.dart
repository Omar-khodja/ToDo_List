import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app/feature/home/presentation/screen/todoList_screen.dart';

final kColorscheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 27, 3, 244),
  brightness: Brightness.dark,
);
void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData().copyWith(
        colorScheme: kColorscheme,
        scaffoldBackgroundColor: kColorscheme.surface,
        appBarTheme: AppBarTheme(
          backgroundColor: kColorscheme.primaryContainer,
          foregroundColor: kColorscheme.onPrimaryContainer,
        ),
        textTheme: GoogleFonts.ubuntuCondensedTextTheme().copyWith(
          titleLarge:  GoogleFonts.ubuntu(color: kColorscheme.onSurface),
          titleMedium: GoogleFonts.ubuntu(color: kColorscheme.onSurface),
          titleSmall: GoogleFonts.ubuntu(color: kColorscheme.onSurface),
        ),),
      
      home: const TodolistScreen(),
    );
  }
}
