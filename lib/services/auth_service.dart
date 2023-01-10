import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AuthService extends ChangeNotifier {

  final String _baseUrl = 'https://identitytoolkit.googleapis.com';
  final String _firebaseToken = 'AIzaSyB3P-vA9FGW4j9wzpbqkt7hIjHESo-VeVA';

  // para mandar un post se necesita un mapa con la info del body
  Future<String?> createUser( String email, String password ) async {

    // info del post
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password
    };

    // url
    final url = Uri.https(_baseUrl, 'v1/accounts:signUp', {
      'key': _firebaseToken
    });

    // petición http
    final resp = await http.post(url, body: json.encode(authData));
    final Map<String, dynamic> decodedResp = json.decode(resp.body);

    print(decodedResp);
  }


}