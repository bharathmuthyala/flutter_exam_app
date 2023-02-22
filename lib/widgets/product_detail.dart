import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_exam_app/bloc/product_bloc.dart';
import 'package:flutter_exam_app/db_constants.dart';
import 'package:flutter_exam_app/localdb/db_manager.dart';
import 'package:flutter_exam_app/models/product.dart';
import 'package:flutter_exam_app/repositories/product_repository.dart';

class ProductDetailArguments {
  int productId;

  ProductDetailArguments({required this.productId});
}

class ProductDetail extends StatelessWidget {
  ProductDetail({Key? key}) : super(key: key);

  late double screenWidth;
  late ScrollController _imageGalleryController;

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    final productDetailArguments = ModalRoute.of(context)?.settings.arguments as ProductDetailArguments;
    return BlocProvider(
      create: (context) => ProductBloc(productRepository: RepositoryProvider.of<ProductRepository>(context)),
      child: Scaffold(
        key: const Key("product_detail"),
        appBar: _appBar(),
        body: BlocBuilder<ProductBloc, ProductState>(
          buildWhen: (previous, current) {
            return (current is ProductsLoading) || (current is ProductsInitial) || (current is ProductDetailLoaded);
          },
          builder: (context, state) {
            if (state is ProductsInitial) {
              context.read<ProductBloc>().add(ProductDetailsEventFetch(productId: productDetailArguments.productId));
              return const SizedBox();
            } else if (state is ProductsLoading) {
              return _loadingWidget();
            } else if (state is ProductDetailLoaded) {
              return _productDetail(state.product);
            }
            return Container();
          },
        ),
      ),
    );
  }

  AppBar _appBar() => AppBar(
        title: const Text("Product Detail"),
      );

  Widget _loadingWidget() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _productDetail(Product product) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _imageGallery(product.images ?? []),
        Padding(
            padding: const EdgeInsets.all(8),
            child: Text(product.title ?? "",
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.start)),
        Padding(
            padding: const EdgeInsets.all(8),
            child: Text(product.description ?? "",
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal), textAlign: TextAlign.start)),
        _infoItem("Brand", product.brand ?? ""),
        _infoItem("Category", product.category ?? ""),
        _infoItem("Price", product.price.toString()),
        _infoItem("Discount", "${product.discountPercentage.toString()}%"),
        _infoItem("Rating", product.rating.toString()),
        _infoItem("Stock", product.stock.toString()),
      ],
    );
  }

  Widget _imageGallery(List<String> images) {
    _imageGalleryController = ScrollController();
    return Stack(
      children: [
        SizedBox(
          height: screenWidth * 0.7,
          child: ListView.builder(
            controller: _imageGalleryController,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return Image.network(
                images[index],
                fit: BoxFit.cover,
                width: screenWidth,
                errorBuilder: (context, error, stackTrace) => SizedBox(
                  width: screenWidth,
                  child: const Icon(Icons.image_not_supported_rounded),
                ),
                filterQuality: FilterQuality.high,
              );
            },
            itemCount: images.length,
            physics: const PageScrollPhysics(),
          ),
        ),
        Positioned(
          bottom: 0,
          top: 0,
          child: IconButton(
            icon: const Icon(Icons.arrow_circle_left),
            onPressed: () => {
              if (_imageGalleryController.offset != 0)
                {
                  _imageGalleryController.animateTo(_imageGalleryController.offset - screenWidth,
                      duration: const Duration(milliseconds: 200), curve: Curves.easeIn),
                }
            },
            color: Colors.blue.shade200,
            iconSize: 40,
          ),
        ),
        Positioned(
          bottom: 0,
          top: 0,
          right: 0,
          child: IconButton(
            icon: const Icon(Icons.arrow_circle_right),
            onPressed: () => {
              if (_imageGalleryController.offset < ((images.length - 1) * screenWidth))
                {
                  _imageGalleryController.animateTo(_imageGalleryController.offset + screenWidth,
                      duration: const Duration(milliseconds: 200), curve: Curves.easeIn),
                }
            },
            color: Colors.blue.shade200,
            iconSize: 40,
          ),
        ),
      ],
    );
  }

  Widget _infoItem(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
      child: Row(
        children: [
          Text(
            "$title:",
            textAlign: TextAlign.start,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            width: 8,
          ),
          Text(
            description,
            textAlign: TextAlign.start,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
          )
        ],
      ),
    );
  }

}
