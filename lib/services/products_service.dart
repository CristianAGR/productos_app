
// el service se encarga de hacer la interaccion 

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:productos_app/models/product.dart';
import 'package:http/http.dart' as http;

class ProductsService extends ChangeNotifier {

  final String _baseUrl = 'flutter-varios-fee56-default-rtdb.firebaseio.com';
  final List<Product> products = [];
  bool isLoading = true;
  bool isSaving = false;
  late Product selectedProduct;

  ProductsService() {
    loadProducts();
  }
  
  // Retorna la lista de productos
  Future<List<Product>> loadProducts() async {

    isLoading = true;
    notifyListeners();

    final url = Uri.https(_baseUrl, 'products.json');
    final resp = await http.get( url );

    final Map<String, dynamic> productsMap = json.decode(resp.body);

    // pasar cada objeto en el mapa a un objeto de tipo Product, asignando el id en base al key
    productsMap.forEach((key, value) { 
      final tempProduct = Product.fromMap(value);
      tempProduct.id = key;
      // se agregan al arreglo de products
      products.add(tempProduct);
    });
    
    isLoading = false;
    notifyListeners();

    return products;
  }

  // TODO: hacer fetch de productos

  Future saveOrCreateProduct ( Product product ) async {
    isSaving = true;
    notifyListeners();

    if ( product.id == null ) {

    } else {
      // Actualizar
     await updateProduct(product);
    }

    isSaving = false;
    notifyListeners();
  }

  Future<String> updateProduct( Product product ) async {
    final url = Uri.https(_baseUrl, 'products/${product.id}.json');
    final resp = await http.put( url, body: product.toJson() );
    final decodedData = resp.body;

    // Actualizar el listado de productos
    final index = products.indexWhere((element) => element.id == product.id!);
    products[index] = product;
    
    return product.id!;
  }
}