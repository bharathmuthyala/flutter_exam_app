import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_exam_app/models/product.dart';
import 'package:flutter_exam_app/repositories/product_repository.dart';

part 'product_event.dart';

part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository productRepository;

  ProductBloc({required this.productRepository}) : super(ProductsInitial()) {
    on<ProductEventFetch>(_fetchProducts);
    on<ProductDetailsEventFetch>(_fetchProductDetail);
  }

  _fetchProducts(ProductEventFetch event, Emitter<ProductState> emit) async {
    try {
      emit(ProductsLoading());
      final products = await productRepository.fetchProducts(event.pageIndex);
      emit(ProductsLoaded(products));
    } catch (ex) {
      emit(ProductsLoadingFailed());
    }
  }

  _fetchProductDetail(ProductDetailsEventFetch event, Emitter<ProductState> emit) async {
    try {
      emit(ProductsLoading());
      final product = await productRepository.fetchProductDetails(event.productId);
      emit(ProductDetailLoaded(product));
    } catch (ex) {
      emit(ProductsLoadingFailed());
    }
  }
}
