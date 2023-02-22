
part of 'product_bloc.dart';

abstract class ProductState{ }

class ProductsInitial extends ProductState { }

class ProductsLoading extends ProductState { }

class ProductsLoaded extends ProductState {

  List<Product>? products;

  ProductsLoaded(this.products);

}

class ProductDetailLoaded extends ProductState {

  Product product;

  ProductDetailLoaded(this.product);

}

class ProductsLoadingFailed extends ProductState { }