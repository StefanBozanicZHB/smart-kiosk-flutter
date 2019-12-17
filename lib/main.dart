import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_kiosk/helpers/custom_route.dart';
import 'package:smart_kiosk/providers/cart.dart';
import 'package:smart_kiosk/providers/kiosks.dart';
import 'package:smart_kiosk/providers/products.dart';
import 'package:smart_kiosk/providers/reservations.dart';
import 'package:smart_kiosk/screens/cart_screen.dart';
import 'package:smart_kiosk/screens/first_screen.dart';
import 'package:smart_kiosk/screens/kiosk_screen.dart';
import 'package:smart_kiosk/screens/products_list_screen.dart';
import 'package:smart_kiosk/screens/reservation_details_screen.dart';
import 'package:smart_kiosk/screens/reservation_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  MaterialColor _primaryColorShades = MaterialColor(
    0xFF181861,
    <int, Color>{
      50: Color(0xFFA4A4BF),
      100: Color(0xFFA4A4BF),
      200: Color(0xFFA4A4BF),
      300: Color(0xFF9191B3),
      400: Color(0xFF7F7FA6),
      500: Color(0xFF181861),
      600: Color(0xFF6D6D99),
      700: Color(0xFF5B5B8D),
      800: Color(0xFF494980),
      900: Color(0xFF181861),
    },
  );

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Reservations(),
        ),
        ChangeNotifierProvider.value(
          value: Kiosks(),
        ),
        ChangeNotifierProvider.value(
          value: Products(),
        ),
        ChangeNotifierProvider.value(
          value: Cart(),
        ),
//        ChangeNotifierProxyProvider<Auth, Products>(
//          builder: (ctx, auth, previousProducts) => Products(
//            auth.token,
//            auth.userId,
//            previousProducts == null ? [] : previousProducts.items,
//          ),
//        ),
      ],
      child: MaterialApp(
        title: 'Shop Kiosk',
        theme: ThemeData(
          primarySwatch: _primaryColorShades,
          accentColor: Colors.amber,
          canvasColor: Color.fromRGBO(255, 254, 229, 1),
          fontFamily: 'Raleway',
          textTheme: ThemeData.light().textTheme.copyWith(
                body1: TextStyle(color: Color.fromRGBO(20, 51, 51, 1)),
                body2: TextStyle(
                  color: Color.fromRGBO(20, 51, 51, 1),
                ),
                title: TextStyle(
                  fontSize: 12,
                  fontFamily: 'RobotoCondensed',
                  fontWeight: FontWeight.bold,
                ),
                headline: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
                overline: TextStyle(
                  fontSize: 22,
                ),
              ),
          pageTransitionsTheme: PageTransitionsTheme(
            builders: {
              TargetPlatform.android: CustomPageTransitionBuilder(),
              TargetPlatform.iOS: CustomPageTransitionBuilder(),
            },
          ),
        ),
        home: FirstScreen(),
        routes: {
          CartScreen.routeName: (ctx) => CartScreen(),
          ReservationScreen.routeName: (ctx) => ReservationScreen(),
          ReservationDetailsScreen.routeName: (ctx) =>
              ReservationDetailsScreen(),
          KioskScreen.routeName: (ctx) => KioskScreen(),
          ProductsListScreen.routeName: (ctx) => ProductsListScreen(),
          FirstScreen.routeName: (ctx) => FirstScreen(),
        },
      ),
    );
  }
}
