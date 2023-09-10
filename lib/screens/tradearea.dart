
import 'package:feature_notifier/feature_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  String notenoughtamounterror = '';
  bool nosellnotification = true;
  bool iamsellnotificating = false;
  bool partnersellnotificating = false;
  String myMessageToPartner = '';
  String nameForPopupSell = '';
  int priceForPopupSell = 0;
  String incdecForPopupSell = '';
  double percentForPopupSell = 0.0;
  String partnerEmail = '';
  String partnerNickname = '';
  int mySelectedItemPrice = 0;
  int mySelectedItemAmount = 0;
  List<Map<String, dynamic>> allmassages = [];
  List<Map<String, dynamic>> allmylist = [];
  List<Map<String, dynamic>> allpartnerlist = [];

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
            //await Supabase.instance.client.from('rooms').update({'sellnotification' : {Supabase.instance.client.auth.currentUser!.userMetadata!['nickname'] : selection['name']}})
            //                                                                            .eq(iambuilder ? 'tradesman1': 'tradesman2', Supabase.instance.client.auth.currentUser!.userMetadata!['nickname']);
            setState(() {
              selectedItem = selection['name'].toString();
            });
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
   Widget buildMassages(int index, Map<String, dynamic> massagemap) {
        return SizedBox(
        height: 40,
        child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: massagemap == null ? const Color.fromARGB(255, 151, 158, 151) : const Color.fromARGB(255, 206, 162, 59),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                 Center(
                   child: Text(
                     '${massagemap.keys.first.toString().toUpperCase()}  :  ',
                     style: const TextStyle(
                         color: Color.fromARGB(255, 212, 225, 235),
                         fontSize: 11,
                         fontWeight: FontWeight.bold)),
                 ),
                 Center(
                   child: Text(
                     massagemap.values.first.toString().toUpperCase(),
                     style: const TextStyle(
                         color: Colors.white,
                         fontSize: 11,
                         fontWeight: FontWeight.bold)),
                 ),
              ],
            )),
      );
  }
  int allmylistLengthFN(){
    return allmylist.length;
  }
  int allpartnerlistLengthFN(){
    return allpartnerlist.length;
  }
  iambuilderFinderFN()async{
    String mynickname = Supabase.instance.client.auth.currentUser!.userMetadata!['nickname'].toString();
    //print(mynickname);
    List<Map<String, dynamic>> temp = await Supabase.instance.client.from('rooms').select<PostgrestList>('tradesman1').then((value) => value);
    iambuilder = temp.any((map) => map.values.first == mynickname);
    return true;
  }
  selecteditemNameAndPriceFinderFN()async{
    List<Map<String, dynamic>> myselecteditemmap = await Supabase.instance.client.from('rooms').select<PostgrestList>('myselecteditem').eq(iambuilder ? 'tradesman1' : 'tradesman2' , Supabase.instance.client.auth.currentUser!.userMetadata!['nickname']).then((value) => value);
    selectedItem = myselecteditemmap[0].values.first ?? "Select";
    List<Map<String, dynamic>> myselecteditempricemap = await Supabase.instance.client.from('rooms').select<PostgrestList>('myselecteditemprice').eq(iambuilder ? 'tradesman1' : 'tradesman2' , Supabase.instance.client.auth.currentUser!.userMetadata!['nickname']).then((value) => value);
    selecteditemprice = myselecteditempricemap[0].values.first ?? 0;
  }
  findPartnerEmail()async{
    List<Map<String, dynamic>> partnernicknamemap = await Supabase.instance.client.from('rooms')
                                 .select<PostgrestList>(iambuilder ? 'tradesman2' : 'tradesman1')
                                 .eq(iambuilder ? 'tradesman1' : 'tradesman2',Supabase.instance.client.auth.currentUser!.userMetadata!['nickname'])
                                 .then((value) => value);
    setState(() {
      partnerNickname = partnernicknamemap.isEmpty ? '' : partnernicknamemap[0].values.first.toString();
    });
    List<Map<String, dynamic>> partneremailmap = await Supabase.instance.client.from('users').select<PostgrestList>('email').eq('name',partnernicknamemap[0].values.first).then((value) => value);
    setState(() {
      partnerEmail = partneremailmap.isEmpty ? '' : partneremailmap[0].values.first.toString();
    });
  }
  findMySelectedItemProperties()async{
    List<Map<String, dynamic>> mypricelist = await Supabase.instance.client.from('boughtProducts').select<PostgrestList>('price')
                                                                                              .eq('owner', Supabase.instance.client.auth.currentUser!.email)
                                                                                              .eq('name', selectedItem).then((value) => value);
    List<Map<String, dynamic>> myamountlist = await Supabase.instance.client.from('boughtProducts').select<PostgrestList>('amount')
                                                                                              .eq('owner', Supabase.instance.client.auth.currentUser!.email)
                                                                                              .eq('name', selectedItem).then((value) => value);
    List<Map<String, dynamic>> mycategorymap = await Supabase.instance.client.from('boughtProducts').select<PostgrestList>('category')
                                                                                              .eq('owner', Supabase.instance.client.auth.currentUser!.email)
                                                                                              .eq('name', selectedItem).then((value) => value);
    List<Map<String, dynamic>> myincdecmap = await Supabase.instance.client.from('boughtProducts').select<PostgrestList>('incdec')
                                                                                              .eq('owner', Supabase.instance.client.auth.currentUser!.email)
                                                                                              .eq('name', selectedItem).then((value) => value);
    List<Map<String, dynamic>> mypercentmap = await Supabase.instance.client.from('boughtProducts').select<PostgrestList>('percent')
                                                                                              .eq('owner', Supabase.instance.client.auth.currentUser!.email)
                                                                                              .eq('name', selectedItem).then((value) => value);
    setState(() {
      mySelectedItemPrice = mypricelist.isEmpty ? 0 : int.parse(mypricelist[0].values.first.toString());
      mySelectedItemAmount = myamountlist.isEmpty ? 0 : int.parse(myamountlist[0].values.first.toString());
    });
  }
  checkWhoBuyingAndWhoSelling()async{
    List<Map<String, dynamic>> sellnotificationmap = await Supabase.instance.client.from('rooms')
                                                                           .select<PostgrestList>('sellnotification')
                                                                           .eq(iambuilder ? 'tradesman1' : 'tradesman2', Supabase.instance.client.auth.currentUser!.userMetadata!['nickname'])
                                                                           .then((value) => value);
    if(sellnotificationmap[0].values.first != null){
      setState(() {
        if(sellnotificationmap[0].values.first.keys.first.toString() == Supabase.instance.client.auth.currentUser!.userMetadata!['nickname']){
          iamsellnotificating = true;
          partnersellnotificating = false;
        }
        else{
          iamsellnotificating = false;
          partnersellnotificating = true;
        }
      });
    }
  }
  checkForPopUpEntities()async{
    List<Map<String,dynamic>> sellnotif = await Supabase.instance.client.from('rooms').select<PostgrestList>('sellnotification').eq(iambuilder ? 'tradesman1' : 'tradesman2',Supabase.instance.client.auth.currentUser!.userMetadata!['nickname']).then((value)=> value);
    String itemname = '';
    if(sellnotif[0].keys.first.toString() != Supabase.instance.client.auth.currentUser!.userMetadata!['nickname']){
      if(sellnotif[0].values.first != null){
      itemname = Map<String,dynamic>.from(sellnotif[0].values.first).values.first.toString();
      
      for (var map in allpartnerlist) {
            if(map['name'] == itemname) {
              setState(() {
                  selectedPartnerItem = map['name'];
                  nameForPopupSell = map['name'];
                  priceForPopupSell = map['price'];
                  incdecForPopupSell = map['incdec'];
                  percentForPopupSell = map['percent'];
              });
            }
          }
      }
    }
    
  }
  checkNooneNotificating()async{
    List<Map<String,dynamic>> sellnotificationmap = await Supabase.instance.client.from('rooms')
                                                                           .select<PostgrestList>('sellnotification')
                                                                           .eq(iambuilder ? 'tradesman1' : 'tradesman2',Supabase.instance.client.auth.currentUser!.userMetadata!['nickname'])
                                                                           .then((value) => value);
    setState(() {
      nosellnotification = sellnotificationmap[0].values.first==null  ? true : false;
    });
  }
  partnerItemAmountPriceFN()async{
    List<Map<String, dynamic>> whoselectedamount = await Supabase.instance.client.from('rooms')
                                                                                 .select<PostgrestList>('selecteditemamount')
                                                                                 .eq(iambuilder ? 'tradesman1': 'tradesman2', Supabase.instance.client.auth.currentUser!.userMetadata!['nickname'])
                                                                                 .then((value) => value);
    if(Map<String,dynamic>.from(whoselectedamount[0].values.first).keys.first.toString() == partnerNickname){
      setState(() {
        selectedpartneritemamount = int.parse(Map<String,dynamic>.from(whoselectedamount[0].values.first).values.first.toString());
        selectedpartneritemprice = selectedpartneritemamount * priceForPopupSell;
      });
    }
  }
  whoOKorDenyPopUpFN()async{
    List<Map<String, dynamic>> whoselectedamount = await Supabase.instance.client.from('rooms').select<PostgrestList>('whoOKtoSell')
                                                                                            .eq(iambuilder ? 'tradesman1': 'tradesman2', Supabase.instance.client.auth.currentUser!.userMetadata!['nickname'])
                                                                                            .then((value) => value);
    if(Map<String,dynamic>.from(whoselectedamount[0].values.first).values.first.toString() == 'false' && 
       Map<String,dynamic>.from(whoselectedamount[0].values.first).keys.first.toString() != Supabase.instance.client.auth.currentUser!.userMetadata!['nickname']){
      setState(() {
        notenoughtamounterror = 'Partner denied you offer!';
      });
    } 
    else if(notenoughtamounterror == 'Partner denied you offer!'){
      setState(() {
        notenoughtamounterror = '';
      });
    } 
    else if(Map<String,dynamic>.from(whoselectedamount[0].values.first).values.first.toString() == 'true' && 
       Map<String,dynamic>.from(whoselectedamount[0].values.first).keys.first.toString() != Supabase.instance.client.auth.currentUser!.userMetadata!['nickname']){
        setState(() {
          notenoughtamounterror = "Partner accepted your offer!";
        });
    }                                                                                  
  }
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
    findPartnerEmail();
    findMySelectedItemProperties();
    checkWhoBuyingAndWhoSelling();
    checkNooneNotificating();
    checkForPopUpEntities();
    partnerItemAmountPriceFN();
    whoOKorDenyPopUpFN();
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
      body: 
      Stack(
        alignment: AlignmentDirectional.center,
        children: [
          SingleChildScrollView(
                  child: Center(
                    child: SizedBox(
                      height: height,
                      width: width,
                      child: Column(children: [
                            //iambuilder ?  
                            Column(children: [
                              ///////////////////////////////////////////////////////////////////////////////////////////////////////////// I AM BUILDER OTHER IS JOINER
                              //mypagenotready ?  Center(child: SizedBox(height: 200,child: Center(child: CircularProgressIndicator(value: circularindicatorvalue,strokeWidth: 10,color: Colors.green,))),) :
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
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    //const SizedBox(width: 0,),
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
                                        SizedBox(
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
                                                      selecteditemamount = int.parse(v.toString());
                                                      selecteditemprice = int.parse(v.toString()) * mySelectedItemPrice;
                                                    });
                                                   if(notenoughtamounterror != 'Not enough amount'){
                                                      setState(() {
                                                        notenoughtamounterror += 'Partner thinking...';
                                                      });
                                                      await Supabase.instance.client.from('rooms').update({'myselecteditemamount' : int.parse(v.toString())})
                                                                                                .eq(iambuilder ? 'tradesman1' : 'tradesman2',Supabase.instance.client.auth.currentUser!.userMetadata!['nickname']);
                                                    
                                                      await Supabase.instance.client.from('rooms').update({'myselecteditemprice' : int.parse(v.toString()) * mySelectedItemPrice})
                                                                                                  .eq(iambuilder ? 'tradesman1' : 'tradesman2',Supabase.instance.client.auth.currentUser!.userMetadata!['nickname']);


                                                      await Supabase.instance.client.from('rooms')
                                                                      .update({"selecteditemamount": {Supabase.instance.client.auth.currentUser!.userMetadata!['nickname'].toString():selecteditemamount}})
                                                                      .eq(iambuilder ? 'tradesman1': 'tradesman2', Supabase.instance.client.auth.currentUser!.userMetadata!['nickname']);  
                                                      await Supabase.instance.client.from('rooms').update({'sellnotification' : {Supabase.instance.client.auth.currentUser!.userMetadata!['nickname'] : selectedItem}})
                                                                                  .eq(iambuilder ? 'tradesman1': 'tradesman2', Supabase.instance.client.auth.currentUser!.userMetadata!['nickname']);
                                                   }
                                                   else{
                                                    setState(() {
                                                      notenoughtamounterror = 'Not enough amount';
                                                    });
                                                   }
                                                   
                                                    
                                                    
                                                }
                                                else{
                                                  setState(() {
                                                    notenoughtamounterror = 'Not a number';
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
                                  ],
                                ),
                              ),
                              SizedBox(height: 16,child: Text(notenoughtamounterror,style:  TextStyle(color: notenoughtamounterror == "Partner accepted your offer!" ?  Colors.green :  Colors.red,fontSize: 13,letterSpacing: 3,fontWeight: FontWeight.bold),)),
                  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                              const Divider(color: Color.fromARGB(255, 255, 187, 0),height: 11,thickness: 6,indent: 10,endIndent: 10),
                              const Divider(color: Color.fromARGB(255, 255, 187, 0),height: 7,thickness: 6,indent: 10,endIndent: 10),
                  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// 
                              SizedBox(
                                height: height / 2.82,
                                width: width,
                                child: Center(
                                    child: ListView.separated(
                                        itemBuilder: (context, index) => buildMassages(index,allmassages[index]),
                                        separatorBuilder: (context, index) =>
                                            Container(height: 1,),
                                        itemCount: allmassages.length
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
                                        const SizedBox(
                                          height: 15,
                                          child: Text('Write a message to your partner',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,letterSpacing: 2,fontSize: 12),)),
                                        SizedBox(
                                          //color: Colors.yellow,
                                          height: 47,
                                          width: width/1.44,
                                          child: Center(
                                            heightFactor: 2,
                                            child: TextFormField(
                                              maxLengthEnforcement: MaxLengthEnforcement.enforced,
                                              maxLength: 33,
                                              textAlignVertical: TextAlignVertical.bottom,
                                              cursorHeight: 20,
                                              //maxLines: 2,
                                              style: const TextStyle(color: Colors.purple,fontSize: 12.5),
                                              textAlign: TextAlign.center,
                                              cursorColor: Colors.purple,
                                              decoration: InputDecoration(
                                                hintText: "Massage to your partner",
                                                counterText: "",
                                                focusColor: Colors.green,
                                                border: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                    color: Colors.green
                                                  ),
                                                  borderRadius: BorderRadius.circular(10.0),
                                                )
                                              ),
                                              onChanged:(v)async{
                                                setState(() {
                                                  myMessageToPartner = v;
                                                });
                                              },
                                            ),
                                          ),
                                        )
                                      ]
                                    ),
                                    SizedBox(
                                      height: 100,
                                      width: 100,
                                      child: ElevatedButton(
                                        style:  ButtonStyle(
                                          backgroundColor: myMessageToPartner == '' ? const MaterialStatePropertyAll(Colors.grey) : const MaterialStatePropertyAll(Colors.white),
                                          shadowColor: const MaterialStatePropertyAll(Colors.green),
                                          side: const MaterialStatePropertyAll(BorderSide(color: Colors.green)),
                                        ),
                                        onPressed:myMessageToPartner == '' ? null : ()async{
                                            List<Map<String,dynamic>> massageslistmap = await Supabase.instance.client.from('rooms')
                                                                          .select<PostgrestList>('massages')
                                                                          .eq(iambuilder ? 'tradesman1' : 'tradesman2',Supabase.instance.client.auth.currentUser!.userMetadata!['nickname'])
                                                                          .then((value) => value);
                                            List<Map<String,dynamic>> temp = [];
                                            print(massageslistmap[0]);
                                            //if(massageslistmap[0].values.first == null){
                                              for (var i = 0; i < List<Map<String,dynamic>>.from(massageslistmap[0].values.first).length; i++) {
                                                temp.add(List<Map<String,dynamic>>.from(massageslistmap[0].values.first)[i]);
                                              }
                                            //}
                                            
                                            temp.add({Supabase.instance.client.auth.currentUser!.userMetadata!['nickname']:myMessageToPartner});
                                            setState(() {
                                              allmassages = temp;
                                            });                      
                                            if(myMessageToPartner != ''){
                                                  await Supabase.instance.client.from('rooms').update({'massages' : temp})
                                                                                              .eq(iambuilder ? 'tradesman1': 'tradesman2', Supabase.instance.client.auth.currentUser!.userMetadata!['nickname']);
                                            }
                                            else{
                                              setState(() {
                                                const CircularProgressIndicator(strokeWidth: 10,color: Colors.green,);
                                              });
                                            }
                                          
                                        }, 
                                        child: const Center(child: Text('SEND',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 15),),)),
                                    )
                                  ],
                                ),
                              ), 
                             ])
                      ]),
                    )),
                ),
                nosellnotification || iamsellnotificating ?  Container() :  
                Center(
                  child: Container(
                    height: 300,
                    width: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: const Color.fromARGB(255, 255, 194, 101).withAlpha(230),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Expanded(flex: 1,child: Text('')),
                                  Text('Partner wants to sell you : ',style: TextStyle(fontSize: 20,color:Colors.blue,fontWeight: FontWeight.bold),),
                                  Expanded(flex: 1,child: Text('')),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                const Expanded(flex: 1,child: Text('')),
                                const Text('Name : ',style: TextStyle(fontSize: 20,color:Colors.white,fontWeight: FontWeight.bold),),
                                Text(nameForPopupSell,style: const TextStyle(fontSize: 20,color:Colors.white,fontWeight: FontWeight.bold),),
                                const Expanded(flex: 1,child: Text('')),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                const Expanded(flex: 1,child: Text('')),
                                const Text('Price : ',style: TextStyle(fontSize: 20,color:Colors.white,fontWeight: FontWeight.bold),),
                                Text(selectedpartneritemprice.toString(),style: const TextStyle(fontSize: 20,color:Colors.white,fontWeight: FontWeight.bold),),
                                const Expanded(flex: 1,child: Text('')),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                const Expanded(flex: 1,child: Text('')),
                                const Text('Amount : ',style: TextStyle(fontSize: 20,color:Colors.white,fontWeight: FontWeight.bold),),
                                Text(selectedpartneritemamount.toString(),style: const TextStyle(fontSize: 20,color:Colors.white,fontWeight: FontWeight.bold),),
                                const Expanded(flex: 1,child: Text('')),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(onPressed: ()async{
                                  await Supabase.instance.client.from('rooms').update({'whoOKtoSell' : {Supabase.instance.client.auth.currentUser!.userMetadata!['nickname'].toString() : false}})
                                                                                            .eq(iambuilder ? 'tradesman1': 'tradesman2', Supabase.instance.client.auth.currentUser!.userMetadata!['nickname']); 
                                  Navigator.pop(context);
                                }, child: const Text('Deny',style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,fontSize: 20))),
                                ElevatedButton(onPressed: ()async{
                                      await Supabase.instance.client.from('rooms').update({'sellnotification' : null})
                                                                                            .eq(iambuilder ? 'tradesman1': 'tradesman2', Supabase.instance.client.auth.currentUser!.userMetadata!['nickname']);
                                      await Supabase.instance.client.from('rooms').update({'whoOKtoSell' : {Supabase.instance.client.auth.currentUser!.userMetadata!['nickname'].toString() : true}})
                                                                                            .eq(iambuilder ? 'tradesman1': 'tradesman2', Supabase.instance.client.auth.currentUser!.userMetadata!['nickname']);
                                      
                                      setState(() {
                                        partnersellnotificating ? partnersellnotificating = false : null;
                                      });
                                      setState(() {
                                        notenoughtamounterror = '';
                                      });
                                      String result;
                                      List<Map<String, dynamic>> partnertotalmoneymap = await Supabase.instance.client.from('users').select<PostgrestList>('totalmoney').eq('name',partnerNickname).then((value) => value);
                                      List<Map<String, dynamic>> partnercategorymap = await Supabase.instance.client.from('boughtProducts').select<PostgrestList>('category')
                                                                                          .eq('owner', partnerEmail)
                                                                                          .eq('name', selectedPartnerItem);
                                      List<Map<String, dynamic>> partnerpricemap = await Supabase.instance.client.from('boughtProducts').select<PostgrestList>('price')
                                                                                          .eq('owner', partnerEmail)
                                                                                          .eq('name', selectedPartnerItem);
                                      List<Map<String, dynamic>> partnerincdecmap = await Supabase.instance.client.from('boughtProducts').select<PostgrestList>('incdec')
                                                                                          .eq('owner', partnerEmail)
                                                                                          .eq('name', selectedPartnerItem);
                                      List<Map<String, dynamic>> partnerpercentmap = await Supabase.instance.client.from('boughtProducts').select<PostgrestList>('percent')
                                                                                          .eq('owner', partnerEmail)
                                                                                          .eq('name', selectedPartnerItem);
                                      List<Map<String, dynamic>> allids= await Supabase.instance.client.from('boughtProducts')
                                                                                                       .select<PostgrestList>('id')
                                                                                                       .then((value) => value);
                                      List<int> temp = [];
                                      for (var i = 0; i < allids.length; i++) {
                                        for (var intelmnt in List<int>.from(allids[i].values)) {
                                          temp.add(int.parse(intelmnt.toString()));
                                        }
                                      }
                                      temp.sort();
                                      int lastid = temp.last;
                                      bool alreadyexist = false;
                                      List<Map<String, dynamic>> myamountmap = await Supabase.instance.client.from('boughtProducts')
                                                                                                             .select<PostgrestList>('amount')
                                                                                                             .eq('owner', Supabase.instance.client.auth.currentUser!.email)
                                                                                                             .eq('name', selectedPartnerItem);
                                      List<Map<String, dynamic>> myitemnamesmap = await Supabase.instance.client.from('boughtProducts')
                                                                                                                    .select<PostgrestList>('name')
                                                                                                                    .eq('owner', Supabase.instance.client.auth.currentUser!.email)
                                                                                                                    .then((value) => value);
                                      List<Map<String, dynamic>> partneramountmap = await Supabase.instance.client.from('boughtProducts')
                                                                                                                    .select<PostgrestList>('amount')
                                                                                                                    .eq('owner', partnerEmail)
                                                                                                                    .then((value) => value);
                                      alreadyexist = myitemnamesmap.any((map) {return map['name'].toString() == selectedPartnerItem;});
                                      //print(alreadyexist);
                                      if(alreadyexist){//partner amount should increase
                                        await Supabase.instance.client.from('boughtProducts')
                                                                      .update({'amount':int.parse(myamountmap[0].values.first.toString()) + selectedpartneritemamount})
                                                                      .eq('owner', Supabase.instance.client.auth.currentUser!.email)
                                                                      .eq('name', selectedPartnerItem);
                                      }
                                      else{
                                        await Supabase.instance.client.from('boughtProducts')
                                                                      .insert({'id': lastid + 1,
                                                                               'owner':Supabase.instance.client.auth.currentUser!.email,
                                                                               'category':partnercategorymap[0].values.first.toString(),
                                                                               'name':nameForPopupSell,
                                                                               'amount':selectedpartneritemamount,
                                                                               'price':(priceForPopupSell * selectedpartneritemamount).toString(),
                                                                               'incdec':incdecForPopupSell,
                                                                               'percent':percentForPopupSell});
                                      }
                                      
                                      await Supabase.instance.client.from('boughtProducts')
                                                                    .update({'amount':int.parse(partneramountmap[0].values.first.toString()) - selectedpartneritemamount})
                                                                    .eq('name',selectedPartnerItem)
                                                                    .eq('owner', partnerEmail);
                                      await Supabase.instance.client.from('users')
                                                                    .update({'totalmoney' : totalmoney - selectedpartneritemprice})
                                                                    .eq('name', Supabase.instance.client.auth.currentUser!.userMetadata!['nickname']);
                                      result = await Supabase.instance.client.from('users')
                                                                             .update({'totalmoney' : int.parse(partnertotalmoneymap[0].values.first.toString()) + selectedpartneritemprice})
                                                                             .eq('name', partnerNickname).then((value) => 'something');
                                }, child: const Text('Confirm',style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold,fontSize: 20))),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                ),
                ]
              )
               
            );
          }
}