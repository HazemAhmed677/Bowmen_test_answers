// lib/main.dart
// import 'package:shared_preferences/shared_preferences.dart';
// import 'screens/login_screen.dart';
// import 'screens/products_screen.dart';
// import 'blocs/auth/auth_bloc.dart';
// import 'blocs/products/products_bloc.dart';
// import 'blocs/favorites/favorites_bloc.dart';
// import 'repositories/auth_repository.dart';
// import 'repositories/products_repository.dart';
// import 'repositories/favorites_repository.dart';
import 'package:bowmen_ecommerce/logic/auth/bloc.dart';
import 'package:bowmen_ecommerce/logic/auth/states.dart';
import 'package:bowmen_ecommerce/logic/favorites/bloc.dart';
import 'package:bowmen_ecommerce/logic/favorites/event.dart';
import 'package:bowmen_ecommerce/logic/products/bloc.dart';
import 'package:bowmen_ecommerce/repo/all_app_repos.dart';
import 'package:bowmen_ecommerce/views/login_view.dart';
import 'package:bowmen_ecommerce/views/main_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'logic/auth/events.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPreferences = await SharedPreferences.getInstance();

  runApp(MyApp(sharedPreferences: sharedPreferences));
}

class MyApp extends StatelessWidget {
  final SharedPreferences sharedPreferences;

  const MyApp({super.key, required this.sharedPreferences});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => AuthRepository(sharedPreferences),
        ),
        RepositoryProvider(
          create: (context) => ProductsRepository(sharedPreferences),
        ),
        RepositoryProvider(
          create: (context) => FavoritesRepository(sharedPreferences),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                AuthBloc(authRepository: context.read<AuthRepository>())
                  ..add(AuthCheckRequested()),
          ),
          BlocProvider(
            create: (context) => ProductsBloc(
              productsRepository: context.read<ProductsRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => FavoritesBloc(
              favoritesRepository: context.read<FavoritesRepository>(),
            )..add(LoadFavorites()),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'E-commerce App',
          theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
          home: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is AuthAuthenticated) {
                return const MainScreen();
              } else {
                return const LoginScreen();
              }
            },
          ),
        ),
      ),
    );
  }
}

// lib/models/product.dart

// lib/repositories/auth_repository.dart
