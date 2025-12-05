import 'package:expanda/presentation/features/auth/registry_page.dart';
import 'package:expanda/presentation/features/events/events_page.dart';
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
  initialLocation: LoginPage.routeName,
  routes: [
    GoRoute(path: HomePage.routeName, builder: (context, state) => HomePage()),

    GoRoute(
      path: LoginPage.routeName,
      builder: (context, state) => LoginPage(),
    ),

    GoRoute(path: AuthPage.routeName, builder: (context, state) => AuthPage()),

    GoRoute(
      path: RegistryPage.routeName,
      builder: (context, state) => RegistryPage(),
    ),

    GoRoute(
      path: EventsPage.routeName,
      builder: (context, state) => EventsPage(),
      routes: [
        GoRoute(
          path: CreateEventPage.routeName,
          builder: (context, state) => CreateEventPage(),
        ),
      ],
    ),

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
