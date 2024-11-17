import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_cart_flutter/cart_provider.dart';
import 'package:badges/badges.dart' as badges;
import 'package:shopping_cart_flutter/db_helper.dart';
import 'package:shopping_cart_flutter/products_model.dart';
import 'package:shopping_cart_flutter/products_screen.dart';
class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    final cart=Provider.of<CartProvider>(context);
    DBHelper dbHelper=DBHelper();
    return Scaffold(
      appBar:AppBar(
        centerTitle:true,
        title:const Text('My Products'),
        actions: [
          Center(
            child: badges.Badge(
              badgeContent: Consumer<CartProvider>(
                builder:(context,value,child){
                 return  Text(value.getCounter().toString(),style:const TextStyle(color:Colors.white));

                }),
              badgeAnimation:
                const badges.BadgeAnimation.fade(
                  animationDuration:Duration(milliseconds:34),
              ),
            child:   Icon(Icons.shopping_bag_outlined)),
          ),
      
          const SizedBox(width:20.0)
        ],
      ),
      body:Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
          FutureBuilder(
            future:cart.getData(),
            builder:(context, AsyncSnapshot<List<Cart>>snapshot){
               if(snapshot.hasData){
               if(snapshot.data!.isEmpty){
                return Center(child: Text('Cart is empty'),);
               }else{
    return Expanded(
                  child: ListView.builder(
            itemCount:snapshot.data!.length,
            itemBuilder:(BuildContext context , index){
            return Card(
              child:Column(
                crossAxisAlignment:CrossAxisAlignment.start,
                mainAxisAlignment:MainAxisAlignment.center,
                children: [
                  Row(
                     crossAxisAlignment:CrossAxisAlignment.start,
                mainAxisAlignment:MainAxisAlignment.start,
                mainAxisSize:MainAxisSize.max,
                children: [
                  Image(
                    height:100,
                    width:100,
                    image:NetworkImage(snapshot.data![index].image.toString()),),
                       SizedBox(width:10),
                      Expanded(
                        child: Column(
                          mainAxisAlignment:MainAxisAlignment.start,
                          crossAxisAlignment:CrossAxisAlignment.start,
                          children:  [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children:[
                            Text(snapshot.data![index].productsName.toString(),style:const TextStyle(fontSize:16,fontWeight:FontWeight.w500,)),
                        InkWell(onTap:(){
                            dbHelper.delete(snapshot.data![index].id!);
                            cart.removeCounter();
                            cart.removeTotalPrice(double.parse(snapshot.data![index].productsPrice.toString()));
                        },child:  Icon(Icons.delete) )
                         ]),
                        
                          const SizedBox(height:5),
                          Text(snapshot.data![index].unitTag.toString()+""+r"$"+snapshot.data![index].productsPrice.toString(),style:const TextStyle(fontSize:16,fontWeight:FontWeight.w500)),
                          const SizedBox(height:5),
                                      
                           Align(
                            alignment:Alignment.bottomRight,
                             child: Container(
                                decoration:BoxDecoration(color:Colors.green,
                                borderRadius: BorderRadius.circular(5)
                                ),height:35,
                                width:100,
                             
                                child:Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      InkWell(
                                        onTap:(){
                                         int quantity=snapshot.data![index].quantity!;
                                        int price=snapshot.data![index].initialPrice!;
                                        quantity--;
                                        int newPrice=quantity*price;
                                        if(quantity>0){
                                          dbHelper.updateQuantity(Cart(
                                          id:snapshot.data![index].id,
                                         productsId: snapshot.data![index].productsId,
                                          productsName: snapshot.data![index].productsName,
                                           initialPrice: snapshot.data![index].initialPrice!,
                                           productsPrice: newPrice,
                                           unitTag: snapshot.data![index].unitTag,
                                           quantity: quantity,
                                           image:snapshot.data![index].image,)).then((value){
                                            newPrice=0;
                                            quantity=0;
                                            cart.removeTotalPrice(double.parse(snapshot.data![index].initialPrice.toString()));
                                           }
                                           ).onError((error,stackTrace){
                                            print(error.toString());
                                           });}
                                        
                                        },
                                        child: Icon(Icons.remove,color:Colors.white,)),
                                       Text(snapshot.data![index].quantity.toString(),style:TextStyle(color:Colors.white,)),
                                       InkWell(
                                        onTap:(){
                                        int quantity=snapshot.data![index].quantity!;
                                        int price=snapshot.data![index].initialPrice!;
                                        quantity++;
                                        int newPrice=quantity*price;
                                        dbHelper.updateQuantity(Cart(
                                          id:snapshot.data![index].id,
                                         productsId: snapshot.data![index].productsId,
                                          productsName: snapshot.data![index].productsName,
                                           initialPrice: snapshot.data![index].initialPrice!,
                                           productsPrice: newPrice,
                                           unitTag: snapshot.data![index].unitTag,
                                           quantity: quantity,
                                           image:snapshot.data![index].image,)).then((value){
                                            newPrice=0;
                                            quantity=0;
                                            cart.addTotalPrice(double.parse(snapshot.data![index].initialPrice.toString()));
                                           }
                                           ).onError((error,stackTrace){
                                            print(error.toString());
                                           });
                                        },
                                        child: Icon(Icons.add,color:Colors.white,))
                                    ],
                                  ),
                                ),),
                           ),
                                        
                        ],
                        ),
                      )
                ],
              ),
        
               
              ],),);
          }
          ),
          );
               }
               }
               return Text('');
          }
          ),
            Consumer<CartProvider>(builder: (context,value,child){
          return Visibility(
            visible:value.getTotalPrice().toStringAsFixed(2)=='0.0'?false:true,
            child: Column(children:[
              ReausibleWidget(title: 'Sub Total', value: r"$"+value.getTotalPrice().toStringAsFixed(2)),
             ReausibleWidget(title: 'Discount 5%', value: r"$"+"20"),
              ReausibleWidget(title: 'Total', value: r"$"+value.getTotalPrice().toStringAsFixed(2))
            ]),
          );
        },)
        ],),
      )
    );

  }
}