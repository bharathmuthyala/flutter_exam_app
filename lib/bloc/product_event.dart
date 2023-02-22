part of 'product_bloc.dart';

abstract class ProductEvent {}

class ProductEventInitial extends ProductEvent {}

class ProductEventFetch extends ProductEvent {
  int pageIndex;

  ProductEventFetch({required this.pageIndex});
}

class ProductDetailsEventFetch extends ProductEvent {
  int productId;

  ProductDetailsEventFetch({required this.productId});
}
