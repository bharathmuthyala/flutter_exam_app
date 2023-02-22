part of 'product_bloc.dart';

@immutable
abstract class ProductState extends Equatable {}

class ProductsInitial extends ProductState {
  @override
  List<Object?> get props => [];
}

class ProductsLoading extends ProductState {
  @override
  List<Object?> get props => [];
}

class ProductsLoaded extends ProductState {
  final List<Product>? products;

  ProductsLoaded(this.products);

  @override
  List<Object?> get props => [products];
}

class ProductDetailLoaded extends ProductState {
  final Product product;

  ProductDetailLoaded(this.product);

  @override
  List<Object?> get props => [];
}

class ProductsLoadingFailed extends ProductState {
  @override
  List<Object?> get props => [];
}
