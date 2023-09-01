import 'dart:convert';

import 'package:feature_notifier/feature_notifier.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:zelix_trade/screens/home.dart';

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
  int totalmoney = 0;
  String? selectedItem = 'Select';
  String? selectedPartnerItem = 'Select';
  int selecteditemprice = 0;
  int selecteditemamount = 0;
  int selectedpartneritemprice = 0;
  int selectedpartneritemamount = 0;
  bool myenteredamountnotanumber = false;
  String notenoughtamounterror = '';
  Map<bool,bool> priceandamountenough = <bool,bool>{false:false};
  List<Map<String, dynamic>> frutslist = [];
  List<Map<String, dynamic>> vegslist = [];
  List<Map<String, dynamic>> toolslist = [];
  List<Map<String, dynamic>> kitchenslist = [];
  List<Map<String, dynamic>> allmylist = [];
  List<Map<String, dynamic>> allpartnerlist = [];
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
  checktotalMoney()async{
      return totalmoney = await Supabase.instance.client.from('users').select<PostgrestList>('totalmoney').eq('email', Supabase.instance.client.auth.currentUser!.email).then((value) => int.parse(value[0].values.first.toString()));
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
          buttonBackgroundColor:selection['amount'] == 0 ? Colors.grey:Colors.green,
          onTapButton: selection['amount'] == 0 ? null : ()async{
            await Supabase.instance.client.from('rooms').update({'myselecteditem':selection['name'],'myselecteditemamount' : 1,'myselecteditemprice' : selection['price']}).or('tradesman1.eq.${Supabase.instance.client.auth.currentUser!.userMetadata!['nickname']},tradesman2.eq.${Supabase.instance.client.auth.currentUser!.userMetadata!['nickname']}');
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
          buttonBackgroundColor:selection['amount'] == 0 ? Colors.grey:Colors.green,
          onTapButton: selection['amount'] == 0 ? null : ()async{
            await Supabase.instance.client.from('rooms').update({'partnerselecteditem':selection['name'],'partnerselecteditemamount' : 1,'partnerselecteditemprice' : selection['price']}).or('tradesman1.eq.${Supabase.instance.client.auth.currentUser!.userMetadata!['nickname']},tradesman2.eq.${Supabase.instance.client.auth.currentUser!.userMetadata!['nickname']}');
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const TradeArea())); 
        });
    });
  }

  Future<void> categoryGetter() async {
    List<Map<String,dynamic>> allcategorylist = [];
    List<Map<String,dynamic>> myitemnames = await Supabase.instance.client.from('boughtProducts').select<PostgrestList>('name').eq('owner',Supabase.instance.client.auth.currentUser!.email).then((value) => value);
    List<Map<String,dynamic>> myitemprices = await Supabase.instance.client.from('boughtProducts').select<PostgrestList>('price').eq('owner',Supabase.instance.client.auth.currentUser!.email).then((value) => value);
    List<Map<String,dynamic>> myitemamounts = await Supabase.instance.client.from('boughtProducts').select<PostgrestList>('amount').eq('owner',Supabase.instance.client.auth.currentUser!.email).then((value) => value);
    List<Map<String,dynamic>> myitemincdec = await Supabase.instance.client.from('boughtProducts').select<PostgrestList>('incdec').eq('owner',Supabase.instance.client.auth.currentUser!.email).then((value) => value);
    List<Map<String,dynamic>> myitempercents = await Supabase.instance.client.from('boughtProducts').select<PostgrestList>('percent').eq('owner',Supabase.instance.client.auth.currentUser!.email).then((value) => value);
    for (var i = 0; i < myitemnames.length; i++) {
      allcategorylist.add({'name':myitemnames[i].values.first,'price':myitemprices[i].values.first,'amount':myitemamounts[i].values.first,'incdec':myitemincdec[i].values.first,'percent':myitempercents[i].values.first});
    }
    setState(() {
      allmylist = allcategorylist;
    });
    
  }
  Future<void> categoryGetterPartner(bool iambuilder) async {
    List<Map<String,dynamic>> allcategorylist = [];
    List<Map<String, dynamic>> partnernicknamemap = await Supabase.instance.client.from('rooms')
                                                                               .select<PostgrestList>(iambuilder ? 'tradesman2' : 'tradesman1')
                                                                               .eq(iambuilder ? 'tradesman1' : 'tradesman2',Supabase.instance.client.auth.currentUser!.userMetadata!['nickname'])
                                                                               .then((value) => value);
    List<Map<String, dynamic>> partneremailmap = await Supabase.instance.client.from('users').select<PostgrestList>('email').eq('name',partnernicknamemap[0].values.first).then((value) => value);
    
    List<Map<String,dynamic>> partneritemnames = await Supabase.instance.client.from('boughtProducts').select<PostgrestList>('name').eq('owner',partneremailmap[0].values.first).then((value) => value);
    List<Map<String,dynamic>> partneritemprices = await Supabase.instance.client.from('boughtProducts').select<PostgrestList>('price').eq('owner',partneremailmap[0].values.first).then((value) => value);
    List<Map<String,dynamic>> partneritemamounts = await Supabase.instance.client.from('boughtProducts').select<PostgrestList>('amount').eq('owner',partneremailmap[0].values.first).then((value) => value);
    List<Map<String,dynamic>> partneritemincdec = await Supabase.instance.client.from('boughtProducts').select<PostgrestList>('incdec').eq('owner',partneremailmap[0].values.first).then((value) => value);
    List<Map<String,dynamic>> partneritempercents = await Supabase.instance.client.from('boughtProducts').select<PostgrestList>('percent').eq('owner',partneremailmap[0].values.first).then((value) => value);
    for (var i = 0; i < partneritemnames.length; i++) {
      allcategorylist.add({'name':partneritemnames[i].values.first,'price':partneritemprices[i].values.first,'amount':partneritemamounts[i].values.first,'incdec':partneritemincdec[i].values.first,'percent':partneritempercents[i].values.first});
    }
    setState(() {
      allpartnerlist = allcategorylist;
    });
    
  }

  buildProductItems(int index, Map<String, dynamic> selection) {
        return GestureDetector(
                 onTap: selection['amount']==0 ? null : () => setState(() {
                   resetDetails(index, selection);
                 }),
                 child: SizedBox(
                   height: 100,
                   child: Card(
                       color: selection['amount']==0 ? const Color.fromARGB(255, 151, 158, 151) : const Color.fromARGB(255, 98, 202, 101),
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
                                                       image: AssetImage(selection['amount']==0 ? 'assets/images/stabil.png' : selection['incdec'] =='inc'? 'assets/images/inc.png': 'assets/images/dec.png'))),
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
               );
    }
   Widget buildProductItemsPartner(int index, Map<String, dynamic> selection) {
        return GestureDetector(
                 onTap: selection['amount']==0 ? null : () => setState(() {
                   resetDetailsPartner(index, selection);
                 }),
                 child: SizedBox(
        height: 100,
        child: Card(
            color: selection['amount']==0 ? const Color.fromARGB(255, 151, 158, 151) : const Color.fromARGB(255, 98, 202, 101),
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
                                            image: AssetImage(selection['amount']==0 ? 'assets/images/stabil.png' : selection['incdec'] =='inc'? 'assets/images/inc.png': 'assets/images/dec.png'))),
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
  int allmylistLengthFN(){
    return allmylist.length;
  }
  int allpartnerlistLengthFN(){
    return allpartnerlist.length;
  }
  iambuilderFinderFN()async{
    String mynickname = await Supabase.instance.client.auth.currentUser!.userMetadata!['nickname'];
    List<Map<String, dynamic>> temp = await Supabase.instance.client.from('rooms').select<PostgrestList>('tradesman1').then((value) => value);
    return iambuilder = temp.any((map) => map.values.first == mynickname);
  }
  selecteditemNameAndPriceFinderFN()async{
    List<Map<String, dynamic>> myselecteditemmap = await Supabase.instance.client.from('rooms').select<PostgrestList>('myselecteditem').eq(iambuilder ? 'tradesman1' : 'tradesman2' , Supabase.instance.client.auth.currentUser!.userMetadata!['nickname']).then((value) => value);
    selectedItem = myselecteditemmap[0].values.first ?? "Select";
    List<Map<String, dynamic>> myselecteditempricemap = await Supabase.instance.client.from('rooms').select<PostgrestList>('myselecteditemprice').eq(iambuilder ? 'tradesman1' : 'tradesman2' , Supabase.instance.client.auth.currentUser!.userMetadata!['nickname']).then((value) => value);
    selecteditemprice = myselecteditempricemap[0].values.first ?? 0;
  }
  selecteditemNameAndPriceFinderPartnerFN()async{
    List<Map<String, dynamic>> partnerselectedmap = await Supabase.instance.client.from('rooms').select<PostgrestList>('partnerselecteditem').eq(iambuilder ? 'tradesman1' : 'tradesman2' , Supabase.instance.client.auth.currentUser!.userMetadata!['nickname']).then((value) => value);
    selectedPartnerItem = partnerselectedmap[0].values.first ?? "Select";
    List<Map<String, dynamic>> partnerselecteditempricemap = await Supabase.instance.client.from('rooms').select<PostgrestList>('partnerselecteditemprice').eq(iambuilder ? 'tradesman1' : 'tradesman2' , Supabase.instance.client.auth.currentUser!.userMetadata!['nickname']).then((value) => value);
    selectedpartneritemprice = partnerselecteditempricemap[0].values.first ?? 0;
  }
  //void selectedItemPriceFinderFN(String? selectedItem,String selecteditemamount)async{
  //    await DatabaseService().selectMyItemPrice(selectedItem!,selecteditemamount).then((value) => selectemitemprice = value);
  //}
  //void checkAmountAndPrice(String totalmoney,String selectedmyitem,String amount,String price){
  //  setState(()async {
  //   priceandamountenough = await DatabaseService().checkAmountAndPrice(totalmoney,selectedmyitem,amount,price);
  //  });
  //}
  //void moveToSelectedItemAmountToPartner(String selectedmyitem,String selectedmyItemAmount)async{
  //  await DatabaseService().moveToSelectedItemAmountToPartner(selectedmyitem,selectedmyItemAmount).then((value) {});
  //}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    iambuilderFinderFN();
    checktotalMoney();
    categoryGetter();
    categoryGetterPartner(iambuilder);
    allmylistLength = allmylistLengthFN(); 
    allpartnerlistLength = allpartnerlistLengthFN();
    selecteditemNameAndPriceFinderFN();
    selecteditemNameAndPriceFinderPartnerFN();
    //selectedItemPriceFinderFN(selectedItem,selecteditemamount);
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
                Expanded(flex: 4,child: Center(child: Text('Zelix Trade',style: GoogleFonts.pacifico(fontSize: 28,color: Colors.white),))),
                Expanded(flex: 2,child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Container(child: Center(child: Text('$totalmoney \$',style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold,letterSpacing: 1,fontSize: 18),)),)
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
                              height: height / 3.1,
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
                                        //color: Colors.yellow,
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
                                            onChanged: selectedItem == '' || selectedItem == 'Select' ? null : (v)async{
                                              bool _isNumeric(String result) {
                                                if (result == null) {
                                                  return false;
                                                }
                                                return double.tryParse(result) != null;
                                              }
                                              if(_isNumeric(v)){
                                                  setState(() {
                                                    myenteredamountnotanumber = false;
                                                  });
                                                  await Supabase.instance.client.from('rooms').update({'myselecteditemamount' : int.parse(v.toString())})
                                                                                              .eq(iambuilder ? 'tradesman1' : 'tradesman2',Supabase.instance.client.auth.currentUser!.userMetadata!['nickname']);
                                                  List<Map<String, dynamic>> mypricelist = await Supabase.instance.client.from('boughtProducts').select<PostgrestList>('price')
                                                                                              .eq('owner', Supabase.instance.client.auth.currentUser!.email)
                                                                                              .eq('name', selectedItem);
                                                  await Supabase.instance.client.from('rooms').update({'myselecteditemprice' : int.parse(v.toString()) * int.parse(mypricelist[0].values.first.toString())})
                                                                                              .eq(iambuilder ? 'tradesman1' : 'tradesman2',Supabase.instance.client.auth.currentUser!.userMetadata!['nickname']);
                                                                                              
                                                  setState(() {
                                                    selecteditemamount = int.parse(v.toString());
                                                    selecteditemprice = int.parse(v.toString()) * int.parse(mypricelist[0].values.first.toString());
                                                  });
                                              }
                                              else{
                                                setState(() {
                                                  myenteredamountnotanumber = true;
                                                });
                                              }
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
                                        child: Center(child: Text('$selecteditemprice',style: const TextStyle(color: Colors.purple,fontSize: 15),)),
                                      )
                                    ]
                                  ),
                                  SizedBox(
                                    height: 100,
                                    width: 100,
                                    child: ElevatedButton(
                                      style:  ButtonStyle(
                                        backgroundColor: selectedItem == '' || selectedItem == 'Select' || myenteredamountnotanumber ? MaterialStatePropertyAll(Colors.grey) : MaterialStatePropertyAll(Colors.white),
                                        shadowColor: MaterialStatePropertyAll(Colors.green),
                                        side: MaterialStatePropertyAll(BorderSide(color: Colors.green)),
                                      ),
                                      onPressed:selectedItem == '' || selectedItem == 'Select' || myenteredamountnotanumber ? null : ()async{
                                        List<Map<String, dynamic>> myamountmap = await Supabase.instance.client.from('boughtProducts').select<PostgrestList>('amount')
                                                                                              .eq('owner', Supabase.instance.client.auth.currentUser!.email)
                                                                                              .eq('name', selectedItem);
                                        //print(int.parse(myamountmap[0].values.first.toString()));
                                        if(selecteditemamount > int.parse(myamountmap[0].values.first.toString())){
                                          setState(() {
                                            notenoughtamounterror = 'Not enough amount';
                                          });
                                        }
                                        else{
                                          setState(() {
                                            notenoughtamounterror = '';
                                          });
                                          List<Map<String, dynamic>> partnernicknamemap = await Supabase.instance.client.from('rooms')
                                                                               .select<PostgrestList>(iambuilder ? 'tradesman2' : 'tradesman1')
                                                                               .eq(iambuilder ? 'tradesman1' : 'tradesman2',Supabase.instance.client.auth.currentUser!.userMetadata!['nickname'])
                                                                               .then((value) => value);
                                          List<Map<String, dynamic>> partneremailmap = await Supabase.instance.client.from('users').select<PostgrestList>('email').eq('name',partnernicknamemap[0].values.first).then((value) => value);
                                          List<Map<String, dynamic>> mycategorymap = await Supabase.instance.client.from('boughtProducts').select<PostgrestList>('category')
                                                                                              .eq('owner', Supabase.instance.client.auth.currentUser!.email)
                                                                                              .eq('name', selectedItem);
                                          List<Map<String, dynamic>> mypricemap = await Supabase.instance.client.from('boughtProducts').select<PostgrestList>('price')
                                                                                              .eq('owner', Supabase.instance.client.auth.currentUser!.email)
                                                                                              .eq('name', selectedItem);
                                          List<Map<String, dynamic>> myincdecmap = await Supabase.instance.client.from('boughtProducts').select<PostgrestList>('incdec')
                                                                                              .eq('owner', Supabase.instance.client.auth.currentUser!.email)
                                                                                              .eq('name', selectedItem);
                                          List<Map<String, dynamic>> mypercentmap = await Supabase.instance.client.from('boughtProducts').select<PostgrestList>('percent')
                                                                                              .eq('owner', Supabase.instance.client.auth.currentUser!.email)
                                                                                              .eq('name', selectedItem);
                                          List<Map<String, dynamic>> allids= await Supabase.instance.client.from('boughtProducts').select<PostgrestList>('id').then((value) => value);
                                          List<int> temp = [];
                                          for (var i = 0; i < allids.length; i++) {
                                            for (var intelmnt in List<int>.from(allids[i].values)) {
                                              temp.add(int.parse(intelmnt.toString()));
                                            }
                                          }
                                          temp.sort();
                                          int lastid = temp.last;
                                          print(lastid);
                                          await Supabase.instance.client.from('boughtProducts').insert({'id': lastid + 1,'owner':partneremailmap[0].values.first.toString(),'category':mycategorymap[0].values.first.toString(),'name':selectedItem,'amount':selecteditemamount,'price':mypricemap[0].values.first.toString(),'incdec':myincdecmap[0].values.first.toString(),'percent':mypercentmap[0].values.first.toString()});
                                          await Supabase.instance.client.from('boughtProducts').update({'amount':int.parse(myamountmap[0].values.first.toString()) - selecteditemamount})
                                                                                               .eq('name',selectedItem)
                                                                                               .eq('owner', Supabase.instance.client.auth.currentUser!.email);
                                          await Supabase.instance.client.from('users').update({'totalmoney' : totalmoney + selecteditemprice}).eq('name', Supabase.instance.client.auth.currentUser!.userMetadata!['nickname']);
                                        }
                                      }, 
                                      child: const Center(child: Text('SELL',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 15),),)),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: 16,child: Text(notenoughtamounterror,style: const TextStyle(color: Colors.red,fontSize: 13,letterSpacing: 3,fontWeight: FontWeight.bold),)),
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
                                  Column(
                                    children: [
                                      const Text('Price',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,letterSpacing: 2,fontSize: 15),),
                                      SizedBox(
                                        height: 30,
                                        child: Text('$selectedpartneritemprice \$',style: const TextStyle(color: Colors.purple,fontSize: 15),),
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