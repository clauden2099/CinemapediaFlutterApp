import 'package:cinemapedia/presentation/screens/screens.dart';
import 'package:cinemapedia/presentation/views/views.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    /*Los shell routesson cuando se tiene una unica screen y lo unico que se 
    quiere cambiar es el contenido de está pero que se siga manteniendo en la misma
    screen o ruta */
    /*ShellRoute(
      builder: (context, state, child) {
        return HomeScreen(childView: child);
      },
      routes: [
        /*Se definien las vistas que se mostraran en la ruta */
        GoRoute(
          path: '/',
          builder: (context, state) {
            return const HomeView();
          },
          routes: [
            /*Se indica que está ruta va a recibir el argumento ID y estos siempre
            son Strings */
            GoRoute(
              path: 'movie/:id',
              name: MovieScreen.name,
              builder: (context, state) {
                final movieId = state.pathParameters['id'] ?? 'no-id';
                return MovieScreen(movieId: movieId);
              },
            ),
          ],
        ),

        GoRoute(
          path: '/favorites',
          builder: (context, state) {
            return const FavoritesView();
          },
        ),
      ],
    ),*/

    /*Navegación usando StatefulShellRoute que es una forma de mantener el estado 
    o view viva entre navegaciones, cada vista se mantiene viva en la memoria  
    siendo así que cuando se cambia de vista esta no se destruye se mantiene
    solo se ha visible o se oculta cuando se nececite alguan de estás*/
    StatefulShellRoute.indexedStack(
      //Aquí se indica la screen principal
      builder: (context, state, navigationShell) {
        return HomeScreen(navigationShell: navigationShell);
      },
      /*Aquí las view que se mostraran en la screen */
      branches: [
        /*
        - Cada branch es una **tab independiente** con su propia pila de navegación
        - Si en el branch de Home navegas a `/movie/123`, esa navegación es **local al branch**
        - Cuando cambias a Favorites y regresas a Home, sigues donde dejaste (`/movie/123` sigue en el stack de ese branch)
        - Cada branch vive en su propio "universo" de navegación

        Visualmente sería así:
        ```
        Branch 0 (Home):      /  →  /movie/123  →  /movie/456
        Branch 1 (Categories): /categories
        Branch 2 (Favorites):  /favorites
                          ↑
                    Cada uno tiene su propia pila
         */
        // Branch 0 - Home
        StatefulShellBranch(
          // Hace qeu se monte la view cuando el usuario visita el branch por primera vez
          // Si se quisiera que se montara desde el inicio se puede usar el parámetro preloadBranches: true en el goBranch
          // preloadBranches: false por defecto
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => const HomeView(),
              routes: [
                GoRoute(
                  path: 'movie/:id',
                  name: MovieScreen.name,
                  builder: (context, state) {
                    final movieId = state.pathParameters['id'] ?? 'no-id';
                    return MovieScreen(movieId: movieId);
                  },
                ),
              ],
            ),
          ],
        ),

        // Branch 1 - Categories
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/categories',
              builder: (context, state) =>
                  Center(child: const Text('Categories View')),
            ),
          ],
        ),

        // Branch 2 - Favorites
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/favorites',
              builder: (context, state) => const FavoritesView(),
            ),
          ],
        ),
      ],
    ),

    /*Rutas padre/hijo
    GoRoute(
      path: '/',
      name: HomeScreen.name,
      builder: (context, state) => const HomeScreen(childView: HomeView(),),
      /*Estás son rutas hijas osea que parten desde esté padre así que cuando
      se navege hacía atras llegaran a está pantalla */
      routes: [
        /*Se indica que está ruta va a recibir el argumento ID y estos siempre
        son Strings */
        GoRoute(
          path: 'movie/:id',
          name: MovieScreen.name,
          builder: (context, state) {
            final movieId = state.pathParameters['id'] ?? 'no-id';
            return MovieScreen(movieId: movieId);
          },
        ),
      ],
    ),*/
  ],
);

