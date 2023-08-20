import 'package:flutter/material.dart';
import 'package:ticketflix/confirm_page.dart';
import 'package:ticketflix/styles/fonts.dart';
import 'location.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'splashscreen.dart';

import 'home.dart';
import 'package:ticketflix/payment.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const Ticketflix());
}

class Ticketflix extends StatelessWidget {
  const Ticketflix({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: const TextTheme(
          bodyMedium: Style.noto,
          bodyLarge: Style.noto,
          bodySmall: Style.noto,
          labelMedium: Style.noto,
          labelLarge: Style.noto,
          labelSmall: Style.noto,
          titleMedium: Style.noto,
          titleLarge: Style.noto,
        ),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        MoviesPage.routeName: (context) => const MoviesPage(),
        CinemasPage.routeName: (context) => const CinemasPage(),
        ShowtimesPage.routeName: (context) => const ShowtimesPage(),
        BookingPage.routeName: (context) => const BookingPage(),
        PromotionsPage.routeName: (context) => const PromotionsPage(),
        NotificationsPage.routeName: (context) => const NotificationsPage(),
        HelpPage.routeName: (context) => const HelpPage(),
        LogoutPage.routeName: (context) => const LogoutPage(),
        ImageDetailPage.routeName: (context) => ImageDetailPage(),

        '/': (context) => const splashscreen(),
        // ignore: prefer_const_constructors
        '/FlutterWavePaymen': (context) => FlutterWavePayment('Ticketflix'),
        '/MapSample': (context) => MapSample(),
        '/ConfirmPage': (context) => const ConfirmPage(),
        '/HomeScreen': (context) => const HomeScreen(),
      },
    );
  }
}
