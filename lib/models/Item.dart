import 'package:shared_preferences/shared_preferences.dart';

class Item{
  String name = "";
  String price = "";
  String amount = "";
  String incdec = "";
  String percent = "";
  Item({required this.name, required this.price, required this.amount, required this.incdec, required this.percent});  

  factory Item.fromJson(Map<String, dynamic> json,String subname){
    return Item(
      name: json[subname]['name'],
      price: json[subname]['price'],
      amount: json[subname]['amount'],
      incdec: json[subname]['incdec'],
      percent: json[subname]['percent'],
    );
  }
   factory Item.fromJsonAmountZero(dynamic subname){
    return Item(
      name: subname['name'],
      price: subname['price'],
      amount: subname['amount'],
      incdec: subname['incdec'],
      percent: subname['percent'],
    );
  }
  void percentMover(Map<String, dynamic> json,String percent,String price,String incdec,String subcatname)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('${subcatname}percent', percent);
    await prefs.setString('${subcatname}incdec', incdec);
    await prefs.setString('${subcatname}price', price);
  }
  Item fromJsonAllDEC(Map<String, dynamic> json,String subname,String subcatname){ //BUYING FROM ALLPRODUCTS
    if(json[subname]['name'] == subcatname){
      if(int.parse(json[subname]['amount']) > 0){json[subname]['amount'] = (int.parse(json[subname]['amount']) - 1).toString();}
      String percent = (double.parse(json[subname]['percent']) + 0.5).toString();
      String price = ((double.parse(json[subname]['price']) + ((1000 * double.parse(json[subname]['percent'])) / 100)).floor()).toString();
      String incdec = 'inc';
      percentMover(json,percent,price,incdec,subcatname);
      return Item(
        name: json[subname]['name'],
        price: price,
        amount: json[subname]['amount'],
        incdec: incdec,
        percent: percent,
      );
    }
    else{
      return Item(
        name: json[subname]['name'],
        price: json[subname]['price'],
        amount: json[subname]['amount'],
        incdec: json[subname]['incdec'],
        percent: json[subname]['percent'],
      );
    }
  }
  void percentMoverincALL(Map<String, dynamic> json,String subname,String subcatname)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('${subcatname}percent', json[subname]['percent']);
    await prefs.setString('${subcatname}incdec', 'dec');
    await prefs.setString('${subcatname}price', json[subname]['price']);
  }
  Item fromJsonAllINC(Map<String, dynamic> json,String subname,String subcatname,int subcatnameamountpref){ //SELLING TO ALLPRODUCTS
    if(json[subname]['name'] == subcatname){
      if(subcatnameamountpref > 0){json[subname]['amount'] = (int.parse(json[subname]['amount']) + 1).toString();}
      if(double.parse(json[subname]['percent']) > 0){json[subname]['percent'] = (double.parse(json[subname]['percent']) - 0.5).toString();}
      json[subname]['price'] = ( (double.parse(json[subname]['price']) - ((1000 * double.parse(json[subname]['percent'])) / 100)).floor()).toString();
      json[subname]['incdec'] = 'dec';
      percentMoverincALL(json, subname, subcatname);
      return Item(
        name: json[subname]['name'],
        price: json[subname]['price'],
        amount: json[subname]['amount'],
        incdec: json[subname]['incdec'],
        percent: json[subname]['percent'],
      );
    }
    else{
      return Item(
        name: json[subname]['name'],
        price: json[subname]['price'],
        amount: json[subname]['amount'],
        incdec: json[subname]['incdec'],
        percent: json[subname]['percent'],
      );
    }
  }
  Item fromJsonMY(Map<String, dynamic> json,String subname,String amount,String subcatname,String price,String percent,SharedPreferences prefs){ //BUYING FROM ALLPRODUCTS
  //SharedPreferences prefs = await SharedPreferences.getInstance(); 
  var id = prefs.getString('${subcatname}incdec') ?? 'inc';
  //var price = prefs.getString('${subcatname}price') ?? '1000';
  if(json[subname]['name'] == subcatname){
    return Item(
            name: json[subname]['name'],
            price: price,
            amount: amount,
            incdec: id,
            percent: percent,
          );
  }
  else{
    return Item(
      name: json[subname]['name'],
      price: json[subname]['price'],
      amount: amount,
      incdec: json[subname]['incdec'],
      percent: json[subname]['percent'],
    );

  }
    
    
  }
  Map<String,dynamic> toJson(){
    Map<String,dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['price'] = price;
    data['amount'] = amount;
    data['incdec'] = incdec;
    data['percent'] = percent;
    return data;
  }
  
 //@override
 //Widget build(BuildContext context) {
 //  // TODO: implement build
 //  throw Placeholder();
 //}
}