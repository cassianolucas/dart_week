import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vakinha_delivery/app/core/ui/base_state/base_state.dart';
import 'package:vakinha_delivery/app/core/ui/styles/text_style.dart';
import 'package:vakinha_delivery/app/core/ui/widgets/delivery_appbar.dart';
import 'package:vakinha_delivery/app/core/ui/widgets/delivery_button.dart';
import 'package:vakinha_delivery/app/pages/auth/login/login_controller.dart';
import 'package:vakinha_delivery/app/pages/auth/login/login_state.dart';
import 'package:validatorless/validatorless.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends BaseState<LoginPage, LoginController> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  late final GlobalKey<FormState> _formKey;

  @override
  void initState() {
    super.initState();

    _email = TextEditingController();
    _password = TextEditingController();

    _formKey = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginController, LoginState>(
      listener: (context, state) {
        state.status.matchAny(
          any: hideLoader,
          login: showLoader,
          loginError: () {
            hideLoader();
            showError(state.message!);
          },
          error: () {
            hideLoader();
            showError(state.message!);
          },
          success: () {
            hideLoader();

            Navigator.of(context).pop(true);
          },
        );
      },
      child: Scaffold(
        appBar: DeliveryAppBar(),
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Login", style: context.textStyles.textTitle),
                      const SizedBox(height: 30),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: "E-Mail",
                        ),
                        validator: Validatorless.multiple([
                          Validatorless.required("E-mail obrigatório"),
                          Validatorless.email("E-mail inálido"),
                        ]),
                        controller: _email,
                      ),
                      const SizedBox(height: 30),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: "Senha",
                        ),
                        validator: Validatorless.required(
                          "Necessário informar uma senha",
                        ),
                        controller: _password,
                        obscureText: true,
                      ),
                      const SizedBox(height: 30),
                      Center(
                        child: DeliveryButton(
                          label: "Entrar",
                          width: double.infinity,
                          onPressed: () {
                            final isValid =
                                _formKey.currentState?.validate() ?? false;

                            if (isValid) {
                              controller.login(_email.text, _password.text);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Não possuí uma conta?",
                        style: context.textStyles.textBold,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed("/auth/register");
                        },
                        child: Text(
                          "Cadastre-se",
                          style: context.textStyles.textBold.copyWith(
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
