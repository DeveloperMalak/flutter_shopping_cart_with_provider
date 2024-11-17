import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:shopping_cart_flutter/products_model.dart';
import 'dart:io'as io;
class DBHelper{
  static Database? _db;
  Future<Database?> get db async{
    if(_db!=null){
      return _db;
    }
    _db=await initDatabase();
  }
  initDatabase()async{
    io.Directory documentDirectory= await getApplicationDocumentsDirectory();
    String path=join(documentDirectory.path,'cart.db');
    var db=await openDatabase(path,version:1,onCreate:_onCreate,);
    return db;
  }
  _onCreate(Database db,int version)async{
     await db.execute(
      'CREATE TABLE CART(id INT PRIMARY KEY,productsId VARCHAR UNIQUE,productsName TEXT,initialPrice INT,productsPrice INT,quantity INT,unitTag TEXT,image TEXT);');
  }
  Future<Cart> insertCart(Cart cart)async{
    print(cart.toMap());
    var dbClient=await db;
    await dbClient!.insert('cart',cart.toMap());
    return cart;
  }

  Future<List<Cart>> fetchCartList()async{
    var dbClient=await db;
    final List<Map<String,Object?>> queryResult=await dbClient!.query('cart');
    return queryResult.map((e)=>Cart.fromMap((e))).toList();

  }
  Future<int>delete(int id)async{
    var dbClient=await db;
   return await dbClient!.delete(
    'cart',
    where:'id=?',
    whereArgs:[id],
   );
  }
  Future<int>updateQuantity(Cart cart)async{
    var dbClient=await db;
   return await dbClient!.update(
    'cart',
    cart.toMap(),
    where:'id=?',
    whereArgs:[cart.id],
   );
  }
}