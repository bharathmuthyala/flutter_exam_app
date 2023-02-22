import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_exam_app/bloc/product_bloc.dart';
import 'package:flutter_exam_app/repositories/product_repository.dart';
import 'package:flutter_exam_app/routes.dart';
import 'package:flutter_exam_app/widgets/product_detail.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../api_constants.dart';
import '../models/product.dart';

class ProductListWidget extends StatefulWidget {
  const ProductListWidget({Key? key}) : super(key: key);

  @override
  State<ProductListWidget> createState() => _ProductListWidgetState();
}

class _ProductListWidgetState extends State<ProductListWidget> {
  final PagingController<int, Product> _pagingController = PagingController(firstPageKey: 0);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final productBloc = ProductBloc(productRepository: RepositoryProvider.of<ProductRepository>(context));
    _pagingController.addPageRequestListener((pageKey) {
      productBloc.add(ProductEventFetch(pageIndex: pageKey));
    });
    return BlocProvider(
      create: (context) => productBloc,
      child: Scaffold(
        appBar: _appBar(),
        body: BlocConsumer<ProductBloc, ProductState>(
          listenWhen: (previous, current) {
            return (current is ProductsLoaded);
          },
          listener: (context, state) {
            if (state is ProductsLoaded) {
              if (state.products?.isNotEmpty == true) {
                final totalItems = ((_pagingController.itemList?.length ?? 0) + (state.products?.length ?? 0));
                _pagingController.appendPage(state.products ?? [], totalItems ~/ PAGE_SIZE);
              }
            }
          },
          buildWhen: (previous, current) {
            return (current is ProductsInitial) || (current is ProductsLoaded);
          },
          builder: (context, state) {
            if (state is ProductsInitial) {
              return _productsList();
            } else if (state is ProductsLoading) {
              return _loadingWidget();
            } else if (state is ProductsLoaded) {
              return _productsList();
            } else {
              return _errorWidget();
            }
          },
        ),
      ),
    );
  }

  AppBar _appBar() => AppBar(
        title: const Text("Products"),
      );

  Widget _loadingWidget() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _productsList() {
    return PagedListView<int, Product>.separated(
      key: const Key("products_list"),
      pagingController: _pagingController,
      builderDelegate: PagedChildBuilderDelegate<Product>(
        itemBuilder: (context, item, index) {
          return _productListItem(item);
        },
      ),
      separatorBuilder: (context, index) => _separator(),
    );
  }

  Widget _separator() => Container(
        height: 1,
        color: Colors.black12,
        margin: const EdgeInsets.all(8),
      );

  Widget _productListWidget(List<Product> products) {
    return ListView.separated(
      itemBuilder: (context, index) {
        return _productListItem(products[index]);
      },
      itemCount: products.length,
      separatorBuilder: (context, index) {
        return Container(
          height: 1,
          color: Colors.black12,
          margin: const EdgeInsets.all(8),
        );
      },
    );
  }

  Widget _errorWidget() {
    return const Center(
      key: Key('error_widget'),
      child: Text("Failed to Load data!!"),
    );
  }

  Widget _productListItem(Product product) {
    return ListTile(
      key: Key("item_${product.id}"),
      leading: (product.thumbnail ?? "").isNotEmpty
          ? Image.network(
              "${product.thumbnail}" ?? "",
              width: 100,
              height: 70,
              fit: BoxFit.fill,
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.image_not_supported_rounded,
              ),
            )
          : const SizedBox(),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            product.title ?? "",
            textAlign: TextAlign.start,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            product.description ?? "",
            textAlign: TextAlign.start,
            style: const TextStyle(fontSize: 14),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              "Category: ${product.category}",
              textAlign: TextAlign.start,
              style: const TextStyle(fontSize: 13),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 4,
            ),
            child: Text(
              "Price: ${product.price}",
              textAlign: TextAlign.start,
              style: const TextStyle(fontSize: 13),
            ),
          ),
        ],
      ),
      trailing: const Icon(Icons.chevron_right_outlined),
      onTap: () => _navigateToDetail(product),
    );
  }

  void _navigateToDetail(Product product) =>
      Navigator.pushNamed(context, PATH_PRODUCT_DETAIL, arguments: ProductDetailArguments(productId: product.id ?? 0));

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}
