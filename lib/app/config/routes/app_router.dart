import 'package:expanda/presentation/features/events/clases_page.dart';
import 'package:expanda/presentation/features/auth/auth_page.dart';
import 'package:expanda/presentation/features/auth/login_page.dart';
import 'package:expanda/presentation/features/events/create_event_page.dart';
import 'package:expanda/presentation/features/home/home_page.dart';
import 'package:expanda/presentation/features/map/controlled_map_page.dart';
import 'package:expanda/presentation/features/map/location_page.dart';
import 'package:expanda/presentation/features/map/map_page.dart';
import 'package:expanda/presentation/features/permission/permission_page.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(path: '/', builder: (context, state) => HomePage()),

    GoRoute(path: '/login', builder: (context, state) => LoginPage()),

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

    GoRoute(path: '/auth', builder: (context, state) => AuthPage()),

    GoRoute(
      path: '/events',
      builder: (context, state) => ClassesPage(),
      routes: [
        GoRoute(path: 'create', builder: (context, state) => CreateEventPage()),
      ],
    ),
  ],
);
