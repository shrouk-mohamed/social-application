import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:untitled3/shared/styles/colors.dart';


ThemeData lightTheme = ThemeData(
  primarySwatch:  defaultColor , // for circulerProgressIndecator
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: const AppBarTheme(
    iconTheme: IconThemeData(color: Colors.black),
    backgroundColor: Colors.white,
    titleTextStyle: TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
      height: 1,
      fontSize: 24,
    ),
    actionsIconTheme: IconThemeData(
      color: Colors.black,
    ),
    elevation: 0,
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
    ),
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    selectedItemColor: defaultColor  ,
    unselectedItemColor: Colors.grey,
    backgroundColor: Colors.white,
    elevation: 20,
  ),
  textTheme: const TextTheme(
    bodyText1: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 18,
      color: Colors.black,
    ),
    subtitle1: TextStyle(
      fontSize: 14.0,
      fontWeight: FontWeight.w600,
      color:  Colors.black,
      height: 1.3,
    ),
  ),
);

ThemeData darkTheme = ThemeData(
 // for circulerProgressIndecator
  primarySwatch: defaultColor ,
  scaffoldBackgroundColor: HexColor("333739"),
  appBarTheme: AppBarTheme(
    backgroundColor: HexColor("333739"),
    titleTextStyle: const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 24,
    ),
    actionsIconTheme: const IconThemeData(
      color: Colors.white,
    ),
    elevation: 0,
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: HexColor("333739"),
      statusBarIconBrightness: Brightness.light,
    ),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    selectedItemColor: defaultColor,
    unselectedItemColor: Colors.grey,
    backgroundColor: HexColor("333739"),
    elevation: 20,
  ),
  textTheme: const TextTheme(
    bodyText1: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 18,
      color: Colors.white,
    ),
    subtitle1: TextStyle(
      fontSize: 14.0,
      fontWeight: FontWeight.w600,
      color:  Colors.white,
      height: 1.4,
    ),
  ),
);


