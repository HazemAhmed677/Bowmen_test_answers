import 'package:bowmen_ecommerce/logic/products/events.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../logic/auth/bloc.dart';
import '../logic/auth/events.dart';
import '../logic/favorites/bloc.dart';
import '../logic/favorites/event.dart';
import '../logic/favorites/states.dart';
import '../logic/products/bloc.dart';
import '../logic/products/states.dart';
import '../widgets/custom_error_widget.dart';
import '../widgets/product_card.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProductsBloc>().add(LoadProducts());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        backgroundColor: Colors.blue.shade600,
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
      body: BlocBuilder<ProductsBloc, ProductsState>(
        builder: (context, state) {
          if (state is ProductsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProductsLoaded) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<ProductsBloc>().add(RefreshProducts());
              },
              child: Column(
                children: [
                  if (state.isFromCache)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(8),
                      color: Colors.orange.shade100,
                      child: Row(
                        children: [
                          Icon(Icons.cached, color: Colors.orange.shade700),
                          const SizedBox(width: 8),
                          Text(
                            'Showing cached data',
                            style: TextStyle(color: Colors.orange.shade700),
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
                      itemCount: state.products.length,
                      itemBuilder: (context, index) {
                        return BlocBuilder<FavoritesBloc, FavoritesState>(
                          builder: (context, favoritesState) {
                            final isFavorite =
                                favoritesState is FavoritesLoaded &&
                                favoritesState.favoriteIds.contains(
                                  state.products[index].id,
                                );

                            return ProductCard(
                              product: state.products[index],
                              isFavorite: isFavorite,
                              onFavoriteToggle: () {
                                context.read<FavoritesBloc>().add(
                                  ToggleFavorite(state.products[index].id),
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          } else if (state is ProductsError) {
            return CustomErrorWidget(
              message: state.message,
              onRetry: () {
                context.read<ProductsBloc>().add(LoadProducts());
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
