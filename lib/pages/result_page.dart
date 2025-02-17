import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/diamond_bloc.dart';
import '../widgets/diamond_card.dart';
import '../widgets/move_to_cart_button.dart';

class ResultPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Results'),
        actions: [
          // Sorting dropdown
          BlocBuilder<DiamondBloc, DiamondState>(
            builder: (context, state) {
              final bloc = context.read<DiamondBloc>();
              String? selectedSortOption;

              if (state is DiamondLoaded) {
                selectedSortOption = state.sortBy != null
                    ? '${state.sortBy} (${state.isAscending! ? 'Asc' : 'Desc'})'
                    : null;
              }

              return DropdownButton<String>(
                value: selectedSortOption,
                hint: Text('Sort By'),
                items: [
                  'Final Price (Low to High)',
                  'Final Price (High to Low)',
                  'Carat Weight (Low to High)',
                  'Carat Weight (High to Low)',
                ].map((option) {
                  return DropdownMenuItem(
                    value: option,
                    child: Text(option),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    switch (value) {
                      case 'Final Price (Low to High)':
                        bloc.add(UpdateSorting(
                            sortBy: 'finalPrice', isAscending: true));
                        bloc.add(SortDiamonds(
                            sortBy: 'finalPrice', isAscending: true));
                        break;
                      case 'Final Price (High to Low)':
                        bloc.add(UpdateSorting(
                            sortBy: 'finalPrice', isAscending: false));
                        bloc.add(SortDiamonds(
                            sortBy: 'finalPrice', isAscending: false));
                        break;
                      case 'Carat Weight (Low to High)':
                        bloc.add(
                            UpdateSorting(sortBy: 'carat', isAscending: true));
                        bloc.add(
                            SortDiamonds(sortBy: 'carat', isAscending: true));
                        break;
                      case 'Carat Weight (High to Low)':
                        bloc.add(
                            UpdateSorting(sortBy: 'carat', isAscending: false));
                        bloc.add(
                            SortDiamonds(sortBy: 'carat', isAscending: false));
                        break;
                    }
                  }
                },
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<DiamondBloc, DiamondState>(
        builder: (context, state) {
          if (state is DiamondLoaded) {
            final diamonds = state.diamonds;
            if (diamonds.isEmpty) {
              return Center(
                child: Text(
                  'No data found.',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              );
            }

            return ListView.builder(
              itemCount: diamonds.length,
              itemBuilder: (context, index) {
                return DiamondCard(
                  diamond: diamonds[index],
                  showRemoveButton: false,
                  sortBy: state.sortBy,
                  isAscending: state.isAscending,
                );
              },
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: MoveToCartButton(),
    );
  }
}
