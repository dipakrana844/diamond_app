import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practical_app/services/local_storage.dart';

import '../models/diamond_model.dart';

part 'diamond_event.dart';
part 'diamond_state.dart';

class DiamondBloc extends Bloc<DiamondEvent, DiamondState> {
  List<Diamond> diamonds = [];
  List<Diamond> cart = [];
  List<Diamond> filteredDiamonds = [];

  // Filter variables
  double? minCarat;
  double? maxCarat;
  String? lab;
  String? shape;
  String? color;
  String? clarity;

  // Sorting variables
  String? sortBy;
  bool? isAscending;

  DiamondBloc() : super(DiamondInitial()) {
    on<LoadDiamonds>(_onLoadDiamonds);
    on<FilterDiamonds>(_onFilterDiamonds);
    on<UpdateFilters>(_onUpdateFilters);
    on<UpdateSorting>(_onUpdateSorting);
    on<AddToCart>(_onAddToCart);
    on<RemoveFromCart>(_onRemoveFromCart);
    on<SortDiamonds>(_onSortDiamonds);
    on<ClearFilters>(_onClearFilters);

    _loadCart();
  }
  void _onUpdateSorting(UpdateSorting event, Emitter<DiamondState> emit) {
    sortBy = event.sortBy;
    isAscending = event.isAscending;

    if (state is DiamondLoaded) {
      final currentState = state as DiamondLoaded;
      emit(DiamondLoaded(
        diamonds: currentState.diamonds,
        cart: currentState.cart,
        minCarat: currentState.minCarat,
        maxCarat: currentState.maxCarat,
        lab: currentState.lab,
        shape: currentState.shape,
        color: currentState.color,
        clarity: currentState.clarity,
        sortBy: sortBy,
        isAscending: isAscending,
      ));
    }
  }

  // void _onUpdateFilters(UpdateFilters event, Emitter<DiamondState> emit) {
  //   // Update filter variables
  //   minCarat = event.minCarat;
  //   maxCarat = event.maxCarat;
  //   lab = event.lab;
  //   shape = event.shape;
  //   color = event.color;
  //   clarity = event.clarity;
  //
  //   emit(DiamondLoaded(
  //     diamonds: filteredDiamonds,
  //     cart: cart,
  //     minCarat: minCarat,
  //     maxCarat: maxCarat,
  //     lab: lab,
  //     shape: shape,
  //     color: color,
  //     clarity: clarity,
  //   ));
  // }
  void _onUpdateFilters(UpdateFilters event, Emitter<DiamondState> emit) {
    // Preserve existing filter values if the new value is null
    minCarat = event.minCarat ?? minCarat;
    maxCarat = event.maxCarat ?? maxCarat;
    lab = event.lab ?? lab;
    shape = event.shape ?? shape;
    color = event.color ?? color;
    clarity = event.clarity ?? clarity;

    emit(DiamondLoaded(
      diamonds: filteredDiamonds,
      cart: cart,
      minCarat: minCarat,
      maxCarat: maxCarat,
      lab: lab,
      shape: shape,
      color: color,
      clarity: clarity,
    ));
  }
/*  void _onUpdateFilters(UpdateFilters event, Emitter<DiamondState> emit) {
    final currentState = state is DiamondLoaded ? state as DiamondLoaded : null;

    emit(DiamondLoaded(
      diamonds: filteredDiamonds,
      cart: cart,
      minCarat: event.minCarat ?? currentState?.minCarat,
      maxCarat: event.maxCarat ?? currentState?.maxCarat,
      lab: event.lab ??
          (event.minCarat == null && event.maxCarat == null
              ? null
              : currentState?.lab),
      shape: event.shape ??
          (event.minCarat == null && event.maxCarat == null
              ? null
              : currentState?.shape),
      color: event.color ??
          (event.minCarat == null && event.maxCarat == null
              ? null
              : currentState?.color),
      clarity: event.clarity ??
          (event.minCarat == null && event.maxCarat == null
              ? null
              : currentState?.clarity),
    ));
  }*/

