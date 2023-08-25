import 'package:clipboard/clipboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zelix_trade/screens/home.dart';
import 'package:zelix_trade/screens/tradearea.dart';
import 'package:zelix_trade/services/database.dart';

class CreateTrade extends StatefulWidget {
  final String traderoomid;
  const CreateTrade({super.key, required this.traderoomid});

  @override
  State<CreateTrade> createState() => _CreateTradeState();
}

class _CreateTradeState extends State<CreateTrade> {
  final CollectionReference<Map<String, dynamic>> traderooms = FirebaseFirestore.instance.collection('traderooms');
  bool copychecked = false;

  Widget copyCheck(){
    if(copychecked){
        return ElevatedButton(child:Text('Start',style: GoogleFonts.pacifico(fontSize: 25),),
                     onPressed: ()async{await Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) =>const TradeArea()),);});
    }else{
        return const Text('Start',style: TextStyle(fontSize: 20,color:Colors.black,fontWeight: FontWeight.bold),);
    }
  }
  Widget copyClicked(){
    if(!copychecked){
      return ElevatedButton(
                     child: Text('Copy',style: GoogleFonts.pacifico(fontSize: 25,),),
                     onPressed: (){
                       FlutterClipboard.copy(widget.traderoomid);
                       setState(() {
                         copychecked = true;
                       });
                       print('copychecked : $copychecked');
                       }
                   );
    }
    else{
      return const Text('Copy',style: TextStyle(fontSize: 20,color:Colors.black,fontWeight: FontWeight.bold),);
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: traderooms.snapshots(),
      builder: (context, snapshot) {
        if(!snapshot.hasData){return const Center(child: CircularProgressIndicator(color: Colors.green,strokeWidth: 10,));}
        return Scaffold(
        appBar: AppBar(
        backgroundColor: const Color.fromARGB(134, 255, 191, 0),
            title: Row(
              children: [
                const Expanded(flex: 1,child: Text(''),),
                Text('Zelix Trade',style: GoogleFonts.pacifico(fontSize: 28),),
                const Expanded(flex: 1,child: Text(''),),
              ],
            ),
        ),
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
                  child: Column(
                    children: [
                      Container(height: height*0.3,),
                      Text('Share This With Your Partner',style: GoogleFonts.pacifico(color: const Color.fromARGB(255, 224, 108, 0),fontSize: 18,fontWeight: FontWeight.bold,letterSpacing: 2),),
                      const SizedBox(height: 30),
                      Text(widget.traderoomid,style: const TextStyle(fontSize: 15,color:Colors.black,fontWeight: FontWeight.bold),),
                      const SizedBox(height: 30,),
                      Row(children: [
                         const Expanded(flex: 10,child: Text(''),),
                         copyClicked(),
                         const Expanded(flex: 1,child: Text(''),),
                         copyCheck(),
                         const Expanded(flex: 10,child: Text(''),),
                      ],),
                      const Expanded(flex: 1,child: Text(''),),
                      ElevatedButton(

                        style: ButtonStyle(
                         backgroundColor:MaterialStateProperty.all<Color>(const Color.fromARGB(98, 255, 157, 0)),
                         shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                           RoundedRectangleBorder(
                             borderRadius: BorderRadius.circular(28.0),
                             side: const BorderSide(color: Colors.red),
                           )
                         )
                        ),
                       onPressed: ()async{
                         await DatabaseService().clearLastRoom().then((value) async => 
                        
                         await Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => const Home()), ));
                        },
                       child:Padding(
                         padding: const EdgeInsets.all(15.0),
                         child: Text('BACK TO MENU',style: GoogleFonts.pacifico(fontSize: 30,color: Colors.black)),
                       ),
                       ),
                      const Expanded(flex: 1,child: Text(''),),  
                  ],
                ),
              ),
            ),
      ),
        );
      }
    );
  }
}