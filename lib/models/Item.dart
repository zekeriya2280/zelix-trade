class Item{
  String name = "";
  String price = "";
  String amount = "";
  String incdec = "";
  String percent = "";
  Item({required this.name, required this.price, required this.amount, required this.incdec, required this.percent});  

  factory Item.fromJson(Map<String, dynamic> json,String subname){
    //print(subname);
    return Item(
      name: json[subname]['name'],
      price: json[subname]['price'],
      amount: json[subname]['amount'],
      incdec: json[subname]['incdec'],
      percent: json[subname]['percent'],
    );
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
}