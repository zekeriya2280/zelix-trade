import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feature_notifier/feature_notifier.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zelix_trade/screens/home.dart';
import 'package:zelix_trade/services/database.dart';

class TradeArea extends StatefulWidget {
  const TradeArea({super.key});

  @override
  State<TradeArea> createState() => _TradeAreaState();
}

class _TradeAreaState extends State<TradeArea> {
  double height = 0;
  double width = 0;
  bool breaker = true;
  bool iambuilder = false;
  int allmylistLength = 0;
  int allpartnerlistLength = 0;
  List<String> frus = [];
  List<String> vegis = [];
  List<String> tols = [];
  List<String> kitchens = [];
  List<Map<String, dynamic>> frutslist = [];
  List<Map<String, dynamic>> vegslist = [];
  List<Map<String, dynamic>> toolslist = [];
  List<Map<String, dynamic>> kitchenslist = [];
  List<List<Map<String, dynamic>>> allmylist = [];
  List<List<Map<String, dynamic>>> allpartnerlist = [];
  List<String> dropdownitems = ['vegetables', 'fruits', 'tools', 'kitchen'];
  CollectionReference<Map<String, dynamic>> users =
      FirebaseFirestore.instance.collection('users');
  CollectionReference<Map<String, dynamic>> tradeareaCollection =
      FirebaseFirestore.instance.collection('traderooms');
  String currenttoptab = 'vegetables';
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
          buttonBackgroundColor:selection['amount'] == '0' ? Colors.grey:Colors.green,
          onTapButton: selection['amount'] == '0'? null : ()async{
            await DatabaseService().sellItemGivenCatagoryToAllProducts(currenttoptab,selection['name'],selection['name'],selection['price'],selection['incdec'],selection['percent']).then(
              (value) => setState(() { Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const TradeArea())); })
               );
              setState(() { });
        });
    });
  }

  Future<void> categoryGetter(String list) async {
      List<List<Map<String,dynamic>>> result = [];
      result.add(await DatabaseService().getFromFirebaseCategoriesOfMY('vegetables'));
      result.add(await DatabaseService().getFromFirebaseCategoriesOfMY('fruits'));
      result.add(await DatabaseService().getFromFirebaseCategoriesOfMY('tools'));
      result.add(await DatabaseService().getFromFirebaseCategoriesOfMY('kitchen'));
      setState(() {
        allmylist = result;
      });
  }
  Future<void> categoryGetterPartner(String list) async {
      List<List<Map<String,dynamic>>> result = [];
      result.add(await DatabaseService().getFromFirebaseCategoriesOfPartner('vegetables'));
      result.add(await DatabaseService().getFromFirebaseCategoriesOfPartner('fruits'));
      result.add(await DatabaseService().getFromFirebaseCategoriesOfPartner('tools'));
      result.add(await DatabaseService().getFromFirebaseCategoriesOfPartner('kitchen'));
      setState(() {
        allpartnerlist = result;
      });
  }

  buildProductItems(int index, List<Map<String, dynamic>> categorylist) {
    List<Widget> items = [];
    for (var item = 0; item < categorylist.length; item++) {
      Map<String, dynamic> selection = categorylist[item].values.first;
      items.add( GestureDetector(
                 onTap: () => setState(() {
                   resetDetails(index, selection);
                 }),
                 child: SizedBox(
                   height: 100,
                   child: Card(
                       color: selection['amount']=='0' ? const Color.fromARGB(255, 50, 56, 50) : const Color.fromARGB(255, 38, 184, 43),
                       child: ListTile(
                         leading: SizedBox(
                             height: 150,
                             child: Image(
                                 height: 80,
                                 width: 70,
                                 image: AssetImage(
                                     'assets/images/${selection['name']}.png'))),
                         title: SizedBox(
                             height: 100,
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
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold)),
                                    )),
                                    SizedBox(
                                      height: 60,
                                      child: Row(
                                        children: [
                                          SizedBox(
                                             width: width / 2 - 75,
                                             child: ListView(
                                               scrollDirection: Axis.vertical,
                                               children: [
                                                 const SizedBox(
                                                     height: 5, child: Text('')),
                                                 Center(
                                                     child: Text(
                                                         '${selection['price']} \$',
                                                         style: const TextStyle(
                                                             color: Colors.white,
                                                             fontSize: 14,
                                                             fontWeight:
                                                                 FontWeight.bold))),
                                                 const SizedBox(
                                                   height: 5,
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
                                          const Expanded(flex: 2, child: Text('')),
                                          SizedBox(
                                            width: width / 2 - 75,
                                            child: ListView(
                                              scrollDirection: Axis.vertical,
                                              children: [
                                                const SizedBox(
                                                    height: 5, child: Text('')),
                                                Center(
                                                   child: Image(
                                                       height: 30,
                                                       width: 100,
                                                       image: AssetImage(selection['amount']=='0' ? 'assets/images/stabil.png' : selection['incdec'] =='inc'? 'assets/images/inc.png': 'assets/images/dec.png'))),
                                               const SizedBox(
                                                 height: 5,
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
                                         const Expanded(flex: 1, child: Text('')),
                                       ],
                                     ),
                                   ),
                                 ],
                               ),
                             )),
                       )),
                 ),
               )
      );
    }
    return Column(children: items,);
  }
   Widget buildProductItemsPartner(int index, List<Map<String, dynamic>> categorylist) {
    List<Widget> items = [];
    if(categorylist == []){return const Center(child: Text('nothing'));}
    for (var item = 0; item < categorylist.length; item++) {
      Map<String, dynamic> selection = categorylist[item].values.first;
      items.add( SizedBox(
        height: 100,
        child: Card(
            color: selection['amount']=='0' ? const Color.fromARGB(255, 50, 56, 50) : const Color.fromARGB(255, 38, 184, 43),
            child: ListTile(
              leading: SizedBox(
                  height: 150,
                  child: Image(
                      height: 80,
                      width: 70,
                      image: AssetImage(
                          'assets/images/${selection['name']}.png'))),
              title: SizedBox(
                  height: 100,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 2.0),
                    child: Column(
                      children: [
                         Padding(
                            padding: const EdgeInsets.only(right: 58.0),
                            child: Text(
                              selection['name'].toString().toUpperCase(),
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold)),
                         ),
                         SizedBox(
                           height: 60,
                           child: Row(
                             children: [
                               SizedBox(
                                  width: width / 2 - 75,
                                  child: ListView(
                                    scrollDirection: Axis.vertical,
                                    children: [
                                      const SizedBox(
                                          height: 5, child: Text('')),
                                      Center(
                                          child: Text(
                                              '${selection['price']} \$',
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                  fontWeight:
                                                      FontWeight.bold))),
                                      const SizedBox(
                                        height: 5,
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
                               const Expanded(flex: 2, child: Text('')),
                               SizedBox(
                                 width: width / 2 - 75,
                                 child: ListView(
                                   scrollDirection: Axis.vertical,
                                   children: [
                                     const SizedBox(
                                         height: 5, child: Text('')),
                                     Center(
                                        child: Image(
                                            height: 30,
                                            width: 100,
                                            image: AssetImage(selection['amount']=='0' ? 'assets/images/stabil.png' : selection['incdec'] =='inc'? 'assets/images/inc.png': 'assets/images/dec.png'))),
                                    const SizedBox(
                                      height: 5,
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
                              const Expanded(flex: 1, child: Text('')),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )),
            )),
      )
      );
    }
    return Column(children: items,);
  }
  int allmylistLengthFN(){
    int temp = 0;
    for (var list in allmylist) {
      temp += list.length;
    }
    return temp;
  }
  int allpartnerlistLengthFN(){
    int temp = 0;
    for (var list in allpartnerlist) {
      if(list.isEmpty){temp += 1;}
      temp += list.length;
    }
    return temp;
  }
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(134, 255, 191, 0),
            title: Row(
              children: [
                 Expanded(flex: 2,child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: IconButton(
                      icon:  const Icon(
                        Icons.home,
                        color: Colors.white,
                        shadows: [Shadow(color: Colors.grey, blurRadius: 100)],
                        size: 55,
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Home()));
                      },
                    )),),
                Expanded(flex: 3,child: Text('Zelix Trade',style: GoogleFonts.pacifico(fontSize: 28),)),
                const Expanded(flex: 1,child: Text(''),),
              ],
            ),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: users.snapshots(),
        builder: (context, userssnapshot) {
           if(!userssnapshot.hasData){return const Center(child: CircularProgressIndicator(color: Colors.green,strokeWidth: 10,));}

          return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: tradeareaCollection.snapshots(),
            builder: (context, tradeareasnapshot) {
              if(!tradeareasnapshot.hasData){return const Center(child: CircularProgressIndicator(color: Colors.green,strokeWidth: 10,));}

              for (var doc in tradeareasnapshot.data!.docs) {
                for (var udoc in userssnapshot.data!.docs) {
                  if(userssnapshot.data!.docs.any((udoc) => FirebaseAuth.instance.currentUser!.uid == udoc.id)){
                    
                    if(doc.data()['tradesman1'] == udoc.data()['nickname'] || doc.data()['tradesman2'] == udoc.data()['nickname']){
                      if(doc.data()['tradesman1'] == udoc.data()['nickname']){
                        iambuilder = true;
                        break;
                      }
                      else if(doc.data()['tradesman2'] == udoc.data()['nickname']){
                        iambuilder = false;
                        break;
                      }
                    }
                  }
                }
              }
              categoryGetter('alllist');
              categoryGetterPartner('alllist');
              allmylistLength = allmylistLengthFN(); 
              allpartnerlistLength = allpartnerlistLengthFN();
              return SingleChildScrollView(
                child: Center(
                  child: Container(
                    height: height,
                    width: width,
                    child: Column(children: [
                          iambuilder ?  
                          Column(children: [
                            SizedBox(
                              height: height / 2.3,
                              width: width,
                              child: Center(
                                  child: ListView.separated(
                                      itemBuilder: (context, index) => //Column(children: [
                                        buildProductItems(index,allmylist[index]),
                                     // ],),
                                      separatorBuilder: (context, index) =>
                                          Container(height: 1,),
                                      itemCount: allmylistLength
                                              )
                                              )
                            ),
                            const Divider(color: Color.fromARGB(255, 255, 187, 0),height: 11,thickness: 6,indent: 10,endIndent: 10),
                            const Divider(color: Color.fromARGB(255, 255, 187, 0),height: 7,thickness: 6,indent: 10,endIndent: 10),
                            SizedBox(
                              height: height / 2.3,
                              width: width,
                              child: Center(
                                  child: ListView.separated(
                                      itemBuilder: (context, index) => buildProductItemsPartner(index,allpartnerlist[index]),
                                      separatorBuilder: (context, index) =>
                                          Container(height: 1,),
                                      itemCount: allpartnerlistLength
                                              )
                                              )
                            ),  
                           ])
                           :
                           Column(children: [
                              SizedBox(
                              height: height / 2.3,
                              width: width,
                              child: Center(
                                  child: ListView.separated(
                                      itemBuilder: (context, index) => buildProductItemsPartner(index,allpartnerlist[index]),
                                      separatorBuilder: (context, index) =>
                                          Container(height: 1,),
                                      itemCount: allpartnerlistLength
                                              )
                                              )
                            ),
                            const Divider(color: Color.fromARGB(255, 255, 187, 0),height: 11,thickness: 6,indent: 10,endIndent: 10),
                            const Divider(color: Color.fromARGB(255, 255, 187, 0),height: 7,thickness: 6,indent: 10,endIndent: 10),
                            SizedBox(
                              height: height / 2.3,
                              width: width,
                              child: Center(
                                  child: ListView.separated(
                                      itemBuilder: (context, index) =>// Column(children: [
                                        buildProductItems(index,allmylist[index]),
                                     // ],),
                                      separatorBuilder: (context, index) =>
                                          Container(height: 1,),
                                      itemCount: allmylistLength
                                              )
                                              )
                            )
                            ],),
                    ]),
                  )),
              );
            }
          );
        }
      ),
    );
  }
}