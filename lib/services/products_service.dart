
// el service se encarga de hacer la interaccion 

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'package:productos_app/models/product.dart';

class ProductsService extends ChangeNotifier {

  final String _baseUrl = 'flutter-varios-fee56-default-rtdb.firebaseio.com';
  final List<Product> products = [];

  bool isLoading = true;
  bool isSaving = false;
  late Product selectedProduct;

  final storage = const FlutterSecureStorage();

  // si tiene un archivo se actualiza la imagen
  File? newPictureFile;

  ProductsService() {
    loadProducts();
  }
  
  // Retorna la lista de productos
  Future<List<Product>> loadProducts() async {

    isLoading = true;
    notifyListeners();

    final url = Uri.https(_baseUrl, 'products.json', {
      'auth' : await storage.read(key: 'token') ?? ''
    });
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

  Future saveOrCreateProduct ( Product product ) async {
    isSaving = true;
    notifyListeners();

    if ( product.id == null ) {
      // Crear
      await createProduct(product);
    } else {
      // Actualizar
     await updateProduct(product);
    }

    isSaving = false;
    notifyListeners();
  }

  Future<String> updateProduct( Product product ) async {
    final url = Uri.https(_baseUrl, 'products/${product.id}.json', {
      'auth' : await storage.read(key: 'token') ?? ''
    });
    final resp = await http.put( url, body: product.toJson() );
    final decodedData = resp.body;

    // Actualizar el listado de productos
    final index = products.indexWhere((element) => element.id == product.id!);
    products[index] = product;
    
    return product.id!;
  }

  Future<String> createProduct( Product product ) async {
    final url = Uri.https(_baseUrl, 'products.json', {
      'auth' : await storage.read(key: 'token') ?? ''
    });
    final resp = await http.post( url, body: product.toJson() );
    final decodedData = json.decode(resp.body);

    product.id = decodedData['name'];

    // Actualizar el listado de productos
    products.add(product);
    
    return product.id!;
  }


  // actualiza la imagen tomada o seleccionada
  void updateSelectedProductImage( String path) {
    selectedProduct.picture = path;
    newPictureFile = File.fromUri( Uri(path: path) );

    notifyListeners();
  }

  // subir imagen
  Future<String?> uploadImage () async {

    if ( newPictureFile == null ) return null;

    isSaving = true;
    notifyListeners();

    final url = Uri.parse('https://api.cloudinary.com/v1_1/dojodxa2d/image/upload?upload_preset=s6ah8nqe');

    final imageUploadRequest = http.MultipartRequest( 'POST', url );

    final file = await http.MultipartFile.fromPath('file', newPictureFile!.path);

    imageUploadRequest.files.add(file);

    // dispara la petición
    final streamResponse = await imageUploadRequest.send();
    final resp = await http.Response.fromStream(streamResponse);

    if ( resp.statusCode != 200 && resp.statusCode != 201 ) {
      print('algo salio mal ');
      print( resp.body );
      return null;
    }

    newPictureFile = null;
    
    final decodedData = json.decode( resp.body );
    return decodedData['secure_url'];
    
  }

}