import 'package:flutter/material.dart';
import 'package:resistor/home.dart';

class MySplash extends StatefulWidget {
  const MySplash({super.key});
   
  @override
  State<MySplash> createState() => _MySplashState();
}

class _MySplashState extends State<MySplash> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _navigatetohome();
  }
  _navigatetohome() async
  {
    await Future.delayed(const Duration(milliseconds: 2000),(){});
    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const MyHomePage()));
  }
  @override
  Widget build(BuildContext context) {
     return const Scaffold(
      body: Center(
        child: Text(
          'Splash',
          style: TextStyle(
            fontSize: 24, 
            fontWeight: FontWeight.bold
          ),
        ),
      ),);
  }
}