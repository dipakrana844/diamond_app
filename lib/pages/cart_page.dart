import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/diamond_bloc.dart';
import '../widgets/diamond_card.dart';

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
        actions: [
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              Navigator.popUntil(context, (route) => route.isFirst);
            },
          ),
        ],
      ),
      body: BlocBuilder<DiamondBloc, DiamondState>(
        builder: (context, state) {
          if (state is DiamondLoaded) {
            final cart = state.cart;
            if (cart.isEmpty) {
              return Center(child: Text('Your cart is empty.'));
            }

            // Calculate summary
            double totalCarat =
                cart.fold(0, (sum, diamond) => sum + diamond.carat);
            double totalPrice =
                cart.fold(0, (sum, diamond) => sum + diamond.finalAmount);
            double averagePrice = totalPrice / cart.length;
            double averageDiscount = cart.fold(
                    0, (sum, diamond) => (sum + diamond.discount).toInt()) /
                cart.length;

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cart.length,
                    itemBuilder: (context, index) {
                      return DiamondCard(
                        diamond: cart[index],
                        showRemoveButton: true,
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Summary',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text('Total Carat: ${totalCarat.toStringAsFixed(2)}'),
                      Text('Total Price: \$${totalPrice.toStringAsFixed(2)}'),
                      Text(
                          'Average Price: \$${averagePrice.toStringAsFixed(2)}'),
                      Text(
                          'Average Discount: ${averageDiscount.toStringAsFixed(2)}%'),
                    ],
                  ),
                ),
              ],
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
