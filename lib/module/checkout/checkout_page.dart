import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:flutterappbookstore/base/base_event.dart';
import 'package:flutterappbookstore/base/base_widget.dart';
import 'package:flutterappbookstore/data/remote/order_service.dart';
import 'package:flutterappbookstore/data/repo/order_repo.dart';
import 'package:flutterappbookstore/event/confirm_order_event.dart';
import 'package:flutterappbookstore/event/pop_event.dart';
import 'package:flutterappbookstore/event/update_cart_event.dart';
import 'package:flutterappbookstore/module/checkout/checkout_bloc.dart';
import 'package:flutterappbookstore/shared/app_color.dart';
import 'package:flutterappbookstore/shared/model/order.dart';
import 'package:flutterappbookstore/shared/model/product.dart';
import 'package:flutterappbookstore/shared/model/rest_error.dart';
import 'package:flutterappbookstore/shared/widget/bloc_listener.dart';
import 'package:flutterappbookstore/shared/widget/btn_cart_action.dart';
import 'package:flutterappbookstore/shared/widget/normal_button.dart';
import 'package:provider/provider.dart';

class CheckoutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String orderId = ModalRoute.of(context).settings.arguments;
    return PageContainer(
      title: 'Checkout',
      bloc: [],
      di: [
        Provider.value(value: orderId),
        Provider.value(value: OrderService()),
        ProxyProvider2<OrderService,String,OrderRepo>(
          update: (context,orderService,orderId,previous) => OrderRepo(
            orderService: orderService,
            orderId: orderId,
          ),
        ),
      ],
      child: ShoppingCartContainer(),
    );
  }
}

class ShoppingCartContainer extends StatefulWidget {
  @override
  _ShoppingCartContainerState createState() => _ShoppingCartContainerState();
}

class _ShoppingCartContainerState extends State<ShoppingCartContainer> {
  @override

   handleEvent(BaseEvent event) async {
    if(event is ShouldPopEvent){
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create:(_) => CheckoutBloc(orderRepo: Provider.of(context)),
      child: Consumer<CheckoutBloc>(
        builder: (context,bloc,child) => BlocListener<CheckoutBloc>(
          listener: handleEvent,
          child: ShoppingCart(bloc),
        ),
      ),
    );
  }
}

class ShoppingCart extends StatefulWidget {
  final CheckoutBloc bloc;
  ShoppingCart(this.bloc);

  @override
  _ShoppingCartState createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> {
  @override
  void initState() {
    super.initState();
    widget.bloc.getOrderDetail();

    //print(widget.bloc.getOrderDetail());
  }
  @override
  Widget build(BuildContext context) {
    return StreamProvider<Object>.value(
      value: widget.bloc.orderStream,
      initialData: null,
      catchError: (context,error){
        return error;
      },
      child: Consumer<Object>(
        builder: (context,data,child){
          if(data == null){
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if(data is RestError){
            return Center(
              child: Container(
                child: Text(data.message.toString()),
              ),
            );
          }
          if(data is Order){
            return Column(
              children: <Widget>[
                Expanded(
                  child: ProductListWidget(data.items),
                ),
                ConfirmInfoWidget(data.total),
              ],
            );
          }
          return Container();
        },
      ),
    );
  }
}

class ConfirmInfoWidget extends StatelessWidget {
  final double total;
  ConfirmInfoWidget(this.total);

  @override
  Widget build(BuildContext context) {
    return Consumer<CheckoutBloc>(
      builder: (context,bloc,child) {
        return Container(
          height: 170,
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                '${FlutterMoneyFormatter(
                  amount: total,
                  settings: MoneyFormatterSettings(
                    symbol: 'VND',
                    fractionDigits: 0,
                  ),
                ).output.symbolOnRight}',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: AppColor.blue,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              NormalButton(
                title: 'Confirm',
                onPressed: () {

                  bloc.event.add(ConfirmOrderEvent());
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class ProductListWidget extends StatelessWidget {
  final List<Product> productList;
  ProductListWidget(this.productList);

  @override
  Widget build(BuildContext context) {
    var bloc = Provider.of<CheckoutBloc>(context);
    productList.sort((p1,p2) => p1.price.compareTo(p2.price));
    return ListView.builder(
      itemCount: productList.length,
      itemBuilder: (context,index) => _buildRow(productList[index],bloc),
    );
  }

  Widget _buildRow(Product product,CheckoutBloc bloc){
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image.network(
                product.productImage,
                width: 90,
                height: 140,
                fit: BoxFit.fill,
              ),
            ),
            SizedBox(
              width: 15.0,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    product.productName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      height: 1.2,
                      color: AppColor.black,
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    'Price: ${FlutterMoneyFormatter(
                      amount: product.price,
                      settings: MoneyFormatterSettings(
                        symbol: 'VND',
                        fractionDigits: 0,
                      ),
                    ).output.symbolOnRight}',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                      color:AppColor.green,
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  _buildCartAction(product,bloc),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildCartAction(Product product,CheckoutBloc bloc){
  return Row(
    children: <Widget>[
      BtnCartAction(
        title: '-',
        onPressed: (){
          if(product.quantity == 1){
            return;
          }
          product.quantity -= 1;
          bloc.event.add(UpdateCartEvent(product: product));
        },),
      SizedBox(
        width: 15.0,
      ),
      Text(
        '${product.quantity}',
        style: TextStyle(
          fontSize: 15.0,
          fontWeight: FontWeight.bold,
          color: AppColor.red,
        ),
      ),
      SizedBox(
        width: 15.0,
      ),
      BtnCartAction(
        title: '+',
        onPressed: (){
          product.quantity += 1;
          bloc.event.add(UpdateCartEvent(product: product));
        },
      ),
    ],
  );
}
