import 'package:flutter/material.dart';
import 'package:productos_app/models/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal:  20),
      child: Container(
        margin: const EdgeInsets.only(top: 30, bottom: 10),
        width: double.infinity,
        height: 400,
        decoration: _cardBorders(),
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [

            _BackgroundImage( url: product.picture ),

            _ProductDetails(id:  product.id!, name: product.name,),

            Positioned(
              top: 0,
              right: 0,
              child: _PriceTag(price: product.price)
            ),

            // mostrar de manera condicional
            if ( !product.available )
            Positioned(
              top: 0,
              left: 0,
              child: _NotAvailable(available: product.available,)
            )
          ],
        ),
      ),
    );
  }

  BoxDecoration _cardBorders() => BoxDecoration(
    color: Colors.amber,
    borderRadius: BorderRadius.circular(25),
    boxShadow: const [
      BoxShadow(
      color: Colors.black12,
      offset: Offset(0, 5),
      blurRadius: 10
    )
    ]
  );
}

class _NotAvailable extends StatelessWidget {
  final bool available;
  const _NotAvailable({
    Key? key, required this.available,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
     final String isAvailable;
    if (available) {
      isAvailable = 'Disponible';
    }else {
      isAvailable = 'No disponible';
    }
    return Container(
      width: 100,
      height: 70,
      decoration: const BoxDecoration( color: Colors.yellow,
      borderRadius: BorderRadius.only( topLeft: Radius.circular(25), bottomRight: Radius.circular(25))
      ),
      child:   FittedBox(
        fit: BoxFit.contain,
        child: Padding(
          padding: const EdgeInsets.symmetric( horizontal: 10 ),
          child: Text(isAvailable, style: const TextStyle( color: Colors.white, fontSize: 20),),
          ),
      ),
    );
  }
}

class _PriceTag extends StatelessWidget {
  final double price;
  const _PriceTag({
    Key? key, required this.price,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 70,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: Colors.indigo,
        borderRadius: BorderRadius.only( topRight: Radius.circular(25), bottomLeft: Radius.circular(25))
      ),
      child:  FittedBox(
        fit: BoxFit.contain,
        child: Padding(
          padding: const EdgeInsets.symmetric( horizontal: 10 ),
          child:  Text('\$$price', style: const TextStyle( color: Colors.white, fontSize: 20),)
          ),
      ),
    );
  }
}

class _ProductDetails extends StatelessWidget {
  final String id;
  final String name;
  const _ProductDetails({
    Key? key, required this.id, required this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only( right: 50),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        width: double.infinity,
        height: 70,
        decoration: _buildBoxDecorationn(),
        child: Column(
          crossAxisAlignment:  CrossAxisAlignment.start,
          children:  [
            Text(name, 
            style: const TextStyle( fontSize:  20, color: Colors.white, fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            ),
            Text('Id: $id', 
            style: const TextStyle( fontSize:  15, color: Colors.white),
            )
          ],
        ),
      ),
    );
  }

  BoxDecoration _buildBoxDecorationn() => const BoxDecoration(
    color: Colors.indigo,
    borderRadius: BorderRadius.only( bottomLeft:  Radius.circular(25), topRight: Radius.circular(25))
  );
}

class _BackgroundImage extends StatelessWidget {
  final String? url;
  const _BackgroundImage({
    Key? key, this.url,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: SizedBox(
        width: double.infinity,
        height: 400,
        child: url == null || url == ''
        ? const Image(image: AssetImage('assets/no-image.png'),
          fit: BoxFit.cover,)
        : FadeInImage(
          // TODO: fix productos cuando no hay imagen
          placeholder: const AssetImage('assets/jar-loading.gif'),
          image: NetworkImage(url!),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}