import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zelix_trade/screens/home.dart';
import 'package:zelix_trade/services/database.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({ Key? key }) : super(key: key);

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  final CollectionReference<Map<String, dynamic>> users  = FirebaseFirestore.instance.collection('users');
  String nickname = '';
  String takennicknameerror = '';

  @override
  void initState() {
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: users.snapshots(),
      builder: (context, snapshot) {
        if(!snapshot.hasData){
            return const Scaffold(body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(flex: 1,child: Text('')),
              Center(child: Text('Game preparing...',style: TextStyle(fontSize: 30,letterSpacing: 5),),),
              SizedBox(height: 12,),
              Center(child: CircularProgressIndicator(color: Colors.green,strokeWidth: 10,)),
              Expanded(flex: 1,child: Text('')),
            ],
                  ));
        }
            return Scaffold(
              appBar: AppBar(
                backgroundColor: const Color.fromARGB(134, 255, 191, 0),
                title: Row(
                  children: [
                    const Expanded(flex: 3,child: Text(''),),
                    Text('Zelix Trade',style: GoogleFonts.pacifico(fontSize: 30,letterSpacing: 4),),
                    const Expanded(flex: 3,child: Text(''),),
                  ],
                ),
              ),
              body: SingleChildScrollView(
                child: Center(
                  child: SizedBox(
                     height: height,
                 width: width,
                    child: Column(children: [
                    SizedBox(height: height*0.30,),
                    SizedBox(height: 50,child: Center(child: Text('Enter Your Nickname',style: GoogleFonts.pacifico(color: const Color.fromARGB(255, 0, 0, 0),fontSize: 30,decoration: TextDecoration.none),),),),
                    Card(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        
                        side:  const BorderSide(color: Color.fromARGB(255, 0, 0, 0),width: 1),
                      ),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        child: TextField(
                          cursorColor: Colors.brown,
                          style: GoogleFonts.pacifico(fontSize: 24,fontWeight: FontWeight.bold,letterSpacing: 4),
                          decoration: const InputDecoration(border: InputBorder.none),
                          onChanged: (v)=>setState(() {
                            nickname = v;
                          }),
                        ),
                      ),
                    ),
                    const SizedBox(height: 1,),
                    Center(child: Text(takennicknameerror,style:GoogleFonts.pacifico(color: Colors.redAccent,fontSize: 20,decoration: TextDecoration.none,letterSpacing: 4),),),
                    const SizedBox(height: 4,),
                    Container(
                      margin: const EdgeInsets.all(8),
                      child: ElevatedButton(onPressed: ()async{
                                if(snapshot.data!.docs == []){
                                  print('a');
                                   setState(() {
                                    takennicknameerror = '';
                                  });
                                  Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => const Home()), );
                                }
                                 else if(snapshot.data!.docs.any((e) => e.data().values.any((v) => v == nickname || nickname == ''))){
                                    print('b');
                                   setState(() {
                                     takennicknameerror = 'Enter a valid nickname';
                                   });
                                   
                                 }
                                 else{
                                    setState(() {
                                     takennicknameerror = '';
                                   });
                                   await DatabaseService().setNickname(nickname);
                                   await Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => const Home()), );
                                 }
                      },
                      style: ButtonStyle(
                        shadowColor: MaterialStateProperty.all<Color>(Colors.white38),
                        backgroundColor:MaterialStateProperty.all<Color>(const Color.fromARGB(165, 255, 183, 0)),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28.0),
                            side: const BorderSide(color: Color.fromARGB(255, 255, 255, 255)),
                          )
                        )
                       ), 
                      child: Container(margin: const EdgeInsets.all(15),child: Text('START',style: GoogleFonts.pacifico(fontSize: 28,color: Colors.black),)),
                      ),
                    ),
                    ]),
                  ),
                ),
              ),
            );
      }
    );
  }
}