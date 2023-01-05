import 'package:flutter/material.dart';

// ChangeNotifier nos permite usar la clase en un provider
class LoginFormProvider extends ChangeNotifier {

// Referencia a el formulario
  GlobalKey<FormState> formKey = GlobalKey();

  String email = '';
  String password = '';

  bool isValidForm() {

    print(formKey.currentState?.validate());

    // valida el estado del form que cuente con la key
    return formKey.currentState?.validate() ?? false;
  }

}