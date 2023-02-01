import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:vakinha_delivery/app/core/exceptions/repository_exceptios.dart';
import 'package:vakinha_delivery/app/core/rest_client/custom_dio.dart';
import 'package:vakinha_delivery/app/models/product_model.dart';
import 'package:vakinha_delivery/app/repositories/products/products_repository.dart';

class ProductsRepositoryImpl implements ProductsRepository {
  final CustomDio dio;

  ProductsRepositoryImpl({required this.dio});

  @override
  Future<List<ProductModel>> findAllProducts() async {
    final result = await dio.get("/products");

    try {
      return result.data
          .map<ProductModel>((p) => ProductModel.fromMap(p))
          .toList();
    } on DioError catch (e) {
      log("Erro ao buscar produtos", error: e, stackTrace: e.stackTrace);
      throw RepositoryException(message: "Erro ao buscar produtos");
    }
  }
}
