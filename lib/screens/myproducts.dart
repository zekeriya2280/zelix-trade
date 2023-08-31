import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feature_notifier/feature_notifier.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:zelix_trade/screens/allproducts.dart';
import 'package:zelix_trade/screens/home.dart';
import 'package:zelix_trade/services/database.dart';

class MyProducts extends StatefulWidget {
  const MyProducts({super.key});

  @override
  State<MyProducts> createState() => _MyProductsState();
}

class _MyProductsState extends State<MyProducts> {
  double height = 0;
  double width = 0;
  bool breaker = true;
  int proditemcount = 0;
  int totalmoney = 0;
  List<String> prodnames = [];
  String currenttoptab = 'fruits';
  List<Map<String, dynamic>> frutslist = [];
  List<Map<String, dynamic>> vegslist = [];
  List<Map<String, dynamic>> toolslist = [];
  List<Map<String, dynamic>> kitchenslist = [];
  List<String> dropdownitems = ['fruits'];
  CollectionReference<Map<String, dynamic>> users =
      FirebaseFirestore.instance.collection('users');
  @override
  void initState() {
    getallLists();
    super.initState();
  }
  getallLists(){
    Supabase.instance.client.from('boughtProducts').stream(primaryKey: ['id']).eq('owner',Supabase.instance.client.auth.currentUser!.email).listen((event) async {
      event.sort((a,b)=>a['id'].compareTo(b['id'])); 
        
        for (var map in event) { 
          //print(map);
          for (var i = 0; i < map.values.length; i++) {
            if(List<dynamic>.from(map.values)[i] == 'fruits'){
              setState(() {
                frutslist.add({'name' : List<dynamic>.from(map.values)[3], 
                               'price' : List<dynamic>.from(map.values)[4], 
                               'amount' : List<dynamic>.from(map.values)[5], 
                               'incdec' : List<dynamic>.from(map.values)[6], 
                               'percent' : List<dynamic>.from(map.values)[7]});
              });
            }else if(List<dynamic>.from(map.values)[i] == 'vegetables'){
              setState(() {
                vegslist.add({'name' : List<dynamic>.from(map.values)[3], 
                              'price' : List<dynamic>.from(map.values)[4], 
                              'amount' : List<dynamic>.from(map.values)[5], 
                              'incdec' : List<dynamic>.from(map.values)[6], 
                              'percent' : List<dynamic>.from(map.values)[7]});
              });
            }else if(List<dynamic>.from(map.values)[i] == 'tools'){
              setState(() {
                toolslist.add({'name' : List<dynamic>.from(map.values)[3], 
                               'price' : List<dynamic>.from(map.values)[4], 
                               'amount' : List<dynamic>.from(map.values)[5], 
                               'incdec' : List<dynamic>.from(map.values)[6], 
                               'percent' : List<dynamic>.from(map.values)[7]});
              });
            }else if(List<dynamic>.from(map.values)[i] == 'kitchen'){
              setState(() {
                kitchenslist.add({'name' : List<dynamic>.from(map.values)[3], 
                                  'price' : List<dynamic>.from(map.values)[4], 
                                  'amount' : List<dynamic>.from(map.values)[5], 
                                  'incdec' : List<dynamic>.from(map.values)[6], 
                                  'percent' : List<dynamic>.from(map.values)[7]});
              });
            }
            List<Map<String,dynamic>> categories = await Supabase.instance.client.from('allproducts').select<List>('category').then((value) => List<Map<String,dynamic>>.from(value));
            for (var i = 0; i < categories.length; i++) {
              dropdownitems.add(Map<String,dynamic>.from(categories[i]).values.first);
            }
            dropdownitems = dropdownitems.toSet().toList();
          }
        }
     });
  }
  Future<int> getTotalMoney()async{
    //print(Supabase.instance.client.from('users').select<PostgrestList>('totalmoney').eq('email', Supabase.instance.client.auth.currentUser!.email).then((value) => value[0]));
      return await Supabase.instance.client.from('users').select<PostgrestList>('totalmoney').eq('email', Supabase.instance.client.auth.currentUser!.email).then((value) => value[0].values.first);
  }
  void resetDetails(int index, Map<String, dynamic> selection) {
    setState(() {
      FeatureNotifier.persistAll();
      productDetails(index, selection);
    });
  }

