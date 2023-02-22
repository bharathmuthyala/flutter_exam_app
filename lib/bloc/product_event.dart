part of 'product_bloc.dart';

@immutable
abstract class ProductEvent {}

class ProductEventInitial extends ProductEvent {}

class ProductEventFetch extends ProductEvent {
  final int pageIndex;

  ProductEventFetch({required this.pageIndex});
}

class ProductDetailsEventFetch extends ProductEvent {
  final int productId;

  ProductDetailsEventFetch({required this.productId});
}
