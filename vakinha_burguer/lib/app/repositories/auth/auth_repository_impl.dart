import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:vakinha_delivery/app/core/exceptions/repository_exceptios.dart';
import 'package:vakinha_delivery/app/core/exceptions/unautorized_exception.dart';
import 'package:vakinha_delivery/app/core/rest_client/custom_dio.dart';
import 'package:vakinha_delivery/app/models/auth_model.dart';
import 'package:vakinha_delivery/app/repositories/auth/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final CustomDio dio;

  AuthRepositoryImpl({required this.dio});

  @override
  Future<AuthModel> login(String email, String password) async {
    try {
      final result = await dio.unauth().post("/auth", data: {
        "email": email,
        "password": password,
      });

      return AuthModel.fromMap(result.data);
    } on DioError catch (e) {
      if (e.response?.statusCode == 403) {
        log("Permissão negada", error: e, stackTrace: e.stackTrace);

        throw UnautorizedExceeption();
      }

      log("Erro ao realizar login", error: e, stackTrace: e.stackTrace);

      throw RepositoryException(message: "Erro ao realizar login");
    }
  }

  @override
  Future<void> register(String name, String email, String password) async {
    try {
      await dio.unauth().post("/users", data: {
        "name": name,
        "email": email,
        "password": password,
      });
    } on DioError catch (e) {
      log("Erro ao registrar usuário", error: e, stackTrace: e.stackTrace);

      throw RepositoryException(message: "Erro ao registrar usuário");
    }
  }
}
