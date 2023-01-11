import 'package:flutter/material.dart';
import 'package:productos_app/models/models.dart';
import 'package:productos_app/screens/screens.dart';
import 'package:productos_app/services/auth_service.dart';
import 'package:productos_app/services/products_service.dart';
import 'package:productos_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
   
  const HomeScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {

    final productsService = Provider.of<ProductsService>(context);
    final authService = Provider.of<AuthService>(context, listen: false);

    if ( productsService.isLoading ) return const LoadingScreen();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Productos'),
        actions: [
          IconButton(
          icon: const Icon(Icons.logout_outlined),
          onPressed: () {
            authService.logout();
            Navigator.pushReplacementNamed(context, 'login');
          },
          ),
        ],
      ),
      // Listview.builder crea los widgets de forma peresoza cuando están por aparecer en pantalla
      body: ListView.builder(
        itemCount: productsService.products.length,
        itemBuilder: ( BuildContext context, int index) => GestureDetector(
          onTap: () {
            // con copy no se va a afectar al producto si se hace un cambio
            productsService.selectedProduct = productsService.products[index].copy();
            Navigator.pushNamed(context, 'product');
          },
          child: ProductCard(product:productsService.products[index])
          )
        ),
        floatingActionButton: FloatingActionButton(
        onPressed: () {
          // siempre debe haber un producto seleccionado
          productsService.selectedProduct = Product(available: false, name: '', price: 0);
          Navigator.pushNamed(context, 'product');
        },
        child: const Icon(Icons.add),
        ),
    );
  }
}