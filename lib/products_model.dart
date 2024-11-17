//now here we will create a model for our local data to stor ein sql
class Cart{
  late final int? id;
  final String? productsId;
  final String? productsName;
  final int? initialPrice;
  final int? productsPrice;
  final int? quantity;
  final String? unitTag;
  final String? image;
  Cart({
  required this.id,
  required this.productsId,
  required this.productsName,
  required this.initialPrice,
  required this.productsPrice,
  required this.quantity,
  required this.unitTag,
  required this.image});
  Cart.fromMap(Map<dynamic,dynamic> res)
  :id=res['id'],
  productsId=res['productsId'],
  productsName=res['productsName'],
  initialPrice=res['initialPrice'],
  productsPrice=res['productsPrice'],
  quantity=res['quantity'],
  unitTag=res['unitTag'],
  image=res['image'];
  Map<String,Object?> toMap(){
    return{
      'id':id,
      'productsId':productsId,
      'productsName':productsName,
      'initialPrice':initialPrice,
      'productsPrice':productsPrice,
      'quantity':quantity,
      'unitTag':unitTag,
      'image':image,
    };
  }


}