import 'package:flutter/material.dart';
import 'package:productos_app/widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
   
  const HomeScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Productos'),
      ),
      // Listview.builder crea los widgets de forma peresoza cuando están por aparecer en pantalla
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: ( BuildContext context, int index) => GestureDetector(
          onTap: () => Navigator.pushNamed(context, 'product'),
          child: const ProductCard()
          )
        ),
        floatingActionButton: FloatingActionButton(onPressed: () {
          
        },
        child: const Icon(Icons.add),
        ),
    );
  }
}