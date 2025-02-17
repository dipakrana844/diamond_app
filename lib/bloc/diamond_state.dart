part of "diamond_bloc.dart";

abstract class DiamondState {}

class DiamondInitial extends DiamondState {}

class DiamondLoading extends DiamondState {}

class DiamondLoaded extends DiamondState {
  final List<Diamond> diamonds;
  final List<Diamond> cart;
  final double? minCarat;
  final double? maxCarat;
  final String? lab;
  final String? shape;
  final String? color;
  final String? clarity;
  final String? sortBy;
  final bool? isAscending;

  DiamondLoaded({
    required this.diamonds,
    required this.cart,
    this.minCarat,
    this.maxCarat,
    this.lab,
    this.shape,
    this.color,
    this.clarity,
    this.sortBy,
    this.isAscending,
  });
}

class DiamondError extends DiamondState {}