  Future<void> _loadCart() async {
    cart = await LocalStorage.loadCart();
    emit(DiamondLoaded(diamonds: diamonds, cart: cart));
  }

  Future<void> _saveCart() async {
    await LocalStorage.saveCart(cart);
  }

  // void _onLoadDiamonds(LoadDiamonds event, Emitter<DiamondState> emit) {
  //   diamonds = event.diamonds;
  //   emit(DiamondLoaded(diamonds: diamonds, cart: cart));
  // }
  void _onLoadDiamonds(LoadDiamonds event, Emitter<DiamondState> emit) {
    diamonds = event.diamonds;

    emit(DiamondLoaded(
      diamonds: diamonds,
      cart: cart,
      minCarat: minCarat, // Preserve previously selected values
      maxCarat: maxCarat,
      lab: lab,
      shape: shape,
      color: color,
      clarity: clarity,
    ));
  }

  void _onFilterDiamonds(FilterDiamonds event, Emitter<DiamondState> emit) {
    emit(DiamondLoading());
    filteredDiamonds = diamonds.where((diamond) {
      bool matches = true;

      if (event.minCarat != null && diamond.carat < event.minCarat!) {
        matches = false;
      }
      if (event.maxCarat != null && diamond.carat > event.maxCarat!) {
        matches = false;
      }
      if (event.lab != null && diamond.lab != event.lab) {
        matches = false;
      }
      if (event.shape != null && diamond.shape != event.shape) {
        matches = false;
      }
      if (event.color != null && diamond.color != event.color) {
        matches = false;
      }
      if (event.clarity != null && diamond.clarity != event.clarity) {
        matches = false;
      }

      return matches;
    }).toList();

    emit(DiamondLoaded(diamonds: filteredDiamonds, cart: cart));
  }

  void _onAddToCart(AddToCart event, Emitter<DiamondState> emit) {
    if (!cart.any((diamond) => diamond.lotId == event.diamond.lotId)) {
      cart.add(event.diamond);
      _saveCart();
      emit(DiamondLoaded(diamonds: filteredDiamonds, cart: cart));
    }
  }

  void _onRemoveFromCart(RemoveFromCart event, Emitter<DiamondState> emit) {
    cart.remove(event.diamond);
    _saveCart();
    emit(DiamondLoaded(diamonds: filteredDiamonds, cart: cart));
  }

  void _onSortDiamonds(SortDiamonds event, Emitter<DiamondState> emit) {
    if (state is DiamondLoaded) {
      final currentState = state as DiamondLoaded;
      List<Diamond> sortedDiamonds = List.from(currentState.diamonds);

      if (event.sortBy == 'finalPrice') {
        sortedDiamonds.sort(
          (a, b) => event.isAscending
              ? a.finalAmount.compareTo(b.finalAmount)
              : b.finalAmount.compareTo(a.finalAmount),
        );
      } else if (event.sortBy == 'carat') {
        sortedDiamonds.sort(
          (a, b) => event.isAscending
              ? a.carat.compareTo(b.carat)
              : b.carat.compareTo(a.carat),
        );
      }

      emit(DiamondLoaded(
        diamonds: sortedDiamonds,
        cart: currentState.cart,
        minCarat: currentState.minCarat,
        maxCarat: currentState.maxCarat,
        lab: currentState.lab,
        shape: currentState.shape,
        color: currentState.color,
        clarity: currentState.clarity,
      ));
    }
  }

  void _onClearFilters(ClearFilters event, Emitter<DiamondState> emit) {
    minCarat = null;
    maxCarat = null;
    lab = null;
    shape = null;
    color = null;
    clarity = null;

    emit(DiamondLoaded(
      diamonds: diamonds, // Keep the original diamonds list
      cart: cart,
      minCarat: minCarat,
      maxCarat: maxCarat,
      lab: lab,
      shape: shape,
      color: color,
      clarity: clarity,
    ));
  }
}
