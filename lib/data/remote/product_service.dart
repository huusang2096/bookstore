import 'package:dio/dio.dart';
import 'package:flutterappbookstore/network/book_client.dart';

class ProductService{
  Future<Response> getProductList(){
    return BookClient.instance.dio.get('/product/list',);
  }
}