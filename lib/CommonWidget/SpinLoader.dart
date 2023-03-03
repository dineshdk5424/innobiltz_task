import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
class SpinLoader extends StatefulWidget {
  const SpinLoader({super.key});

  @override
  State<SpinLoader> createState() => _SpinLoaderState();
}

class _SpinLoaderState extends State<SpinLoader> {

  @override
  Widget build(BuildContext context) {
          double screenHeight = MediaQuery.of(context).size.height;

    return Column(
      children: [
        SizedBox(height: screenHeight * 0.2,),
        Container(
          child: SpinKitDualRing(color: Colors.red, size: 20,)),
      ],
    );
  }
}