import 'package:cinemapedia/presentation/screens/screens.dart';
import 'package:cinemapedia/presentation/views/views.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    /*Los shell routesson cuando se tiene una unica screen y lo unico que se 
    quiere cambiar es el contenido de está pero que se siga manteniendo en la misma
    screen o ruta */
    ShellRoute(
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
    ),

    /*
    Rutas padre/hijo
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
