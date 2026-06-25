import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app/core/notification/notificationservice.dart';
import 'package:todo_app/feature/home/presentation/screen/todoList_screen.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

const ColorScheme customColorScheme = ColorScheme(
  brightness: Brightness.light,

  // Primary brand color
  primary: Color(0xFF3b82f6),
  onPrimary: Color(0xFFFFFFFF),
  primaryContainer: Color(0xFFdbeafe), // lighter container
  onPrimaryContainer: Color(0xFF1e3a8a),

  // Secondary accent
  secondary: Color(0xFFe50914),
  onSecondary: Color(0xFFFFFFFF),
  secondaryContainer: Color(0xFFfecaca),
  onSecondaryContainer: Color(0xFF7f1d1d),

  // Tertiary (optional accent)
  tertiary: Color(0xFF3b82f6),
  onTertiary: Color(0xFFFFFFFF),
  tertiaryContainer: Color(0xFFbfdbfe),
  onTertiaryContainer: Color(0xFF1e40af),

  // Error colors
  error: Color(0xFFCF6679),
  onError: Color(0xFFFFFFFF),
  errorContainer: Color(0xFFfca5a5),
  onErrorContainer: Color(0xFF7f1d1d),

  // Surfaces & backgrounds
  surface: Color.fromARGB(255, 252, 250, 244),
  onSurface: Color(0xFF000000),
  surfaceContainer: Color.fromARGB(255, 249, 245, 231),
  onSurfaceVariant: Color(0xFF475569),

  // Outlines & shadows
  outline: Color(0xFF94a3b8),
  outlineVariant: Color(0xFFcbd5e1),
  shadow: Color(0xFF000000),
  scrim: Color(0xFF000000),

  // Inverse colors
  inverseSurface: Color(0xFF1e293b),
  onInverseSurface: Color(0xFFFFFFFF),
  inversePrimary: Color(0xFF2563eb),

  // Tint
  surfaceTint: Color(0xFF3b82f6),
);
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Africa/Algiers'));

  await initializeNotifications();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  static final lightTheme = ThemeData(
    textTheme: GoogleFonts.montserratTextTheme(
      ThemeData.dark().textTheme.copyWith(
        titleLarge: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        titleMedium: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        bodyMedium: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
    ),
    useMaterial3: true,
    colorScheme: customColorScheme,
    scaffoldBackgroundColor: customColorScheme.surface,
    appBarTheme: AppBarTheme(
      backgroundColor: customColorScheme.primary,
      foregroundColor: customColorScheme.onPrimary,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: customColorScheme.onPrimary,
      ),
    ),
  );

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: lightTheme,

      home: const TodolistScreen(),
    );
  }
}
