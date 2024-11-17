import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping_cart_flutter/db_helper.dart';
import 'package:shopping_cart_flutter/products_model.dart';

class CartProvider with ChangeNotifier{
  DBHelper dbhelper=DBHelper();
  int _counter=0;
  int get counter=>_counter;

  double _totalPrice=0.0;
  double get totalPrice=>_totalPrice;
  
  late Future<List<Cart>> _cart;//here we have our private attributes 
  Future<List<Cart>> get cart=>_cart;//here it will get the private attributes for us

Future<List<Cart>> getData()async{
   _cart=dbhelper.fetchCartList();
   return _cart;
}
  void _setPrefsItem()async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
    prefs.setInt('cart_item',_counter);
    prefs.setDouble('cart_price',_totalPrice);
    notifyListeners();
  }
   void _getPrefsItem()async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
   _counter= prefs.getInt('cart_item',)??0;
  _totalPrice=prefs.getDouble('cart_price',)??0.0;
    notifyListeners();
  }
   void addCounter(){
    _counter++;
    _setPrefsItem();
    print(_counter);
    notifyListeners();
   }
   
   void removeCounter(){
    _counter--;
    _setPrefsItem();
    notifyListeners();
   }
   int getCounter(){
    _getPrefsItem();
    return _counter;
    
   }
   void addTotalPrice(double productsPrice){
    _totalPrice=_totalPrice+productsPrice;
    _setPrefsItem();
    notifyListeners();
   }
   
   void removeTotalPrice(double productsPrice){
    _totalPrice=_totalPrice-productsPrice;
    _setPrefsItem();
    notifyListeners();
   }
   double getTotalPrice(){
    _getPrefsItem();
    return _totalPrice;
    
   }
}