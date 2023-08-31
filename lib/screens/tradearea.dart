import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feature_notifier/feature_notifier.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
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
  String totalmoney = "";
  String? selectedItem = 'Select';
  String? selectedPartnerItem = 'Select';
  String selectemitemprice = '0';
  String selecteditemamount = '0';
  Map<bool,bool> priceandamountenough = <bool,bool>{false:false};
  List<Map<String, dynamic>> frutslist = [];
  List<Map<String, dynamic>> vegslist = [];
  List<Map<String, dynamic>> toolslist = [];
  List<Map<String, dynamic>> kitchenslist = [];
  List<List<Map<String, dynamic>>> allmylist = [];
  List<List<Map<String, dynamic>>> allpartnerlist = [];
  List<String> dropdownitems = ['fruits', 'vegetables', 'tools', 'kitchen'];
  //CollectionReference<Map<String, dynamic>> users =
  //    FirebaseFirestore.instance.collection('users');
  //CollectionReference<Map<String, dynamic>> tradeareaCollection =
  //    FirebaseFirestore.instance.collection('traderooms');
  String currenttoptab = 'fruits';

  @override
  void initState() {
    
    super.initState();
  }
  void resetDetails(int index, Map<String, dynamic> selection) {
    setState(() {
      FeatureNotifier.persistAll();
      productDetails(index, selection);
    });
  }
  Future<int> checktotalMoney()async{
    //print(Supabase.instance.client.from('users').select<PostgrestList>('totalmoney').eq('email', Supabase.instance.client.auth.currentUser!.email).then((value) => value[0]));
      return await Supabase.instance.client.from('users').select<PostgrestList>('totalmoney').eq('email', Supabase.instance.client.auth.currentUser!.email).then((value) => value[0].values.first);
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
          buttonText: 'SELECT',
          buttonTextFontSize: 27,
          descriptionColor: Colors.white,
          descriptionFontSize: 20,
          backgroundColor: Colors.white54, 
          buttonBackgroundColor:selection['amount'] == '0' ? Colors.grey:Colors.green,
          onTapButton: selection['amount'] == '0'? null : ()async{
            await DatabaseService().selectMyItem(selection['name']);
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const TradeArea())); 
        });
    });
  }
    void resetDetailsPartner(int index, Map<String, dynamic> selection) {
    setState(() {
      FeatureNotifier.persistAll();
      productDetailsPartner(index, selection);
    });
  }

  void productDetailsPartner(int index, Map<String, dynamic> selection)async {
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
          buttonText: 'SELECT',
          buttonTextFontSize: 27,
          descriptionColor: Colors.white,
          descriptionFontSize: 20,
          backgroundColor: Colors.white54, 
          buttonBackgroundColor:selection['amount'] == '0' ? Colors.grey:Colors.green,
          onTapButton: selection['amount'] == '0'? null : ()async{
            await DatabaseService().selectPartnersItem(selection['name']);
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const TradeArea())); 
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
                       color: selection['amount']=='0' ? const Color.fromARGB(255, 151, 158, 151) : const Color.fromARGB(255, 98, 202, 101),
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
      items.add(GestureDetector(
                 onTap: () => setState(() {
                   resetDetailsPartner(index, selection);
                 }),
                 child: SizedBox(
        height: 100,
        child: Card(
            color: selection['amount']=='0' ? const Color.fromARGB(255, 151, 158, 151) : const Color.fromARGB(255, 98, 202, 101),
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
      ))
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
  iambuilderFinderFN()async{
    bool temp = false;
    String mynickname = await Supabase.instance.client.auth.currentUser!.userMetadata!['nickname'];
    temp = await Supabase.instance.client.from('rooms').select('tradesman1').is_('tradesman1', mynickname).then((value) => value);
    return temp;
  }
  String? selecteditemFinderFN(AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> tradeareasnapshot){
    String temp = '';
    for (var doc in tradeareasnapshot.data!.docs) {
      if(doc.data()['selectedmyItem'] != null){
          temp = doc.data()['selectedmyItem'];
      }
    }
    return temp;
  }
  String? selecteditemFinderPartnerFN(AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> tradeareasnapshot){
    String temp = '';
    for (var doc in tradeareasnapshot.data!.docs) {
      if(doc.data()['selectedPartnerItem'] != null){
          temp = doc.data()['selectedPartnerItem'];
      }
    }
    return temp;
  }
  void selectedItemPriceFinderFN(String? selectedItem,String selecteditemamount)async{
      await DatabaseService().selectMyItemPrice(selectedItem!,selecteditemamount).then((value) => selectemitemprice = value);
  }
  void checkAmountAndPrice(String totalmoney,String selectedmyitem,String amount,String price){
    setState(()async {
     priceandamountenough = await DatabaseService().checkAmountAndPrice(totalmoney,selectedmyitem,amount,price);
    });
  }
  void moveToSelectedItemAmountToPartner(String selectedmyitem,String selectedmyItemAmount)async{
    await DatabaseService().moveToSelectedItemAmountToPartner(selectedmyitem,selectedmyItemAmount).then((value) {});
  }
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    iambuilder = iambuilderFinderFN();
    checktotalMoney();
    categoryGetter('alllist');
    categoryGetterPartner('alllist');
    allmylistLength = allmylistLengthFN(); 
    allpartnerlistLength = allpartnerlistLengthFN();
    selectedItem = selecteditemFinderFN(tradeareasnapshot) ?? "Select";
    selectedPartnerItem = selecteditemFinderPartnerFN(tradeareasnapshot) ?? "Select";
    selectedItemPriceFinderFN(selectedItem,selecteditemamount);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 40,
        backgroundColor: const Color.fromARGB(134, 255, 191, 0),
            title: Row(
              children: [
                 Expanded(flex: 1,child: Padding(
                    padding: const EdgeInsets.only(left: 0),
                    child: IconButton(
                      icon:  const Icon(
                        Icons.home,
                        color: Colors.white,
                        shadows: [Shadow(color: Colors.grey, blurRadius: 100)],
                        size: 45,
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Home()));
                      },
                    )),),
                Expanded(flex: 5,child: Center(child: Text('Zelix Trade',style: GoogleFonts.pacifico(fontSize: 28,color: Colors.white),))),
                Expanded(flex: 2,child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Container(child: Center(child: Text('$totalmoney \$',style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold,letterSpacing: 2,fontSize: 20),)),)
                    ),),
                //const Expanded(flex: 1,child: Text(''),),
              ],
            ),
      ),
      body: SingleChildScrollView(
                child: Center(
                  child: SizedBox(
                    height: height,
                    width: width,
                    child: Column(children: [
                          iambuilder ?  
                          Column(children: [
                            ///////////////////////////////////////////////////////////////////////////////////////////////////////////// I AM BUILDER OTHER IS JOINER
                            SizedBox(
                              height: height / 3,
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
                            Container(
                              color: const Color.fromARGB(134, 255, 191, 0),
                              padding: const EdgeInsets.all(6),
                              margin: const EdgeInsets.all(2),
                              height: 75,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const SizedBox(width: 0,),
                                  Column(
                                    children: [
                                      const Text('Item',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,letterSpacing: 2,fontSize: 15),),
                                      SizedBox(
                                        height: 40,
                                        child: Center(child: Text(selectedItem ?? 'Select',style: const TextStyle(color: Colors.purple,fontSize: 15),)),
                                      )
                                    ]
                                  ),
                                  Column(
                                    children: [
                                      const SizedBox(
                                        height: 28,
                                        child: Text('Amount',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,letterSpacing: 2,fontSize: 15),)),
                                      Container(
                                        color: Colors.yellow,
                                        height: 25,
                                        width: 100,
                                        child: Center(
                                          heightFactor: 2,
                                          child: TextFormField(
                                            textAlignVertical: TextAlignVertical.bottom,
                                            cursorHeight: 20,
                                            maxLength: 5,
                                            style: const TextStyle(color: Colors.purple),
                                            textAlign: TextAlign.center,
                                            cursorColor: Colors.purple,
                                            decoration: InputDecoration(
                                              hintText: "1",
                                              counterText: "",
                                              focusColor: Colors.green,
                                              border: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                  color: Colors.green
                                                ),
                                                borderRadius: BorderRadius.circular(10.0),
                                              )
                                            ),
                                            onChanged: (v){
                                              setState(() {
                                                selecteditemamount = v;
                                              });
                                            },
                                          ),
                                        ),
                                      )
                                    ]
                                  ),
                                  Column(
                                    children: [
                                      const Text('Price',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,letterSpacing: 2,fontSize: 15),),
                                      SizedBox(
                                        height: 40,
                                        width: 70,
                                        child: Center(child: Text(selectemitemprice,style: const TextStyle(color: Colors.purple,fontSize: 15),)),
                                      )
                                    ]
                                  ),
                                  SizedBox(
                                    height: 100,
                                    width: 100,
                                    child: ElevatedButton(
                                      style: const ButtonStyle(
                                        shadowColor: MaterialStatePropertyAll(Colors.green),
                                        side: MaterialStatePropertyAll(BorderSide(color: Colors.green)),
                                      ),
                                      onPressed:selectedItem == '' || selectedItem == 'Select' ? null : (){
                                        checkAmountAndPrice(totalmoney,selectedItem!,selecteditemamount,selectemitemprice);
                                        moveToSelectedItemAmountToPartner(selectedItem!,selecteditemamount);
                                        if(priceandamountenough == {true:true}){
                                          
                                        }
                                      }, 
                                      child: const Center(child: Text('SELL',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 15),),)),
                                  )
                                ],
                              ),
                            ),
                            ////////////////////////////////////////////////////////////////////////////////////////////////////////
                            const Divider(color: Color.fromARGB(255, 255, 187, 0),height: 11,thickness: 6,indent: 10,endIndent: 10),
                            const Divider(color: Color.fromARGB(255, 255, 187, 0),height: 7,thickness: 6,indent: 10,endIndent: 10),
                            //////////////////////////////////////////////////////////////////////////////////////////////////////// 
                            SizedBox(
                              height: height / 2.82,
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
                            Container(
                              color: const Color.fromARGB(134, 255, 191, 0),
                              padding: const EdgeInsets.all(6),
                              margin: const EdgeInsets.all(2),
                              height: 75,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const SizedBox(width: 0,),
                                  Column(
                                    children: [
                                      const Text('Item',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,letterSpacing: 2,fontSize: 15),),
                                      SizedBox(
                                        height: 20,
                                        child: Text(selectedPartnerItem ?? 'Select',style: const TextStyle(color: Colors.purple,fontSize: 15),),
                                      )
                                    ]
                                  ),
                                  Column(
                                    children: [
                                      const Text('Amount',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,letterSpacing: 2,fontSize: 15),),
                                      SizedBox(
                                        height: 42,
                                        width: 100,
                                        child: Center(
                                          child: TextFormField(
                                            maxLength: 5,
                                            style: const TextStyle(color: Colors.purple),
                                            textAlign: TextAlign.center,
                                            cursorColor: Colors.green,
                                            decoration: InputDecoration(
                                              focusColor: Colors.green,
                                              border: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                  color: Colors.green
                                                ),
                                                borderRadius: BorderRadius.circular(10.0),
                                              )
                                            )
                                          ),
                                        ),
                                      )
                                    ]
                                  ),
                                  const Column(
                                    children: [
                                      Text('Price',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,letterSpacing: 2,fontSize: 15),),
                                      SizedBox(
                                        height: 30,
                                        child: Text('1500\$',style: TextStyle(color: Colors.purple,fontSize: 15),),
                                      )
                                    ]
                                  ),
                                  SizedBox(
                                    height: 50,
                                    width: 100,
                                    child: ElevatedButton(
                                      style: const ButtonStyle(
                                        shadowColor: MaterialStatePropertyAll(Colors.green),
                                        side: MaterialStatePropertyAll(BorderSide(color: Colors.green)),
                                      ),
                                      onPressed: (){}, 
                                      child: const Center(child: Text('BUY',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 15),),)),
                                  )
                                ],
                              ),
                            ), 
                           ])
                           ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////I AM JOINER OTHER IS BUILDER//////////////
                           :
                           Column(children: [
                            SizedBox(
                            height: height / 3.1,
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
                            Container(
                              color: const Color.fromARGB(134, 255, 191, 0),
                              padding: const EdgeInsets.all(8),
                              margin: const EdgeInsets.all(2),
                              height: 68,
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    children: [
                                      Text('Item'),
                                      SizedBox(
                                        height: 20,
                                        child: Text('apple',style: TextStyle(color: Colors.green),),
                                      )
                                    ]
                                  ),
                                  Column(
                                    children: [
                                      Text('Item'),
                                      SizedBox(
                                        height: 30,
                                        child: Text('apple',style: TextStyle(color: Colors.green),),
                                      )
                                    ]
                                  ),
                                  Column(
                                    children: [
                                      Text('Item'),
                                      SizedBox(
                                        height: 30,
                                        child: Text('apple',style: TextStyle(color: Colors.green),),
                                      )
                                    ]
                                  )
                                ],
                              ),
                            ),
                            ////////////////////////////////////////////////////////////////////////////////////////////////////////
                            const Divider(color: Color.fromARGB(255, 255, 187, 0),height: 11,thickness: 6,indent: 10,endIndent: 10),
                            const Divider(color: Color.fromARGB(255, 255, 187, 0),height: 7,thickness: 6,indent: 10,endIndent: 10),
                            //////////////////////////////////////////////////////////////////////////////////////////////////////// 
                            SizedBox(
                              height: height / 3.1,
                              width: width,
                              child: Center(
                                  child: ListView.separated(
                                      itemBuilder: (context, index) =>buildProductItems(index,allmylist[index]),
                                      separatorBuilder: (context, index) =>
                                          Container(height: 1,),
                                      itemCount: allmylistLength
                                              )
                                              )
                            ),
                            Container(
                              color: const Color.fromARGB(134, 255, 191, 0),
                              padding: const EdgeInsets.all(8),
                              margin: const EdgeInsets.all(2),
                              height: 68,
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    children: [
                                      Text('Item'),
                                      SizedBox(
                                        height: 20,
                                        child: Text('apple',style: TextStyle(color: Colors.green),),
                                      )
                                    ]
                                  ),
                                  Column(
                                    children: [
                                      Text('Item'),
                                      SizedBox(
                                        height: 30,
                                        child: Text('apple',style: TextStyle(color: Colors.green),),
                                      )
                                    ]
                                  ),
                                  Column(
                                    children: [
                                      Text('Item'),
                                      SizedBox(
                                        height: 30,
                                        child: Text('apple',style: TextStyle(color: Colors.green),),
                                      )
                                    ]
                                  )
                                ],
                              ),
                            ),
                            ],),
                    ]),
                  )),
              )
            );}
}