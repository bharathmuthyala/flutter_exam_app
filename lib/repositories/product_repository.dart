
import 'dart:convert';

import 'package:flutter_exam_app/exceptions/no_products_exception.dart';
import 'package:flutter_exam_app/localdb/db_manager.dart';

import '../api_constants.dart';
import '../db_constants.dart';
import '../models/product.dart';
import 'package:http/http.dart' as http;

class ProductRepository {

  final String baseUrl = 'https://dummyjson.com';

  Future<List<Product>> fetchProducts(int pageIndex) async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/$FETCH_PRODUCTS?limit=$PAGE_SIZE&skip=${pageIndex*PAGE_SIZE}"));
      if(response.statusCode != 200) {
        return _cachedProducts(pageIndex);
      }
      final json = jsonDecode(response.body);
      List<dynamic> productsArrayJson = json['products'];
      final products = productsArrayJson.map((productJson) => Product.fromJson(productJson)).toList();
      DBManager.instance.saveItem<Product>(dbProductsKey, products);
      return products;
    }catch(ex) {
      return _cachedProducts(pageIndex);
    }
  }

  Future<List<Product>> _cachedProducts(int pageIndex) async {
    final values = await DBManager.instance.fetchItems<Product>(dbProductsKey);
    return values.skip(PAGE_SIZE * pageIndex).take(PAGE_SIZE).toList();
  }

  Future<Product> _cachedProduct(int productId) async {
    final values = await DBManager.instance.fetchItems<Product>(dbProductsKey);
    return values.firstWhere((element) => element.id == productId);
  }

  Future<Product> fetchProductDetails(int productId) async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/$FETCH_PRODUCT_DETAILS/$productId"));
      if(response.statusCode != 200) {
        throw NoProductsException();
      }
      final json = jsonDecode(response.body);
      return Product.fromJson(json);
    } catch(ex) {
      return _cachedProduct(productId);
    }
  }
}