import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './providers/auth.dart';
import './screens/auth_screen.dart.dart';
import './screens/edit_product_screen.dart';
import './screens/user_product_screen.dart';
import './screens/order_screen.dart';
import './providers/orders.dart';
import './screens/cart_screen.dart';
import './providers/cart.dart';

import './screens/product_detail_screen.dart';

import './screens/product_overview_screen.dart';
import './providers/products.dart';



void main()async {

    runApp(MyApp());

}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  MultiProvider(providers: [
        ChangeNotifierProvider(
        create: (ctx)=>Products(),),
      ChangeNotifierProvider(
        create: (ctx)=>Auth(),),
      ChangeNotifierProvider(
        create: (ctx)=>Cart(),),
      ChangeNotifierProvider(
        create: (ctx)=>Orders(),),

    ],
      child: MaterialApp(

        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.redAccent,
          fontFamily: 'Lato'
        ),
        home: AuthScreen(),
        themeMode: ThemeMode.light,
        darkTheme: ThemeData(primaryColor: Colors.black),
        routes: {
          ProductDetailScreen.routeName:(ctx)=>ProductDetailScreen(),
          CartScreen.routeNamed:(ctx)=>CartScreen(),
          OrderScreen.routeName:(ctx)=>OrderScreen(),
          UserProductScreen.routeName:(ctx)=>UserProductScreen(),
          EditProductScreen.routeName:(ctx)=>EditProductScreen(),
          AuthScreen.routeName:(ctx)=>AuthScreen(),

        }
      ),
    );
  }
}
