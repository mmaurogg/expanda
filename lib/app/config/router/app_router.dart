import 'package:expanda/features/home/home_page.dart';
import 'package:expanda/features/permission/permission_page.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => HomePage()),
    GoRoute(
      path: '/permissions',
      builder: (context, state) => PermissionPage(),
    ),
  ],
);
