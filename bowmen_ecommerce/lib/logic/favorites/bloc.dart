import 'package:bowmen_ecommerce/logic/favorites/event.dart';
import 'package:bowmen_ecommerce/logic/favorites/states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repo/all_app_repos.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final FavoritesRepository favoritesRepository;

  FavoritesBloc({required this.favoritesRepository})
    : super(FavoritesInitial()) {
    on<LoadFavorites>(_onLoadFavorites);
    on<ToggleFavorite>(_onToggleFavorite);
  }

  Future<void> _onLoadFavorites(
    LoadFavorites event,
    Emitter<FavoritesState> emit,
  ) async {
    final favorites = await favoritesRepository.getFavorites();
    emit(FavoritesLoaded(favorites));
  }

  Future<void> _onToggleFavorite(
    ToggleFavorite event,
    Emitter<FavoritesState> emit,
  ) async {
    final currentState = state;
    if (currentState is FavoritesLoaded) {
      final favorites = Set<int>.from(currentState.favoriteIds);

      if (favorites.contains(event.productId)) {
        await favoritesRepository.removeFavorite(event.productId);
        favorites.remove(event.productId);
      } else {
        await favoritesRepository.addFavorite(event.productId);
        favorites.add(event.productId);
      }

      emit(FavoritesLoaded(favorites));
    }
  }
}
