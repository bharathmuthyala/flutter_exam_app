
import 'package:flutter_exam_app/models/product.dart';
import 'package:hive_flutter/hive_flutter.dart';

class DBManager {

  DBManager._();

  static DBManager instance = DBManager._();

  Future<void> initialize() async {
    await Hive.initFlutter();
    Hive.registerAdapter(ProductAdapter());
  }

  void saveItem<HiveObject>(String key, List<HiveObject> items) async {
    var box = await Hive.openBox<HiveObject>(key);
    for (var element in items) {
      if(!box.values.contains(element)) {
        box.add(element);
      }
    }
    await box.close();
  }

  Future<List<HiveObject>> fetchItems<HiveObject>(String key) async {
    var box = await Hive.openBox<HiveObject>(key);
    final list = box.values.toList();
    await box.close();
    return list;
  }

}