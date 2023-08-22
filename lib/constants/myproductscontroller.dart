class MyProductsController{
  Map<String,int> amounts = {
    'tomatoes':0,
    'pepper':0,
    'apple':0,
    'pear':0,
    'pliers':0,
    'hammer':0,
    'glass':0,
    'spoon':0,
    'plastic':0
  };
  getAmounts(){
    return amounts;
  }
  setAmounts(amounts){
    this.amounts = amounts;
  }
  updateAmounts(String item,int amount){
    amounts[item] = amount;
  }
  MyProductsController();
}