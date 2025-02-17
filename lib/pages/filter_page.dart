import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practical_app/pages/cart_page.dart';
import 'package:practical_app/pages/result_page.dart';

import '../bloc/diamond_bloc.dart';

class FilterPage extends StatelessWidget {
  final List<String> labs;
  final List<String> shapes;
  final List<String> colors;
  final List<String> clarities;

  const FilterPage({
    Key? key,
    required this.labs,
    required this.shapes,
    required this.colors,
    required this.clarities,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<DiamondBloc>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      bloc.add(ClearFilters());
    });
    return Scaffold(
      appBar: AppBar(
        title: Text('Filter Diamonds'),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartPage()),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<DiamondBloc, DiamondState>(
        builder: (context, state) {
          final bloc = context.read<DiamondBloc>();

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Carat Range (From & To)
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(labelText: 'Carat From'),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          bloc.add(
                              UpdateFilters(minCarat: double.tryParse(value)));
                        },
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(labelText: 'Carat To'),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          bloc.add(
                              UpdateFilters(maxCarat: double.tryParse(value)));
                        },
                      ),
                    ),
                  ],
                ),

                // Lab Dropdown
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: 'Lab'),
                  value: state is DiamondLoaded ? state.lab : null,
                  items: labs.map((lab) {
                    return DropdownMenuItem(value: lab, child: Text(lab));
                  }).toList(),
                  onChanged: (value) {
                    bloc.add(UpdateFilters(lab: value));
                  },
                ),

                // Shape Dropdown
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: 'Shape'),
                  value: state is DiamondLoaded ? state.shape : null,
                  items: shapes.map((shape) {
                    return DropdownMenuItem(value: shape, child: Text(shape));
                  }).toList(),
                  onChanged: (value) {
                    bloc.add(UpdateFilters(shape: value));
                  },
                ),

                // Color Dropdown
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: 'Color'),
                  value: state is DiamondLoaded ? state.color : null,
                  items: colors.map((color) {
                    return DropdownMenuItem(value: color, child: Text(color));
                  }).toList(),
                  onChanged: (value) {
                    bloc.add(UpdateFilters(color: value));
                  },
                ),

                // Clarity Dropdown
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: 'Clarity'),
                  value: state is DiamondLoaded ? state.clarity : null,
                  items: clarities.map((clarity) {
                    return DropdownMenuItem(
                        value: clarity, child: Text(clarity));
                  }).toList(),
                  onChanged: (value) {
                    bloc.add(UpdateFilters(clarity: value));
                  },
                ),

                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Apply filters
                    bloc.add(FilterDiamonds(
                      minCarat: state is DiamondLoaded ? state.minCarat : null,
                      maxCarat: state is DiamondLoaded ? state.maxCarat : null,
                      lab: state is DiamondLoaded ? state.lab : null,
                      shape: state is DiamondLoaded ? state.shape : null,
                      color: state is DiamondLoaded ? state.color : null,
                      clarity: state is DiamondLoaded ? state.clarity : null,
                    ));

                    // Navigate to ResultPage
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ResultPage()),
                    );
                  },
                  child: Text('Search'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
