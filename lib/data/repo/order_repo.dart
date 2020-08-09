import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutterappbookstore/data/remote/order_service.dart';
import 'package:flutterappbookstore/shared/model/order.dart';
import 'package:flutterappbookstore/shared/model/product.dart';
import 'package:flutterappbookstore/shared/model/rest_error.dart';
import 'package:flutterappbookstore/shared/model/shopping_cart.dart';

class OrderRepo{
  OrderService _orderService;
  String _orderId;

  OrderRepo({@required OrderService orderService,@required String orderId}) :
        _orderService = orderService,
        _orderId = orderId;

  Future<ShoppingCart> addToCart(Product product) async{
    var c = Completer<ShoppingCart>();
    try{
      var response = await _orderService.addToCart(product);
      var shoppingCart = ShoppingCart.fromJson(response.data['data']);
      //print(shoppingCart.orderId.toString());
      c.complete(shoppingCart);
    } on DioError {
      c.completeError(RestError.fromData('Error AddToCart'));
    }catch (e){
      c.completeError(e);
    }
    return c.future;
  }

  Future<ShoppingCart> getShoppingCartInfo() async{
    var c = Completer<ShoppingCart>();
    try{
      var response = await _orderService.countShoppingCart();
      var shoppingCart1 = ShoppingCart.fromJson(response.data['data']);
      //print(response.toString());
      c.complete(shoppingCart1);
    } on DioError{
      c.completeError(RestError.fromData("Take info shopping cart have issue"));
    } catch (e){
      c.completeError(e);
    }
    return c.future;
  }

  Future<Order> getOrderDetail() async{
    var c = Completer<Order>();
    try{
      var response = await _orderService.orderDetail(_orderId);
      if(response.data['data']['items'] != null ){
        var order = Order.fromJson(response.data['data']);
        c.complete(order);
      }else{
        c.completeError(RestError.fromData('Can not take Order'));
      }
    }on DioError{
      c.completeError(RestError.fromData('Can not take Order'));
    }catch (e){
      c.completeError(RestError.fromData(e.toString()));
    }
    return c.future;
  }

  Future<bool> updateOrder(Product product) async{
    var c = Completer<bool>();
    try{
      await _orderService.updateOrder(product);
      c.complete(true);
    }on DioError{
      c.completeError(RestError.fromData('error while updating order'));
    }catch (e){
      c.completeError(e.toString());
    }
    return c.future;
  }

  Future<bool> confirmOrder() async{
    var c = Completer<bool>();
    try{
      await _orderService.confirm(_orderId);
      c.complete(true);
    }on DioError{
      c.completeError(RestError.fromData('Error Confirm Order'));
    }catch (e){
      c.completeError(e.toString());
    }
    return c.future;
  }
}