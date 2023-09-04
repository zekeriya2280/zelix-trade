
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:zelix_trade/screens/home.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({ Key? key }) : super(key: key);

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
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
                            List<Map<String, dynamic>> allids= await Supabase.instance.client.from('users').select<PostgrestList>('id').then((value) => value);
                            List<int> temp = [];
                            for (var i = 0; i < allids.length; i++) {
                              for (var intelmnt in List<int>.from(allids[i].values)) {
                                temp.add(int.parse(intelmnt.toString()));
                              }
                            }
                            temp.sort();
                            int lastid = temp.last;
                            Supabase.instance.client.auth.currentUser!.userMetadata!.addAll({'nickname':nickname,'totalmoney': 5000});
                            await Supabase.instance.client.auth.updateUser(UserAttributes(data: Supabase.instance.client.auth.currentUser!.userMetadata!));
                            await Supabase.instance.client.from('users').insert({'id':lastid + 1,'name':nickname,'email': Supabase.instance.client.auth.currentUser!.email,'password': Supabase.instance.client.auth.currentUser!.userMetadata!['password'], 'totalmoney': 5000});
                            
                            await Future.delayed(const Duration(milliseconds: 500),(){
                              const Center(child: CircularProgressIndicator(color: Colors.green,strokeWidth: 10,));
                            });
                            await Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => const Home()), );
                           //List<Map<String, dynamic>> lastid = await Supabase.instance.client.from('users').select<PostgrestList>('id');
                           //print(lastid);
                           //if(lastid == null || lastid == []){
                           //  await Supabase.instance.client.from('users').insert({'id':0});
                           //}
                           //else{
                           //  lastid.sort();
                           //  await Supabase.instance.client.from('users').insert({'id':1,'name':lastid[0]['name'],'email': lastid[0]['email'],'password': lastid[0]['password']});
                           //}
                            
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
}