  void productDetails(int index, Map<String, dynamic> selection)async {
    WidgetsBinding.instance.addPostFrameCallback((_)  {
      FeatureAlertNotifier.notify(context,
          image: Container(
              margin: const EdgeInsets.only(top: 0),
              child: Center(
                child: Image(
                  height: 120,
                    image: AssetImage('assets/images/${selection['name']}.png')),
              )),
          titleFontSize: 28,
          title: "      ${selection['name'].toString().toUpperCase()}",
          titleColor: Colors.white,
          description:
             "       Price: ¥ ${selection['price']}   "
           "\n       Amount: ${selection['amount']}  "
           "\n       State: ${selection['incdec'] == 'inc' ? 'Increasing' : 'Decreasing'} "
           "\n       Percentage: ${selection['percent']}% ",
          onClose: () {},
          featureKey: 3,
          hasButton: true,
          buttonText: 'SELL',
          buttonTextFontSize: 27,
          descriptionColor: Colors.white,
          descriptionFontSize: 20,
          backgroundColor: Colors.white54, 
          buttonBackgroundColor:selection['amount'] == 0 || totalmoney <selection['price'] ? Colors.grey:Colors.green,
          onTapButton: selection['amount'] == 0 || totalmoney < selection['price'] ? null : ()async{
                int newprice = selection['price'] + (double.parse((selection['price'] * selection['percent']).toString())/100).floor();
                List<Map<String,dynamic>> allproselectedamount =  await Supabase.instance.client.from('allproducts').select<List<Map<String,dynamic>>>('amount').eq('name', selection['name']).then((value) => value);
                int newamountforAllProducts = int.parse(allproselectedamount[0].values.first.toString()) + 1;
                int newamountforme = 1;
                List<Map<String,dynamic>> lastamountforme = await Supabase.instance.client.from('boughtProducts').select<List<Map<String,dynamic>>>('amount').eq('name', selection['name']).then((value) => value);
                if(lastamountforme == [] || lastamountforme.isEmpty){
                  newamountforme = 1;
                }
                else{
                  newamountforme  = int.parse(lastamountforme[0].values.first.toString()) - 1;
                }
                double newpercent = selection['percent'] - 0.5;
                String newincdec = 'dec';
                List<Map<String,dynamic>> itemnames = await Supabase.instance.client.from('boughtProducts').select<List<Map<String,dynamic>>>('name').then((value) => value);
                if(itemnames.any((itemmap) => itemmap.values.first == selection['name'])){
                  await Supabase.instance.client.from('boughtProducts').update({'category': currenttoptab,
                                                                                'name':selection['name'],
                                                                                'price': newprice,
                                                                                'amount':newamountforme,
                                                                                'incdec':newincdec,
                                                                                'percent':newpercent})
                                                                                .eq('name', selection['name'])
                                                                                .eq('owner', Supabase.instance.client.auth.currentUser!.email);
                }
                await Supabase.instance.client.from('allproducts').update({'price': newprice}).eq('name', selection['name']);
                await Supabase.instance.client.from('allproducts').update({'percent': newpercent}).eq('name', selection['name']);
                await Supabase.instance.client.from('allproducts').update({'amount': newamountforAllProducts}).eq('name', selection['name']);
                await Supabase.instance.client.from('allproducts').update({'incdec': newincdec}).eq('name', selection['name']);

            /**/await Supabase.instance.client.from('users').update({'totalmoney': (totalmoney + selection['price'])}).eq('email', Supabase.instance.client.auth.currentUser!.email).then(
                (value) => setState(() { Navigator.push(context, MaterialPageRoute(builder: (context) => const MyProducts())); })
                 );
        });
    });
  }
  buildProductItems(int index, Map<String, dynamic> selection){
    return GestureDetector(
      onTap: () => setState(() {
        resetDetails(index, selection);
      }),
      child: SizedBox(
        height: 150,
        child: Card(
            color: selection['amount']==0 ?const Color.fromARGB(255, 151, 158, 151) : const Color.fromARGB(255, 98, 202, 101),
            child: ListTile(
              leading: SizedBox(
                  height: 150,
                  child: Image(
                      height: 100,
                      width: 70,
                      image: AssetImage(
                          'assets/images/${selection['name']}.png'))),
              title: SizedBox(
                  height: 130,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 2.0),
                    child: Column(
                      children: [
                        Container(
                            child: Padding(
                          padding: const EdgeInsets.only(right: 58.0),
                          child: Text(
                              selection['name'].toString().toUpperCase(),
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold)),
                        )),
                        SizedBox(
                          height: 100,
                          child: Row(
                            children: [
                              Container(
                                child: SizedBox(
                                  width: width / 2 - 75,
                                  child: ListView(
                                    scrollDirection: Axis.vertical,
                                    children: [
                                      const SizedBox(
                                          height: 30, child: Text('')),
                                      Center(
                                          child: Text(
                                              '${selection['price']} \$',
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                  fontWeight:
                                                      FontWeight.bold))),
                                      const SizedBox(
                                        height: 30,
                                      ),
                                      Center(
                                          child: Text('${selection['amount']}',
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold)))
                                    ],
                                  ),
                                ),
                              ),
                              const Expanded(flex: 2, child: Text('')),
                              Container(
                                child: SizedBox(
                                  width: width / 2 - 75,
                                  child: ListView(
                                    scrollDirection: Axis.vertical,
                                    children: [
                                      const SizedBox(
                                          height: 30, child: Text('')),
                                      Center(
                                          child: Image(
                                              height: 30,
                                              width: 100,
                                              image: AssetImage(selection['amount']==0 ? 'assets/images/stabil.png' : selection['incdec'] =='inc'? 'assets/images/inc.png': 'assets/images/dec.png'))),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Center(
                                          child: Text(
                                              '${selection['percent']}%',
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold)))
                                    ],
                                  ),
                                ),
                              ),
                              const Expanded(flex: 1, child: Text('')),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )),
            )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    dropdownitems = dropdownitems.toSet().toList();
    getTotalMoney().then((value) => 
      totalmoney = value
    );
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: users.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
                child: CircularProgressIndicator(
              color: Colors.green,
              strokeWidth: 10,
            ));
          }
          //if (currenttoptab == 'vegetables') {
          //    categoryGetter('vegslist');
          //} else if (currenttoptab == 'fruits'){
          //    categoryGetter('frutslist');
          //}
          //else if (currenttoptab == 'tools'){
          //  categoryGetter('toolslist');
          //}
          //else if (currenttoptab == 'kitchen'){
          //  categoryGetter('kitchenslist');
          //}
          //for (var doc in snapshot.data!.docs) {
          //  if (FirebaseAuth.instance.currentUser!.uid == doc.id) {
          //    if (breaker) {
          //       if (doc.data()['vegetables'] != null) {
          //         for (var i = 0; i < doc.data()['vegetables'].length; i++) {
          //           vegis.add(doc.data()['vegetables'][i].keys.first);
          //         }
          //         breaker = false;
          //       }
          //       if (doc.data()['fruits'] != null) {
          //         for (var i = 0; i < doc.data()['fruits'].length; i++) {
          //           frus.add(doc.data()['fruits'][i].keys.first);
          //         }
          //         breaker = false;
          //       }
          //       if (doc.data()['tools'] != null) {
          //         for (var i = 0; i < doc.data()['tools'].length; i++) {
          //           tols.add(doc.data()['tools'][i].keys.first);
          //         }
          //         breaker = false;
          //       }
          //       if (doc.data()['kitchen'] != null) {
          //         for (var i = 0; i < doc.data()['kitchen'].length; i++) {
          //           kitchens.add(doc.data()['kitchen'][i].keys.first);
          //         }
          //         breaker = false;
          //       }
          //    }
          //  }
          //}
          //for (var element in snapshot.data!.docs) {
          //    if(element.id == FirebaseAuth.instance.currentUser!.uid){
          //      textprice = element.data()['totalmoney'].toString();
          //    }
          //}
          return Scaffold(
            appBar: AppBar(
              actions: [
                Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: IconButton(
                      icon: const Icon(
                        Icons.home,
                        color: Colors.white,
                        size: 25,
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Home()));
                      },
                    )),
                Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: IconButton(
                      icon: const Icon(
                        Icons.list,
                        color: Colors.white,
                        size: 25,
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AllProducts()));
                      },
                    )),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Center(
                    child: GestureDetector(
                        onTap: () async {},
                        child: const Icon(
                          Icons.logout,
                          color: Colors.red,
                        )),
                  ),
                ),
              ],
              backgroundColor:
                  Theme.of(context).colorScheme.primary.withAlpha(700),
              title: const Center(
                  child: Text(
                'Zelix Trade',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              )),
            ),
            body: SingleChildScrollView(
                child: Container(
              height: height,
              decoration: BoxDecoration(
                color: Colors.yellow[200],
              ),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                          height: 50,
                          width: width / 2,
                          child: DropdownMenu<String>(
                              width: width / 2,
                              inputDecorationTheme: InputDecorationTheme(
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: const EdgeInsets.only(left: 25),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(50))),
                              textStyle: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  letterSpacing: 2),
                              menuStyle: const MenuStyle(
                                surfaceTintColor:
                                    MaterialStatePropertyAll(Colors.amber),
                                shape: MaterialStatePropertyAll(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.all(Radius.circular(10)))),
                                side: MaterialStatePropertyAll(BorderSide(
                                    color: Color.fromARGB(255, 121, 99, 99))),
                                backgroundColor: MaterialStatePropertyAll(
                                    Color.fromARGB(255, 255, 255, 255)),
                              ),
                              onSelected: (v) {
                                setState(() {
                                  currenttoptab = v!;
                                });
                              },
                              initialSelection:  dropdownitems[0],
                              dropdownMenuEntries: dropdownitems
                                  .map((e) => DropdownMenuEntry<String>(
                                        value: e,
                                        label: e,
                                      ))
                                  .toList())),
                            SizedBox(
                        //width: 110,
                        height: 50,
                        child: Center(child: Container(
                          height: 50,
                          width: width/3,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            
                            borderRadius: BorderRadius.circular(50)
                          ),
                          child: Center(
                            child: Text(
                              "$totalmoney \$",style: TextStyle(color: totalmoney <= 0 ? Colors.red : Colors.green,fontSize:20,fontWeight: FontWeight.bold,letterSpacing: 2),
                            ),
                          ),
                        ),)
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                      height: height / 1.2,
                      width: width,
                      child: Center(
                          child: ListView.separated(
                              itemBuilder: (context, index) =>
                                  currenttoptab == 'vegetables' ? 
                                vegslist.isEmpty ? const CircularProgressIndicator(color: Colors.green,strokeWidth: 10,) :
                                buildProductItems(index,vegslist[index]) 
                                : currenttoptab == 'fruits' ? 
                                frutslist.isEmpty ? const CircularProgressIndicator(color: Colors.green,strokeWidth: 10,) :
                                buildProductItems(index,frutslist[index])
                                : currenttoptab == 'tools' ? 
                                toolslist.isEmpty ? const CircularProgressIndicator(color: Colors.green,strokeWidth: 10,) :
                                buildProductItems(index, toolslist[index])
                                : currenttoptab == 'kitchen' ?
                                kitchenslist.isEmpty ? const CircularProgressIndicator(color: Colors.green,strokeWidth: 10,) :
                                buildProductItems(index, kitchenslist[index])
                                :
                                vegslist.isEmpty ? const CircularProgressIndicator(color: Colors.green,strokeWidth: 10,) :
                                buildProductItems(index,vegslist[index]) 
                                , 
                              separatorBuilder: (context, index) =>
                                  const Divider(),
                              itemCount: currenttoptab == 'vegetables' ? 
                                      vegslist.length 
                                      :  currenttoptab == 'fruits' ?
                                      frutslist.length
                                      :  currenttoptab == 'tools' ?
                                      toolslist.length
                                      : currenttoptab == 'kitchen' ?
                                      kitchenslist.length
                                      : vegslist.length
                                      )
                                      )
                                      ),
                ],
              ),
            )),
          );
        });
  }
  

}
