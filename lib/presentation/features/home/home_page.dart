import 'package:expanda/domain/entities/user_model.dart';
import 'package:expanda/presentation/features/auth/registry_page.dart';
import 'package:expanda/presentation/features/events/clases_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final menuItems = <MenuItem>[
    MenuItem('Registro', Icons.person_add, RegistryPage.routeName),
    MenuItem('Auth', Icons.people, '/auth'),
    MenuItem('Clases', Icons.school, '/events'),

    MenuItem('Ubicación', Icons.pin_drop, '/location'),
    MenuItem('Mapas', Icons.map_outlined, '/map'),
    MenuItem('Mapa-Control', Icons.gamepad_outlined, '/controlled-map'),
  ];

  int _selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
        actions: [
          IconButton(
            onPressed: () {
              context.push('/permissions');
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          ClassesPage(),

          Container(
            padding: const EdgeInsets.all(10),
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: IconButton(
                    onPressed: () {
                      print(Role.user.value);
                    },
                    icon: Icon(Icons.logout),
                  ),
                ),

                SliverGrid.count(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  children:
                      menuItems
                          .map(
                            (item) => HomeMenuItem(
                              title: item.title,
                              route: item.route,
                              icon: item.icon,
                            ),
                          )
                          .toList(),
                ),
              ],
            ),
          ),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Funciones'),
        ],
      ),
    );
  }
}

class MenuItem {
  final String title;
  final IconData icon;
  final String route;

  MenuItem(this.title, this.icon, this.route);
}

class HomeMenuItem extends StatelessWidget {
  final String title;
  final String route;
  final IconData icon;
  final List<Color> bgColors;

  const HomeMenuItem({
    super.key,
    required this.title,
    required this.route,
    required this.icon,
    this.bgColors = const [Colors.lightBlue, Colors.blue],
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(route),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: bgColors,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 40),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
