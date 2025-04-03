import 'package:flutter/material.dart';
import 'package:hopepals_game/screens/onboding/onboding_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://bxtgcckefuzdymqklekg.supabase.co/auth/v1/callback',  // Reemplaza con tu URL de Supabase
    anonKey: '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',  // Reemplaza con tu clave anónima
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HopePals',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFEEF1F8),
        primarySwatch: Colors.blue, // Cambiado a un MaterialColor
        fontFamily: "Intel",
        colorScheme: ColorScheme(
          primary: Colors.blue[500]!, // Color principal
          secondary: Colors.blue[300]!, // Color secundario
          surface: Colors.white, // Color de la superficie
          background: const Color(0xFFEEF1F8), // Color de fondo
          error: Colors.blueGrey, // Color de error
          onPrimary: Colors.white, // Color para elementos en el color principal
          onSecondary: Colors.white, // Color para elementos en el color secundario
          onSurface: Colors.black, // Color para elementos en la superficie
          onBackground: Colors.black, // Color para elementos en el fondo
          onError: Colors.white, // Color para elementos en el color de error
          brightness: Brightness.light, // Modo claro
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(foregroundColor: Colors.white),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          errorStyle: TextStyle(height: 0),
          border: defaultInputBorder,
          enabledBorder: defaultInputBorder,
          focusedBorder: defaultInputBorder,
          errorBorder: defaultInputBorder,
        ),
      ),


      home: const OnbodingScreen(),
    );
  }
}

const defaultInputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.all(Radius.circular(16)),
  borderSide: BorderSide(
    color: Color(0xFFDEE3F2),
    width: 1,
  ),
);
