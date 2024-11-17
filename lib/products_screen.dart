import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:provider/provider.dart';
import 'package:shopping_cart_flutter/cart_provider.dart';
import 'package:shopping_cart_flutter/cart_screen.dart';
import 'package:shopping_cart_flutter/db_helper.dart';
import 'package:shopping_cart_flutter/products_model.dart';
class ProductsListScreen extends StatefulWidget {
  const ProductsListScreen({super.key});
  
  @override
  State<ProductsListScreen> createState() => _ProductsListScreenState();
}
class _ProductsListScreenState extends State<ProductsListScreen> {
  DBHelper? dbHelper=DBHelper();
  @override
  Widget build(BuildContext context) {
    final cart=CartProvider();
    return Scaffold(
      appBar:AppBar(
        centerTitle:true,
        title:const Text('products List'),
        actions: [
          InkWell(
            onTap:(){
              Navigator.push(context,MaterialPageRoute(builder:(context)=>CartScreen()));
            },
            child: Center(
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
          ),
      
          const SizedBox(width:20.0)
        ],
      ),
      body:Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
          Expanded(child: ListView.builder(
            itemCount:productsIamge.length,
            itemBuilder:(context , index){
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
                    image:NetworkImage(productsIamge[index].toString())),
                      const SizedBox(width:10),
                      Expanded(
                        child: Column(
                          mainAxisAlignment:MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(productsName[index].toString(),style:const TextStyle(fontSize:16,fontWeight:FontWeight.w500,)),
                          const SizedBox(height:5),
                          Text(productsUnit[index].toString()+" "+r"$"+productsPrice[index].toString(),style:const TextStyle(fontSize:16,fontWeight:FontWeight.w500)),
                          const SizedBox(height:5),
                                      
                           Align(
                            alignment:Alignment.bottomRight,
                             child: InkWell(
                              onTap:(){
                             dbHelper!.insertCart(Cart(
                              id:index,
                              productsId: index.toString(), 
                              productsName: productsName[index].toString(),
                              initialPrice:int.parse(productsPrice[index]),
                             productsPrice: int.parse(productsPrice[index]),
                             quantity:1,
                             unitTag:productsUnit[index],
                             image:productsIamge[index],
        
                             )
                             ).then((value){
                              cart.addTotalPrice(double.parse(productsPrice[index]));
                              cart.addCounter();
                              print('products are added to cart');
                            
                             }).onError((error,StackTrace){
                              print(error.toString());
                             });
                              },
                               child: Container(
                                  decoration:BoxDecoration(color:Colors.green,
                                  borderRadius: BorderRadius.circular(5)
                                  ),height:35,
                                  width:100,
                               
                                  child:const Center(child: Text('add to cart',style:TextStyle(color:Colors.white)),),),
                             ),
                           ),
                                        
                        ],),
                      )
                ],
              ),
        
               
              ],),);
          }
          ),
          )
        ,
        Consumer<CartProvider>(builder: (context,value,child){
          return Column(children:[
            ReausibleWidget(title: 'Sub Total', value: r"$"+value.getTotalPrice().toStringAsFixed(2)),
             ReausibleWidget(title: 'Discount 5%', value: r"$"+"20"),
              ReausibleWidget(title: 'Total', value: r"$"+value.getTotalPrice().toStringAsFixed(2))
          ]);
        },)
        ],),
      )

    );
  }
}

class ReausibleWidget extends StatelessWidget {
  final String title,value;
  const ReausibleWidget({required this.title,required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
        Text(title.toString(),style:Theme.of(context).textTheme.titleSmall),
        Text(value.toString(),style:Theme.of(context).textTheme.titleSmall)
      ],),
    );
  }
}






List<String> productsName=['Mango','Orange','grapes','Banana','Chery','Peach','Mixed Fruits Baskets'];
List<String> productsPrice=['10','20','30','40','50','60','70'];
List<String> productsUnit=['Kg','Dozen','Kg','Dozen','Kg','Kg','Kg'];
List<String> productsIamge=[
  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRJTLKImLI26PLK-vTW4Idp1mekL58rczFxbg&s',
'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSNZsYDs6mBDRIvMVyCIlNJcPROD_HdWkCIPA&s',
'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSbPp70d4fAiWaeBswNOzPgF3PDpB8JxpzC1g&s',
'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSezzQSzBq2kkUZjSOPAu4lKgdXeobojhbp3A&s',
'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQRK0LouC63Z0FAiKgComPL17GC1LkvM2hIqQ&s',
'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRE_bczFMBHqwiCD7n-z9SZP2Uv4juVc4erXQ&s',
'https://sendflowers.pk/wp-content/uploads/2019/05/Fruit-In-Imported-Cane-Basket-1.jpg'];