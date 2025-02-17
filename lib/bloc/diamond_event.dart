part of "diamond_bloc.dart";

abstract class DiamondEvent {}

class LoadDiamonds extends DiamondEvent {
  final List<Diamond> diamonds;
  LoadDiamonds(this.diamonds);
}

class FilterDiamonds extends DiamondEvent {
  final double? minCarat;
  final double? maxCarat;
  final String? lab;
  final String? shape;
  final String? color;
  final String? clarity;

  FilterDiamonds({
    this.minCarat,
    this.maxCarat,
    this.lab,
    this.shape,
    this.color,
    this.clarity,
  });
}

class UpdateFilters extends DiamondEvent {
  final double? minCarat;
  final double? maxCarat;
  final String? lab;
  final String? shape;
  final String? color;
  final String? clarity;

  UpdateFilters({
    this.minCarat,
    this.maxCarat,
    this.lab,
    this.shape,
    this.color,
    this.clarity,
  });
}

class AddToCart extends DiamondEvent {
  final Diamond diamond;
  AddToCart(this.diamond);
}

class RemoveFromCart extends DiamondEvent {
  final Diamond diamond;
  RemoveFromCart(this.diamond);
}

class SortDiamonds extends DiamondEvent {
  final String sortBy;
  final bool isAscending;

  SortDiamonds({required this.sortBy, required this.isAscending});
}

class UpdateSorting extends DiamondEvent {
  final String? sortBy;
  final bool? isAscending;

  UpdateSorting({this.sortBy, this.isAscending});
}

class ClearFilters extends DiamondEvent {}
