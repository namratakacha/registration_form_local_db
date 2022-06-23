import 'dart:async';

import 'package:flutter/material.dart';
import 'package:registration_local_db/home.dart';
import 'package:registration_local_db/registration.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Timer(
        Duration(seconds: 3),
            () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MyHomePage())));

    return Container(
        child: Container(
          color: Colors.blue,
          child: Center(
            child: Text('Explore Hive', style: TextStyle(color: Colors.black,fontSize: 26, decoration: TextDecoration.none, fontWeight: FontWeight.bold),),
          ),
        ));
  }
}
