import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zelix_trade/authenticate/wrapper.dart';
import 'package:zelix_trade/screens/allproducts.dart';
import 'package:zelix_trade/screens/myproducts.dart';
import 'package:zelix_trade/screens/createTrade.dart';
import 'package:zelix_trade/screens/joinTrade.dart';
import 'package:zelix_trade/screens/options.dart';
import 'package:zelix_trade/services/authservice.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  double height = 0;
  double width = 0;
  final AuthService auth = AuthService(); 
  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    
    return Scaffold(
        appBar: AppBar(
          actions: [
            Padding(padding: const EdgeInsets.symmetric(vertical:5),
            child: IconButton(
              icon: const Icon(Icons.list,color: Colors.white,size: 25,),
              onPressed: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AllProducts()));
              }
            )),
            Padding(padding: const EdgeInsets.symmetric(vertical:5),
            child: IconButton(
              icon: const Icon(Icons.remove_red_eye,color: Colors.white,size: 25,),
              onPressed: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MyProducts()));
              }
            )),
            Padding(padding: const EdgeInsets.all(10),
              child: Center(child: 
                           GestureDetector(
                               onTap: ()async{ await auth.signOut();
                               if(FirebaseAuth.instance.currentUser == null){
                                 await Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const Wrapper()));
                               }
                               },
                               child: const Icon(Icons.logout,color: Colors.red,)),),),
          ],
          backgroundColor: Theme.of(context).colorScheme.primary.withAlpha(700),
          title: const Center(
              child: Padding(
                padding: EdgeInsets.only(left:58.0),
                child: Text(
                          'Zelix Trade',
                          style: TextStyle(
                  color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
                        ),
              )),
        ),
        body:Stack(
      children: [
         const Image(image: AssetImage('assets/images/tradebg.png'),fit: BoxFit.cover,),
         Center(
          
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Expanded(flex: 2, child: Text('')),
              Container(
                height: 100,
                width: width/1.3,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.orangeAccent
                  ),
                  child: ElevatedButton(
                    style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Color.fromARGB(65, 46, 25, 25))
                    ),
                    onPressed: (){
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const CreateTrade()));
                    }, 
                    child: const Text('Create Trade', style: TextStyle(fontSize: 30,color: Colors.white)))),
              const SizedBox(height: 30,),
              Container(
                height: 100,
                width: width/1.3,
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.orangeAccent
                  ),
                  child: ElevatedButton(
                    style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Color.fromARGB(65, 46, 25, 25))
                    ),
                    onPressed: (){Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const JoinTrade()));}, 
                    child: const Text('Join A Trade', style: TextStyle(fontSize: 30,color: Colors.white)))),
              const SizedBox(height: 30,),
              Container(
                height: 100,
                width: width/1.3,
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.orangeAccent
                  ),
                  child: ElevatedButton(
                    style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Color.fromARGB(65, 46, 25, 25))
                    ),
                    onPressed: (){
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Options()));
                  }, 
                  child: const Text('Options', style: TextStyle(fontSize: 30,color:Colors.white)))),
              const SizedBox(height: 30,),
              Container(
                height: 100,
                width: width/1.3,
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.orangeAccent
                  ),
                  child: ElevatedButton(
                    style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Color.fromARGB(65, 46, 25, 25))
                    ),
                    onPressed: (){
                      SystemNavigator.pop();
                  },
                    child: const Text('Quit', style: TextStyle(fontSize: 30,color:Colors.white)))),
              const Expanded(flex: 4, child: Text('')),
            ],
          ),
        ),
      ]
      ),
    );
  }
}
