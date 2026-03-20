import 'package:cinemapedia/presentation/screens/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  static const name = 'home_screen';
  //Usando ShellRoutes
  //final Widget childView;

  //Usando StatefulShellRoute
  final StatefulNavigationShell navigationShell; // Cambio aquí

  const HomeScreen({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Usando ShellRoutes
      //  body: childView,
      /*Renderica la rama o view que este activa */
      body: navigationShell,
      //el boton de navegación personalizada para que esta pueda 
      //cambiar el estado del ShellRoute y así cambiar la vista 
      //que se muestra en el body */
      bottomNavigationBar: CustomBottomNavigation(
        navigationShell: navigationShell, // 👈 Pasamos el shell
      ),
      //bottomNavigationBar: CustomBottomNavigation(),
    );
  }
}
