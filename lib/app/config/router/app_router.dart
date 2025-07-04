import 'package:expanda/features/home/home_page.dart';
import 'package:expanda/features/map/controlled_map_page.dart';
import 'package:expanda/features/map/location_page.dart';
import 'package:expanda/features/map/map_page.dart';
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

    GoRoute(path: '/location', builder: (context, state) => LocationPage()),

    GoRoute(path: '/map', builder: (context, state) => MapPage()),

    GoRoute(
      path: '/controlled-map',
      builder: (context, state) => ControlledMapPage(),
    ),
  ],
);
