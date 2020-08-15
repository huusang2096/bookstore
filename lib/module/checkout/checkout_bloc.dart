
import 'package:flutter/material.dart';
import 'package:flutterappbookstore/base/base_bloc.dart';
import 'package:flutterappbookstore/base/base_event.dart';
import 'package:flutterappbookstore/data/repo/order_repo.dart';
import 'package:flutterappbookstore/event/confirm_order_event.dart';
import 'package:flutterappbookstore/event/pop_event.dart';
import 'package:flutterappbookstore/event/update_cart_event.dart';
import 'package:flutterappbookstore/shared/model/order.dart';
import 'package:rxdart/rxdart.dart';

class CheckoutBloc extends BaseBloc with ChangeNotifier{
  final OrderRepo _orderRepo;

  CheckoutBloc({@required OrderRepo orderRepo}) : _orderRepo = orderRepo;

  final _orderSubject = BehaviorSubject<Order>();

  Stream<Order> get orderStream => _orderSubject.stream;
  Sink<Order> get orderSink => _orderSubject.sink;

  @override
  void dispatchEvent(BaseEvent event) {
    // TODO: implement dispatchEvent
    switch (event.runtimeType){
      case UpdateCartEvent:
        handleUpdateCart(event);
        break;
      case ConfirmOrderEvent:
        handleConfirmOrder(event);
        break;
    }
  }

  handleUpdateCart(event){
    UpdateCartEvent e = event as UpdateCartEvent;

    Stream<bool>.fromFuture(_orderRepo.updateOrder(e.product))
        .flatMap((_) => Stream<Order>.fromFuture(_orderRepo.getOrderDetail()))
        .listen((order) {
          orderSink.add(order);
        }
    );
  }

  handleConfirmOrder(event){
    _orderRepo.confirmOrder().then((isSuccess) {
      processEventSink.add(ShouldPopEvent());
    });
  }

  getOrderDetail(){
    Stream<Order>.fromFuture(
        _orderRepo.getOrderDetail(),
    ).listen((order) {
      orderSink.add(order);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    print('Checkout close');
    _orderSubject.close();
  }

}