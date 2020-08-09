import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:flutterappbookstore/base/base_widget.dart';
import 'package:flutterappbookstore/data/remote/order_service.dart';
import 'package:flutterappbookstore/data/remote/product_service.dart';
import 'package:flutterappbookstore/data/repo/order_repo.dart';
import 'package:flutterappbookstore/data/repo/product_repo.dart';
import 'package:flutterappbookstore/event/add_to_cart_event.dart';
import 'package:flutterappbookstore/module/home/home_bloc.dart';
import 'package:flutterappbookstore/shared/app_color.dart';
import 'package:flutterappbookstore/shared/model/product.dart';
import 'package:flutterappbookstore/shared/model/rest_error.dart';
import 'package:flutterappbookstore/shared/model/shopping_cart.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PageContainer(
      title: 'Home',
      di: [
        Provider.value(value: ProductService()),
        Provider.value(value: OrderService()),
        ProxyProvider<ProductService,ProductRepo>(
          update: (context, productService, prev) => ProductRepo(productService: productService),
        ),
        ProxyProvider<OrderService,OrderRepo>(
          update: (context, orderService, prev) => OrderRepo(orderService: orderService),
        ),
      ],
      bloc: [],
      actions: <Widget>[ShoppingCartWidget()],
      child: ProductListWidget(),
    );
  }
}

class ShoppingCartWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value:HomeBloc.getInstance(
          productRepo: Provider.of(context),
          orderRepo: Provider.of(context),
      ),
      child: CartWidget(),
    );
  }
}

class CartWidget extends StatefulWidget {
  @override
  _CartWidgetState createState() => _CartWidgetState();
}

class _CartWidgetState extends State<CartWidget> {
  int value;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    var bloc = Provider.of<HomeBloc>(context,listen: false);
    bloc.getShoppingCartInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeBloc>(
        builder: (context, bloc, child) => StreamProvider<Object>.value(
          value: bloc.shoppingCartStream,
          initialData: null,
          catchError: (context,error){
            return error;
          },
          child: Consumer<Object>(
            builder: (context, data, child) {
              if(data == null || data is RestError){
                return Container(
                  margin: EdgeInsets.only(top: 15,right: 20),
                  child: Icon(Icons.shopping_cart),
                );
              }

              var cart = data as ShoppingCart;
              //print(cart.total);
              return GestureDetector(
                onTap: (){
                  if(data == null){
                    return;
                  }
                  Navigator.pushNamed(context, '/checkout',arguments: cart.orderId);
                },
                child: Container(
                  margin: EdgeInsets.only(top: 15,right: 20),
                  child: Badge(
                    badgeContent: Text(
                      '${cart.total}',
                      style: TextStyle(color: AppColor.white,fontWeight: FontWeight.bold),
                    ),
                    child: Icon(Icons.shopping_cart),
                  ),
                ),
              );
            },
          ),
        ),
      );

  }
}


class ProductListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: HomeBloc.getInstance(
          productRepo: Provider.of(context),
          orderRepo: Provider.of(context),
      ),
      child: Consumer<HomeBloc>(
        builder: (context, bloc, child) => Container(
          child: StreamProvider<Object>.value(
            value: bloc.getProductList(),
            initialData: null,
            catchError: (context,error){
              return error;
            },
            child: Consumer<Object>(
              builder:(context, data, child) {
                if(data == null){
                  return Center(
                    child: CircularProgressIndicator(
                      backgroundColor: AppColor.green,
                    ),
                  );
                }
                if(data is RestError){
                  return Center(
                    child: Container(
                      child: Text(
                        data.message,
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  );
                }
                var products = data as List<Product>;
                return ListView.builder(
                  shrinkWrap: true,
                itemBuilder: (context,index) {
                  return _buildRow(bloc,products[index]);
                },
                itemCount: products.length,
              );
              },
            ),
          ),
        ),
      ),
    );
  }
}

Widget _buildRow(HomeBloc bloc, Product product) {
  return Container(
    height: 180,
    child: Card(
      elevation: 3.0,
      child: Container(
        padding: EdgeInsets.all(15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(product.productImage,width: 100,height: 150,),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 15,left: 15),
                    height: 50,
                    child: Text(
                      '${product.productName}',
                      style: TextStyle(
                        fontSize: 20,
                        color: AppColor.black,
                      ),
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.only(top: 5),
                    child: Text(
                      'Quantity: ${product.quantity}',
                      style: TextStyle(
                        fontSize: 17,
                        color: AppColor.blue,
                      ),
                    ),
                  ),

                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(top: 5,left: 15),
                          child: Text(
                            '${FlutterMoneyFormatter(settings: MoneyFormatterSettings(
                              symbol: 'VND',
                              fractionDigits: 0,
                            ),amount: product.price).output.symbolOnRight}',
                            style: TextStyle(
                              fontSize: 17,
                              color: AppColor.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(right: 15),
                          child: FlatButton(
                            padding: EdgeInsets.all(10),
                            color: AppColor.yellow,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(4),
                                topRight: Radius.circular(20),
                                bottomRight: Radius.circular(20),
                                bottomLeft: Radius.circular(20),
                              ),
                            ),
                            onPressed: (){
                              bloc.event.add(AddToCartEvent(product));
                            },
                            child: Text(
                              ' Buy now ',
                              style: TextStyle(color: AppColor.black),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}



