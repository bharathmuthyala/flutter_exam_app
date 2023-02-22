import 'package:flutter_exam_app/bloc/product_bloc.dart';
import 'package:flutter_exam_app/exceptions/no_products_exception.dart';
import 'package:flutter_exam_app/models/product.dart';
import 'package:flutter_exam_app/repositories/product_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';

import 'product_bloc_test.mocks.dart';

@GenerateNiceMocks([MockSpec<ProductRepository>(), MockSpec<Product>()])
void main() {
  MockProductRepository? productRepository;
  ProductBloc? productBloc;
  MockProduct? product;

  setUp(() {
    product = MockProduct();
    productRepository = MockProductRepository();
    productBloc = ProductBloc(productRepository: productRepository!);
  });

  blocTest<ProductBloc, ProductState>(
    'Fetching Products Non empty Test',
    build: () => ProductBloc(productRepository: productRepository!),
    act: (bloc) {
      final list = List<Product>.empty(growable: true)..add(product!);
      when(productRepository?.fetchProducts(1)).thenAnswer((realInvocation) => Future.value(list));
      bloc.add(ProductEventFetch(pageIndex: 1));
    },
    expect: () {
      final list = List<Product>.empty(growable: true)..add(product!);
      return <ProductState>[
        ProductsLoading(),
        ProductsLoaded(list),
      ];
    },
  );

  blocTest<ProductBloc, ProductState>(
    'Fetching Products empty result Test',
    build: () => ProductBloc(productRepository: productRepository!),
    act: (bloc) {
      when(productRepository?.fetchProducts(1)).thenAnswer((realInvocation) => Future.value(List.empty()));
      bloc.add(ProductEventFetch(pageIndex: 1));
    },
    expect: () {
      return <ProductState>[
        ProductsLoading(),
        ProductsLoaded(List.empty()),
      ];
    },
  );

  blocTest<ProductBloc, ProductState>(
    'Fetching Products Exception Test',
    build: () => ProductBloc(productRepository: productRepository!),
    act: (bloc) {
      when(productRepository?.fetchProducts(1))
          .thenAnswer((realInvocation) => Future.value(throw NoProductsException()));
      bloc.add(ProductEventFetch(pageIndex: 1));
    },
    expect: () {
      return <ProductState>[
        ProductsLoading(),
        ProductsLoadingFailed()
      ];
    },
  );

  tearDown(() {
    productBloc?.close();
  });
}
