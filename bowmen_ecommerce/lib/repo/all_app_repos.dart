import 'dart:convert';

import 'package:bowmen_ecommerce/models/all_app_models.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  final SharedPreferences _prefs;
  static const String _isLoggedInKey = 'is_logged_in';

  AuthRepository(this._prefs);

  Future<bool> login(String email, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    // Simple validation - in real app, this would be API call
    if (email.isNotEmpty && password.length >= 6) {
      await _prefs.setBool(_isLoggedInKey, true);
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    await _prefs.setBool(_isLoggedInKey, false);
  }

  bool isLoggedIn() {
    return _prefs.getBool(_isLoggedInKey) ?? false;
  }
}

class ProductsRepository {
  final SharedPreferences _prefs;
  static const String _productsKey = 'cached_products';
  static const String _lastFetchKey = 'last_fetch_time';
  static const Duration _cacheExpiry = Duration(hours: 1);

  ProductsRepository(this._prefs);

  Future<List<Product>> getProducts() async {
    try {
      // Check cache first
      final cachedProducts = await _getCachedProducts();
      if (cachedProducts != null && !_isCacheExpired()) {
        return cachedProducts;
      }

      // Fetch from API
      final response = await http.get(
        Uri.parse('https://fakestoreapi.com/products'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        final products = jsonData
            .map((json) => Product.fromJson(json))
            .toList();

        // Cache the products
        await _cacheProducts(products);

        return products;
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      // If network fails, try to return cached data
      final cachedProducts = await _getCachedProducts();
      if (cachedProducts != null) {
        return cachedProducts;
      }
      throw Exception('Network error and no cached data available: $e');
    }
  }

  Future<List<Product>?> _getCachedProducts() async {
    final cachedData = _prefs.getString(_productsKey);
    if (cachedData != null) {
      final List<dynamic> jsonData = json.decode(cachedData);
      return jsonData.map((json) => Product.fromJson(json)).toList();
    }
    return null;
  }

  Future<void> _cacheProducts(List<Product> products) async {
    final jsonData = products.map((product) => product.toJson()).toList();
    await _prefs.setString(_productsKey, json.encode(jsonData));
    await _prefs.setInt(_lastFetchKey, DateTime.now().millisecondsSinceEpoch);
  }

  bool _isCacheExpired() {
    final lastFetch = _prefs.getInt(_lastFetchKey);
    if (lastFetch == null) return true;

    final lastFetchTime = DateTime.fromMillisecondsSinceEpoch(lastFetch);
    return DateTime.now().difference(lastFetchTime) > _cacheExpiry;
  }
}

class FavoritesRepository {
  final SharedPreferences _prefs;
  static const String _favoritesKey = 'favorite_products';

  FavoritesRepository(this._prefs);

  Future<Set<int>> getFavorites() async {
    final favoritesJson = _prefs.getString(_favoritesKey);
    if (favoritesJson != null) {
      final List<dynamic> favoritesList = json.decode(favoritesJson);
      return favoritesList.cast<int>().toSet();
    }
    return {};
  }

  Future<void> addFavorite(int productId) async {
    final favorites = await getFavorites();
    favorites.add(productId);
    await _saveFavorites(favorites);
  }

  Future<void> removeFavorite(int productId) async {
    final favorites = await getFavorites();
    favorites.remove(productId);
    await _saveFavorites(favorites);
  }

  Future<void> _saveFavorites(Set<int> favorites) async {
    final favoritesJson = json.encode(favorites.toList());
    await _prefs.setString(_favoritesKey, favoritesJson);
  }
}
