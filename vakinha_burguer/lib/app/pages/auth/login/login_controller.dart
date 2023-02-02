import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vakinha_delivery/app/core/exceptions/unautorized_exception.dart';
import 'package:vakinha_delivery/app/pages/auth/login/login_state.dart';
import 'package:vakinha_delivery/app/repositories/auth/auth_repository.dart';

class LoginController extends Cubit<LoginState> {
  final AuthRepository _authRepository;

  LoginController(this._authRepository) : super(const LoginState.initial());

  Future<void> login(String email, String password) async {
    emit(state.copyWith(status: LoginStatus.login));

    try {
      final authModel = await _authRepository.login(email, password);

      final sp = await SharedPreferences.getInstance();

      sp.setString("accessToken", authModel.accessToken);
      sp.setString("refreshToken", authModel.refreshToken);

      emit(state.copyWith(status: LoginStatus.success));
    } on UnautorizedExceeption catch (e, s) {
      log("Login ou senha inválidos", error: e, stackTrace: s);
      emit(
        state.copyWith(
          status: LoginStatus.error,
          message: "Login ou senha inválidos",
        ),
      );
    } catch (e, s) {
      log("Erro ao realizar login", error: e, stackTrace: s);
      emit(
        state.copyWith(
          status: LoginStatus.error,
          message: "Erro ao realizar login",
        ),
      );
    }
  }
}
