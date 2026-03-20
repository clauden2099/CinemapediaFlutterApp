import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomBottomNavigation extends StatelessWidget {
  final StatefulNavigationShell navigationShell; // 👈 Recibe el shell

  //const CustomBottomNavigation({super.key});
  const CustomBottomNavigation({super.key, required this.navigationShell});

  /*Shell Routes
  int getCurrentIndex(BuildContext context) {
    final String location = GoRouterState.of(context).matchedLocation;
    switch (location) {
      case '/':
        return 0;

      case '/categories':
        return 1;

      case '/favorites':
        return 2;

      default:
        return 0;
    }
  }

  void onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/');
        break;
      case 1:
        context.go('/');
        break;
      case 2:
        context.go('/favorites');
        break;
    }
  }*/

  @override
  Widget build(BuildContext context) {
    /*Shell routes
    return BottomNavigationBar(
      elevation: 0,
      currentIndex: getCurrentIndex(context),
      onTap: (value) => onItemTapped(context, value),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_max), label: 'Inicio'),
        BottomNavigationBarItem(
          icon: Icon(Icons.label_outline),
          label: 'Categorias',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite_outline),
          label: 'Favoritos',
        ),
      ],
    );
    */
    return BottomNavigationBar(
      elevation: 0,
      //Savbe en que tab o rama se encuentra
      currentIndex: navigationShell.currentIndex, // 👈 Índice automático
      //Cambia de rama usando el shell, el método goBranch se encarga 
      //de cambiar la vista y mantener el estado de cada rama en base al índice
      onTap: (index) => navigationShell.goBranch(
        index,
        // Vuelve al inicio del branch si ya estás en él
        initialLocation: index == navigationShell.currentIndex,
      ),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_max), label: 'Inicio'),
        BottomNavigationBarItem(
          icon: Icon(Icons.label_outline),
          label: 'Categorias',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite_outline),
          label: 'Favoritos',
        ),
      ],
    );
  }
}
