
import 'package:flutterappbookstore/base/base_event.dart';
import 'package:flutterappbookstore/shared/model/product.dart';

class UpdateCartEvent extends BaseEvent{
  Product product;

  UpdateCartEvent({this.product});
}