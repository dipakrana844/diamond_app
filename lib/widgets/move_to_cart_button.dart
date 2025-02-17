import 'package:flutter/material.dart';
import 'package:practical_app/pages/cart_page.dart';

class MoveToCartButton extends StatelessWidget {
  const MoveToCartButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CartPage()),
        );
      },
      child: Icon(Icons.shopping_cart),
      tooltip: 'Go to Cart',
    );
  }
}
