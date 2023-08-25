import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TradeArea extends StatefulWidget {
  const TradeArea({super.key});

  @override
  State<TradeArea> createState() => _TradeAreaState();
}

class _TradeAreaState extends State<TradeArea> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(134, 255, 191, 0),
            title: Row(
              children: [
                const Expanded(flex: 1,child: Text(''),),
                Text('Zelix Trade',style: GoogleFonts.pacifico(fontSize: 28),),
                const Expanded(flex: 1,child: Text(''),),
              ],
            ),),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            height: height,
            width: width,
            decoration: const BoxDecoration(
              image: DecorationImage(
                   colorFilter: ColorFilter.mode(
                     Colors.white,
                     BlendMode.softLight,
                   ),
                   image: AssetImage("assets/images/tradebg.png"),
                   //repeat: ImageRepeat.repeat,
                   fit: BoxFit.contain,
                   alignment: Alignment.topCenter,
                   opacity: 0.3
                 ),
            ),
          )),
      ),
    );
  }
}