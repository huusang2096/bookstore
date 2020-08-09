import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutterappbookstore/data/remote/product_service.dart';
import 'package:flutterappbookstore/shared/model/product.dart';
import 'package:flutterappbookstore/shared/model/rest_error.dart';

class ProductRepo{
  ProductService _productService;

  ProductRepo({@required ProductService productService}) : _productService = productService;

  Future<List<Product>> getProductList() async{
    var c = Completer<List<Product>>();
    try{
      var response = await _productService.getProductList();
      var productList = Product.parseProductList(response.data);
      c.complete(productList);
    } on DioError{
      c.completeError(RestError.fromData("Data is null"));
    }catch (e){
      c.completeError(e);
    }
    return c.future;
  }
}