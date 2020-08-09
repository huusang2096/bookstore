import 'package:flutterappbookstore/base/base_event.dart';
import 'package:flutterappbookstore/shared/model/product.dart';

class AddToCartEvent extends BaseEvent{
  Product product;

  AddToCartEvent(this.product);
}