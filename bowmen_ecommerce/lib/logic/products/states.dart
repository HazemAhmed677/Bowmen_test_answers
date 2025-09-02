import 'package:equatable/equatable.dart';

import '../../models/all_app_models.dart';

abstract class ProductsState extends Equatable {
  const ProductsState();

  @override
  List<Object> get props => [];
}

class ProductsInitial extends ProductsState {}

class ProductsLoading extends ProductsState {}

class ProductsLoaded extends ProductsState {
  final List<Product> products;
  final bool isFromCache;

  const ProductsLoaded({required this.products, this.isFromCache = false});

  @override
  List<Object> get props => [products, isFromCache];
}

class ProductsError extends ProductsState {
  final String message;

  const ProductsError(this.message);

  @override
  List<Object> get props => [message];
}
