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
  List<String> frus = [];
  List<String> vegis = [];
  List<String> tols = [];
  List<String> kitchens = [];
  List<Map<String, dynamic>> frutslist = [];
  List<Map<String, dynamic>> vegslist = [];
  List<Map<String, dynamic>> toolslist = [];
  List<Map<String, dynamic>> kitchenslist = [];
  List<String> dropdownitems = ['vegetables', 'fruits', 'tools', 'kitchen'];
  CollectionReference<Map<String, dynamic>> users =
      FirebaseFirestore.instance.collection('users');
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
    if (list == 'vegslist') {
      final result =
          await DatabaseService().getFromFirebaseCategoriesOfMY('vegetables');
      setState(() {
        vegslist = result;
      });
    } else if (list == 'frutslist') {
      final result =
          await DatabaseService().getFromFirebaseCategoriesOfMY('fruits');
      setState(() {
        frutslist = result;
      });
    } else if (list == 'toolslist') {
      final result = await DatabaseService().getFromFirebaseCategoriesOfMY('tools');
      setState(() {
        toolslist = result;
      });
    } else if (list == 'kitchenslist') {
      final result =
          await DatabaseService().getFromFirebaseCategoriesOfMY('kitchen');
      setState(() {
        kitchenslist = result;
      });
    }
  }

  buildProductItems(int index, Map<String, dynamic> taboption) {
    Map<String, dynamic> selection = taboption[taboption.keys.first];
    return GestureDetector(
      onTap: () => setState(() {
        resetDetails(index, selection);
      }),
      child: SizedBox(
        height: 150,
        child: Card(
            color: selection['amount']=='0' ? const Color.fromARGB(255, 50, 56, 50) : const Color.fromARGB(255, 38, 184, 43),
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
                              SizedBox(
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
                                            image: AssetImage(selection['amount']=='0' ? 'assets/images/stabil.png' : selection['incdec'] =='inc'? 'assets/images/inc.png': 'assets/images/dec.png'))),
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
        builder: (context, snapshot) {
           if(!snapshot.hasData){return const Center(child: CircularProgressIndicator(color: Colors.green,strokeWidth: 10,));}
           if (currenttoptab == 'vegetables') {
              categoryGetter('vegslist');
          } else if (currenttoptab == 'fruits'){
              categoryGetter('frutslist');
          }
          else if (currenttoptab == 'tools'){
            categoryGetter('toolslist');
          }
          else if (currenttoptab == 'kitchen'){
            categoryGetter('kitchenslist');
          }
          for (var doc in snapshot.data!.docs) {
            if (FirebaseAuth.instance.currentUser!.uid == doc.id) {
              if (breaker) {
                 if (doc.data()['vegetables'] != null) {
                   for (var i = 0; i < doc.data()['vegetables'].length; i++) {
                     vegis.add(doc.data()['vegetables'][i].keys.first);
                   }
                   breaker = false;
                 }
                 if (doc.data()['fruits'] != null) {
                   for (var i = 0; i < doc.data()['fruits'].length; i++) {
                     frus.add(doc.data()['fruits'][i].keys.first);
                   }
                   breaker = false;
                 }
                 if (doc.data()['tools'] != null) {
                   for (var i = 0; i < doc.data()['tools'].length; i++) {
                     tols.add(doc.data()['tools'][i].keys.first);
                   }
                   breaker = false;
                 }
                 if (doc.data()['kitchen'] != null) {
                   for (var i = 0; i < doc.data()['kitchen'].length; i++) {
                     kitchens.add(doc.data()['kitchen'][i].keys.first);
                   }
                   breaker = false;
                 }
              }
            }
          }
          return SingleChildScrollView(
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
                child: Column(children: [
                      SizedBox(
                          height: height / 2.5,
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
                                          vegis.length
                                          :  currenttoptab == 'fruits' ?
                                          frus.length
                                          :  currenttoptab == 'tools' ?
                                          tols.length
                                          : currenttoptab == 'kitchen' ?
                                          kitchens.length
                                          : vegis.length
                                          )
                                          )
                                          ),
                        const Divider(color: Colors.purple,height: 15,thickness: 10,indent: 10,endIndent: 10),
                        SizedBox(
                          height: height / 2.5,
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
                                          vegis.length 
                                          :  currenttoptab == 'fruits' ?
                                          frus.length
                                          :  currenttoptab == 'tools' ?
                                          tols.length
                                          : currenttoptab == 'kitchen' ?
                                          kitchens.length
                                          : vegis.length
                                          )
                                          )
                                          ),
      
                ]),
              )),
          );
        }
      ),
    );
  }
}