import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutterappbookstore/base/base_bloc.dart';
import 'package:flutterappbookstore/base/base_event.dart';
import 'package:flutterappbookstore/data/repo/order_repo.dart';
import 'package:flutterappbookstore/data/repo/product_repo.dart';
import 'package:flutterappbookstore/event/add_to_cart_event.dart';
import 'package:flutterappbookstore/shared/model/product.dart';
import 'package:flutterappbookstore/shared/model/shopping_cart.dart';
import 'package:rxdart/rxdart.dart';

class HomeBloc extends BaseBloc with ChangeNotifier{
  final ProductRepo _productRepo;
  final OrderRepo _orderRepo;

  var _shoppingCart = ShoppingCart();

  static HomeBloc _instance;

  static HomeBloc getInstance({
    @required ProductRepo productRepo,
    @required OrderRepo orderRepo}){
      if(_instance == null){
        _instance = HomeBloc._internal(
            productRepo: productRepo,
            orderRepo: orderRepo
        );
      }
      return _instance;
    }

  HomeBloc._internal({@required ProductRepo productRepo, @required OrderRepo orderRepo,}) :
    _productRepo = productRepo, _orderRepo = orderRepo;

  final _shoppingCartSubject = BehaviorSubject<ShoppingCart>();

  Stream<ShoppingCart> get shoppingCartStream => _shoppingCartSubject.stream;
  Sink<ShoppingCart> get shoppingCartSink => _shoppingCartSubject.sink;

  @override
  void dispatchEvent(BaseEvent event) {
    // TODO: implement dispatchEvent
    switch (event.runtimeType){
      case AddToCartEvent:
        handleAddToCart(event);
        break;
    }
  }


  handleAddToCart(event) {
    AddToCartEvent addToCartEvent = event as AddToCartEvent;
    _orderRepo.addToCart(addToCartEvent.product).then((shoppingCart) {
      _shoppingCart.orderId = shoppingCart.orderId;
      //print(shoppingCart.orderId.toString());
      shoppingCartSink.add(shoppingCart);
    });
  }

  getShoppingCartInfo(){
    Stream<ShoppingCart>.fromFuture(
      _orderRepo.getShoppingCartInfo(),
    ).listen((shoppingCarts) {
      _shoppingCart = shoppingCarts;
      shoppingCartSink.add(shoppingCarts);
    }, onError: (err){
      _shoppingCartSubject.addError(err);
    });
  }

  Stream<List<Product>> getProductList(){
    return Stream<List<Product>>.fromFuture(_productRepo.getProductList());
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    print("Homepage Close");
    _shoppingCartSubject.close();
  }
}