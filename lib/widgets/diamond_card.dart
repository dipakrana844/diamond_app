import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/diamond_bloc.dart';
import '../models/diamond_model.dart';

class DiamondCard extends StatelessWidget {
  final Diamond diamond;
  final bool showRemoveButton;
  final String? sortBy;
  final bool? isAscending;

  const DiamondCard({
    Key? key,
    required this.diamond,
    this.showRemoveButton = false,
    this.sortBy,
    this.isAscending,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(12.0),
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            bool isWide = constraints.maxWidth > 600;
            double fontSize = isWide ? 16 : 14;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (sortBy != null)
                  Text(
                    'Sorted by: $sortBy (${isAscending! ? 'Asc' : 'Desc'})',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                SizedBox(height: 8),
                _buildSection([
                  _buildBoldText("Lot ID: ", diamond.lotId, fontSize),
                  _buildBoldText("Size: ", "${diamond.size} Carat", fontSize),
                  _buildBoldText("Carat: ", "${diamond.carat}", fontSize),
                  _buildBoldText("Lab: ", diamond.lab, fontSize),
                  _buildBoldText("Shape: ", diamond.shape, fontSize),
                ], isWide),
                Divider(),
                _buildSection([
                  _buildBoldText("Color: ", diamond.color, fontSize),
                  _buildBoldText("Clarity: ", diamond.clarity, fontSize),
                  _buildBoldText("Cut: ", diamond.cut, fontSize),
                  _buildBoldText("Polish: ", diamond.polish, fontSize),
                  _buildBoldText("Symmetry: ", diamond.symmetry, fontSize),
                  _buildBoldText(
                    "Fluorescence: ",
                    diamond.fluorescence,
                    fontSize,
                  ),
                ], isWide),
                Divider(),
                _buildSection([
                  _buildBoldText(
                    "Per Carat Rate: ",
                    "\$${diamond.perCaratRate.toStringAsFixed(2)}",
                    fontSize,
                  ),
                  _buildBoldText(
                    "Final Amount: ",
                    "\$${diamond.finalAmount.toStringAsFixed(2)}",
                    fontSize,
                  ),
                ], isWide),
                Divider(),
                _buildText("Key To Symbol: ", diamond.keyToSymbol, fontSize),
                _buildText("Lab Comment: ", diamond.labComment, fontSize),
                SizedBox(height: 12.0),
                isWide
                    ? _buildDesktopActions(context)
                    : _buildMobileActions(context),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSection(List<Widget> items, bool isWide) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Wrap(
        spacing: isWide ? 16.0 : 8.0,
        runSpacing: 4.0,
        children: items,
      ),
    );
  }

  Widget _buildBoldText(String key, String value, double fontSize) {
    return RichText(
      text: TextSpan(
        style: TextStyle(fontSize: fontSize, color: Colors.black),
        children: [
          TextSpan(text: key, style: TextStyle(fontWeight: FontWeight.bold)),
          TextSpan(text: value),
        ],
      ),
    );
  }

  Widget _buildText(String key, String value, double fontSize) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: RichText(
        text: TextSpan(
          style: TextStyle(fontSize: fontSize, color: Colors.black),
          children: [
            TextSpan(text: key, style: TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopActions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (!showRemoveButton)
          ElevatedButton.icon(
            icon: Icon(Icons.add_shopping_cart),
            label: Text("Add to Cart"),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            ),
            onPressed: () {
              context.read<DiamondBloc>().add(AddToCart(diamond));
            },
          ),
        if (showRemoveButton)
          ElevatedButton.icon(
            icon: Icon(Icons.remove_shopping_cart),
            label: Text("Remove from Cart"),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            ),
            onPressed: () {
              _showRemoveFromCartDialog(context, diamond);
            },
          ),
      ],
    );
  }

  Widget _buildMobileActions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (!showRemoveButton)
          IconButton(
            icon: Icon(Icons.add_shopping_cart),
            onPressed: () => _showAddToCartDialog(context, diamond),
          ),
        if (showRemoveButton)
          IconButton(
            icon: Icon(Icons.remove_shopping_cart),
            onPressed: () {
              _showRemoveFromCartDialog(context, diamond);
            },
          ),
      ],
    );
  }

  void _showAddToCartDialog(BuildContext context, Diamond diamond) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add to Cart'),
          content:
              Text('Are you sure you want to add this diamond to your cart?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                context.read<DiamondBloc>().add(AddToCart(diamond));
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Added to cart!')),
                );
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _showRemoveFromCartDialog(BuildContext context, Diamond diamond) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Remove from Cart'),
          content: Text(
              'Are you sure you want to remove this diamond from your cart?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                context.read<DiamondBloc>().add(RemoveFromCart(diamond));
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Removed from cart!')),
                );
              },
              child: Text('Remove'),
            ),
          ],
        );
      },
    );
  }
}
