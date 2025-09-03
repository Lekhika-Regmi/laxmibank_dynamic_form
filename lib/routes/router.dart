import 'package:dynamic_form/screens/form_screen.dart';
import 'package:dynamic_form/screens/form_screen_two.dart';
import 'package:dynamic_form/screens/home_screen.dart';
import 'package:dynamic_form/screens/splash_screen.dart';
import 'package:go_router/go_router.dart';
import '../models/merchant.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
    GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
    GoRoute(
      path: '/form',
      builder: (context, state) {
        final merchant = state.extra as Merchant;
        return FormScreen2(merchant: merchant);
      },
    ),
  ],
);
