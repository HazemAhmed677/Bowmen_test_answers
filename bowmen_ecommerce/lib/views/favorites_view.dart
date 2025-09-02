// lib/screens/favorites_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../logic/auth/bloc.dart';
import '../logic/auth/events.dart';
import '../logic/favorites/bloc.dart';
import '../logic/favorites/event.dart';
import '../logic/favorites/states.dart';
import '../logic/products/bloc.dart';
import '../logic/products/events.dart';
import '../logic/products/states.dart';
import '../widgets/custom_error_widget.dart';
import '../widgets/product_card.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
        backgroundColor: Colors.red.shade600,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthBloc>().add(AuthLogoutRequested());
            },
          ),
        ],
      ),
      body: BlocBuilder<FavoritesBloc, FavoritesState>(
        builder: (context, favoritesState) {
          if (favoritesState is! FavoritesLoaded) {
            return const Center(child: CircularProgressIndicator());
          }

          if (favoritesState.favoriteIds.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 64,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No favorites yet',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Start adding products to your favorites!',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            );
          }

          return BlocBuilder<ProductsBloc, ProductsState>(
            builder: (context, productsState) {
              if (productsState is ProductsLoaded) {
                final favoriteProducts = productsState.products
                    .where(
                      (product) =>
                          favoritesState.favoriteIds.contains(product.id),
                    )
                    .toList();

                if (favoriteProducts.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.favorite_border,
                          size: 64,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No favorites found',
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Your favorite products will appear here',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: Colors.grey.shade500),
                        ),
                      ],
                    ),
                  );
                }

                return Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      color: Colors.red.shade50,
                      child: Row(
                        children: [
                          Icon(Icons.favorite, color: Colors.red.shade600),
                          const SizedBox(width: 8),
                          Text(
                            '${favoriteProducts.length} favorite${favoriteProducts.length == 1 ? '' : 's'}',
                            style: TextStyle(
                              color: Colors.red.shade700,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.5,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                            ),
                        itemCount: favoriteProducts.length,
                        itemBuilder: (context, index) {
                          return ProductCard(
                            product: favoriteProducts[index],
                            isFavorite: true,
                            onFavoriteToggle: () {
                              context.read<FavoritesBloc>().add(
                                ToggleFavorite(favoriteProducts[index].id),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                );
              } else if (productsState is ProductsError) {
                return CustomErrorWidget(
                  message: 'Failed to load products for favorites',
                  onRetry: () {
                    context.read<ProductsBloc>().add(LoadProducts());
                  },
                );
              }

              return const Center(child: CircularProgressIndicator());
            },
          );
        },
      ),
    );
  }
}
