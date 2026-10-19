import 'package:go_router/go_router.dart';
import 'package:nacho_loko/features/home/presentation/screens/list_categories_screen.dart';

import 'features/home/presentation/screens/create_category_screen.dart';
import 'features/home/presentation/screens/create_product_screen.dart';
import 'features/home/presentation/screens/edit_commerce_screen.dart';
import 'features/home/presentation/screens/edit_product_screen.dart';
import 'features/home/presentation/screens/home_screen.dart';
import 'features/home/presentation/screens/products_by_category_screen.dart';


final GoRouter router = GoRouter(initialLocation: "/", routes: <RouteBase>[
  GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
  GoRoute(path: '/menu', builder: (context, state) => DigitalMenuScreen()),
  GoRoute(path: '/category', builder: (context, state) => CreateCategoryScreen()),
  GoRoute(path: '/restaurant', builder: (context, state) => EditCommerceScreen()),
  GoRoute(path: '/products', builder: (context, state) => ProductsByCategoryScreen()),
  GoRoute(path: '/createProduct', builder: (context, state) => CreateProductScreen()),
  GoRoute(path: '/editProduct', builder: (context, state) => EditProductScreen()),
]);
  //GoRoute(path: '/', builder: (context, state) => const WelcomeScreen()),
  //GoRoute(path: '/login', builder: (context, state) => LoginScreen()),
