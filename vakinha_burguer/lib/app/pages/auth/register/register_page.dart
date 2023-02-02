import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vakinha_delivery/app/core/ui/base_state/base_state.dart';
import 'package:vakinha_delivery/app/core/ui/styles/text_style.dart';
import 'package:vakinha_delivery/app/core/ui/widgets/delivery_appbar.dart';
import 'package:vakinha_delivery/app/core/ui/widgets/delivery_button.dart';
import 'package:vakinha_delivery/app/pages/auth/register/register_controller.dart';
import 'package:vakinha_delivery/app/pages/auth/register/register_state.dart';
import 'package:validatorless/validatorless.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends BaseState<RegisterPage, RegisterController> {
  late final TextEditingController _name;
  late final TextEditingController _email;
  late final TextEditingController _password;

  late final GlobalKey<FormState> _formKey;

  @override
  void initState() {
    super.initState();

    _name = TextEditingController();
    _email = TextEditingController();
    _password = TextEditingController();

    _formKey = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterController, RegisterState>(
      listener: (context, state) {
        state.status.matchAny(
          any: hideLoader,
          register: showLoader,
          error: () {
            hideLoader();
            showError("Erro ao registrar usuário");
          },
          success: () {
            hideLoader();
            showSuccess("Cadastro realizado com sucesso");
            Navigator.of(context).pop();
          },
        );
      },
      child: Scaffold(
        appBar: DeliveryAppBar(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Cadastro",
                    style: context.textStyles.textTitle,
                  ),
                  Text(
                    "Preenca os campos abaixo para criar seu cadastro",
                    style: context.textStyles.textMedium.copyWith(
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 30),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Nome",
                    ),
                    validator: Validatorless.required("Nome obrigatório"),
                    controller: _name,
                  ),
                  const SizedBox(height: 30),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: "E-Mail",
                    ),
                    validator: Validatorless.multiple([
                      Validatorless.required("E-mail obrigátório"),
                      Validatorless.email("E-mail inválido"),
                    ]),
                    controller: _email,
                  ),
                  const SizedBox(height: 30),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Senha",
                    ),
                    obscureText: true,
                    validator: Validatorless.multiple([
                      Validatorless.required("Senha obrigátório"),
                      Validatorless.min(
                          6, "Senha deve contêr pelo menos 6 caracteres"),
                    ]),
                    controller: _password,
                  ),
                  const SizedBox(height: 30),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Confirmar senha",
                    ),
                    obscureText: true,
                    validator: Validatorless.multiple([
                      Validatorless.required("Confirmar senha obrigátório"),
                      Validatorless.compare(
                          _password, "Senha diferente de confirma senha")
                    ]),
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: DeliveryButton(
                      label: "Cadastrar",
                      width: double.infinity,
                      onPressed: () {
                        final isValid =
                            _formKey.currentState?.validate() ?? false;

                        if (isValid) {
                          controller.register(
                            _name.text,
                            _email.text,
                            _password.text,
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
