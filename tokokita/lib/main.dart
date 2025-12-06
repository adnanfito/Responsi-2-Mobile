import 'package:flutter/material.dart';
import 'package:tokokita/helpers/user_info.dart';
import 'package:tokokita/ui/login_page.dart';
import 'package:tokokita/ui/produk_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget page = const Center(child: CircularProgressIndicator());

  @override
  void initState() {
    super.initState();
    isLogin();
  }

  void isLogin() async {
    final token = await UserInfo().getToken();
    if (token != null && token.isNotEmpty) {
      setState(() {
        page = const ProdukPage();
      });
    } else {
      setState(() {
        page = const LoginPage();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Palet monokrom / abu-abu
    const background = Color(0xFFF2F2F2); // very light grey
    const surface = Color(0xFFFFFFFF); // white (cards)
    const card = Color(0xFFF5F5F5); // slightly darker card
    const divider = Color(0xFFE0E0E0);
    const muted = Color(0xFF9E9E9E); // text/secondary
    const primary = Color(0xFF9E9E9E); // neutral primary
    const appBar = Color(0xFFBDBDBD);

    final baseTheme = ThemeData.light();
    final theme = baseTheme.copyWith(
      scaffoldBackgroundColor: background,
      primaryColor: primary,
      colorScheme: baseTheme.colorScheme.copyWith(
        primary: primary,
        background: background,
        surface: surface,
        onSurface: Colors.black87,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: appBar,
        elevation: 1,
        titleTextStyle: TextStyle(color: Colors.black87, fontSize: 18),
        iconTheme: IconThemeData(color: Colors.black87),
      ),
      cardTheme: const CardThemeData(
        color: card,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      ),
      dialogTheme: const DialogThemeData(
        backgroundColor: surface,
        titleTextStyle: TextStyle(
          color: Colors.black87,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        contentTextStyle: TextStyle(color: Colors.black87),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
      dividerColor: divider,
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Color(0xFFF8F8F8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: muted, width: 1),
        ),
      ),
      textTheme: baseTheme.textTheme.apply(
        bodyColor: Colors.black87,
        displayColor: Colors.black87,
      ),
      iconTheme: const IconThemeData(color: Colors.black54),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: appBar,
          foregroundColor: Colors.black87,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primary,
      ),
    );

    return MaterialApp(
      title: 'Toko Kita',
      debugShowCheckedModeBanner: false,
      theme: theme,
      home: page,
    );
  }
}
