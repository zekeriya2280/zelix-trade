
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:zelix_trade/authenticate/wrapper.dart';
import 'package:zelix_trade/screens/allproducts.dart';
import 'package:zelix_trade/screens/myproducts.dart';
import 'package:zelix_trade/screens/createTrade.dart';
import 'package:zelix_trade/screens/joinTrade.dart';
import 'package:zelix_trade/screens/options.dart';
import 'package:zelix_trade/services/authservice.dart';
import 'package:zelix_trade/services/database.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  double height = 0;
  double width = 0;
  List<String> allproductscategories = [];
  List<Map<String,dynamic>> fruits = [];
  List<Map<String,dynamic>> vegetables = [];
  List<Map<String,dynamic>> tools = [];
  List<Map<String,dynamic>> kitchen = [];
  final AuthService auth = AuthService(); 
  @override
  void initState() {
    //deleteMyTradeArea();
    supabase();
    super.initState();
  }
  //void deleteMyTradeArea()async {
  //  await DatabaseService().clearLastRoomIfIJoiner();  
  //} 
  void supabase()async{
    //await Supabase.instance.client.from('allproducts').delete().gt('id', 0);
    //print(Supabase.instance.client.from('allproducts').insert({'products':{'fruits':'apple'}}).then((value) => value));
    //await Supabase.instance.client.from('boughtProducts').update({'price':'1500'}).eq('id', 3);
   // await Supabase.instance.client.from('allproducts').insert({'id':1,'category': 'fruits','name':'apple','price':'1000','amount':'40','incdec':'dec','percent':'0.0'});
   // await Supabase.instance.client.from('allproducts').insert({'id':2,'category': 'fruits','name':'pear','price':'1500','amount':'30','incdec':'inc','percent':'0.0'} );
   // await Supabase.instance.client.from('allproducts').insert({'id':3,'category': 'vegetables','name':'tomatoes','price':'1000','amount':'40','incdec':'dec','percent':'0.0' }); 
   // await Supabase.instance.client.from('allproducts').insert({'id':4,'category': 'vegetables','name':'pepper','price':'1500','amount':'30','incdec':'inc','percent':'0.0'} ); 
   // await Supabase.instance.client.from('allproducts').insert({'id':5,'category': 'tools','name':'pliers','price':'1500','amount':'30','incdec':'inc','percent':'0.0'});
   // await Supabase.instance.client.from('allproducts').insert({'id':6,'category': 'tools','name':'hammer','price':'1000','amount':'40','incdec':'dec','percent':'0.0'} ); 
   // await Supabase.instance.client.from('allproducts').insert({'id':7,'category': 'kitchen','name':'plastic','price':'1500','amount':'30','incdec':'inc','percent':'0.0' }); 
   // await Supabase.instance.client.from('allproducts').insert({'id':8,'category': 'kitchen','name':'glass','price':'1500','amount':'30','incdec':'inc','percent':'0.0' }); 
   // await Supabase.instance.client.from('allproducts').insert({'id':9,'category': 'kitchen','name':'spoon','price':'1500','amount':'30','incdec':'inc','percent':'0.0'});
  }
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
                               onTap: ()async{ 
                                //await auth.signOut();
                               await Supabase.instance.client.auth.signOut();
                               if(Supabase.instance.client.auth.currentUser == null){
                                 Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const Wrapper()));
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
        body:SingleChildScrollView(
          child: SizedBox(
            height: height,
            child: Stack(
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
                        onPressed: ()async{
                          String traderoomid = '';
                          traderoomid = await DatabaseService().createTrade();
                          //print(traderoomid);
                          traderoomid == null ? 
                          const CircularProgressIndicator(strokeWidth: 10,color: Colors.green,) 
                          : 
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>  CreateTrade(traderoomid:traderoomid)));
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
          ),
        ),
    );
  }
}
