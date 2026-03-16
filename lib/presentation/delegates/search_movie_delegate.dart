import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/config/helpers/human_formats.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:flutter/material.dart';

typedef SearchMoviesCallback = Future<List<Movie>> Function(String query);

/*Los delegate son clases que se utilizan para establecer reglas o funcionamentos
de ciertos widgets esto se hace para que el widget padre o principal no tenga
que definir toda lógica o funcionalidad en si mismo si no que la delega a otra
clase para que la relice por el y este solo la ejecuta cuando sea neceario */
/*En este caso esté es un SearchDelegate que se utiliza para definir las función
de búsqueda  */
class SearchMovieDelegate extends SearchDelegate<Movie?> {
  final SearchMoviesCallback searchMovies;
  List<Movie> initialMovies;
  /*Aquí se esta usando una tecnica que se llama debounce que se utiliza para 
  evitar que una función o accion se ejcute demasiadas veces en un periodo corto
  de tiempo la idea es solo ejecutar la ultima acciones de las tantas posibles
  que se puedan hacer, la ide de su funcionamiento es tener un temporizador 
  si se se ejecuta un evento antes de que termine este se reinicia y si despues
  de cierto tiempo no se ejecuta ningun evento termina el temporizador y se ejecuta
  la función esperada*/
  /*Un StreamController es una clase que sirve para crear y controlar 
    un Stream de datos a parte de darle ciertas propiedade o al stream que se crea*/
  StreamController<List<Movie>> debouncedMovies = StreamController.broadcast();
  StreamController<bool> isLoadingStream = StreamController.broadcast();
  /*El timer es una clase que recibe un tiempo específico y ejecuta acciones depues
  de que ese tiempo termina o en base a un intervalo de tiempo que se le haya indicado 
  al Timer */
  Timer? _debounceTimer;

  SearchMovieDelegate({
    required this.searchMovies,
    required this.initialMovies,
  });

  /*Esta es la función que ejecuta la lógica del debounce */
  void _onQueryChanged(String query) {
    isLoadingStream.add(true);
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();

    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      /*if (query.isEmpty) {
        debouncedMovies.add([]);
        return;
      }*/

      final movies = await searchMovies(query);
      initialMovies = movies;
      debouncedMovies.add(movies);
      isLoadingStream.add(false);
    });
  }

  void clearStreams() {
    debouncedMovies.close();
  }

  //El texto que se muestra en la barra de búsqueda
  @override
  String get searchFieldLabel => 'Buscar película';

  Widget buildResultsAndSeuggestions() {
    return StreamBuilder(
      initialData: initialMovies,
      /*Indica el Stream que esta escuchando el StreamBuilder */
      stream: debouncedMovies.stream,
      /*Aquí se indican las acciones que realizara el builder en base al estado
      del stream que están en el snapshot*/
      builder: (context, snapshot) {
        /*Esta variable tendra la lista de movies que se obtuvo del stream */
        final movies = snapshot.data ?? [];
        return ListView.builder(
          itemCount: movies.length,
          itemBuilder: (context, index) {
            final movie = movies[index];
            /*Se envía la función close del searchDelegate así cuando se selecione
            una película se ira a la página de está */
            return _MovieItem(
              movie: movie,
              onMovieSelected: (context, movie) {
                clearStreams();
                close(context, movie);
              },
            );
          },
        );
      },
    );
  }

  //Acciones como limpiar el texto
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      /*La variable query es una que ya viene definida en el searchDelegate y está
      contiene los valores que se ingresen en la cajda de busqueda del searchDelegate
      así que en este caso cuando se de clic en el boton el query sera igual a un String
      vacío haciendo que se elimine lo escrito en la barra de búsqueda */
      //if (query.isNotEmpty)
      StreamBuilder(
        initialData: false,
        stream: isLoadingStream.stream,
        builder: (context, snapshot) {
          if (snapshot.data ?? false) {
            return SpinPerfect(
              duration: const Duration(seconds: 2),
              spins: 10,
              infinite: true,
              child: IconButton(
                onPressed: () => query = '',
                icon: const Icon(Icons.refresh_rounded),
              ),
            );
          }
          return FadeIn(
            child: IconButton(
              onPressed: () => query = '',
              icon: const Icon(Icons.clear),
            ),
          );
        },
      ),
    ];
  }

  //Es el botón de retroceso para salir de la búsqueda
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      /*El método close ya esta definido en el searchDelegate y sirve para indicar
      que hacia donde se va a regreas la pantalla cuando se salga del seach
      y si este regresara algun tipo de valor que en este caso fue nulo ya que no
      se regresa ningun valor */
      onPressed: () {
        clearStreams();
        close(context, null);
      },
      icon: Icon(Icons.arrow_back_ios_new),
    );
  }

  //Muestra los resultados finales al usuario
  @override
  Widget buildResults(BuildContext context) {
    return buildResultsAndSeuggestions();
  }

  //Muestra sugerencia mientras el usuario escribe
  @override
  Widget buildSuggestions(BuildContext context) {
    /*Con el FutureBuilder se utiliza para realizar acciones por lo general de 
    construccion de interfaz o UI en base al estado
    que se tiene de un Future o función asíncrona tiendo estos estados
    none -> No se ha asignado el Future
    waiting -> El Future está en ejecución
    active -> El Future está activo
    done -> El Future terminó ya sea con éxito o error*/
    /*Un Future represnta un valor que estará disponible en el futuro */
    /*return FutureBuilder(
      /*Indica la función que devuelve un Future que en este caso es una lista
      de películas List<Movie> */
      future: searchMovies(query),
      /*Sirve para mostrar datos temporales mientres el Future se resuelve */
      //initialData: const [],
      /*Aquí se indican las acciones que realizara el builder en base al estado
      del Future que están en el snapshot*/
      builder: (context, snapshot) {
        /*Esta variable tendra la lista de movies que se obtuvo del Future */
        final movies = snapshot.data ?? [];

        return ListView.builder(
          itemCount: movies.length,
          itemBuilder: (context, index) {
            final movie = movies[index];
            /*Se envía la función close del searchDelegate así cuando se selecione
            una película se ira a la página de está */
            return _MovieItem(movie: movie, onMovieSelected: close,);
          },
        );
      },
    );*/

    _onQueryChanged(query);
    /*El StreamBuilder es practicamente igual que un FutureBuilder que es esperar
    un Stream y recontruir la Ui o ejecutar ciertas acciones cuano llegan nuevos datos */
    return StreamBuilder(
      initialData: initialMovies,
      /*Indica el Stream que esta escuchando el StreamBuilder */
      stream: debouncedMovies.stream,
      /*Aquí se indican las acciones que realizara el builder en base al estado
      del stream que están en el snapshot*/
      builder: (context, snapshot) {
        /*Esta variable tendra la lista de movies que se obtuvo del stream */
        final movies = snapshot.data ?? [];

        return ListView.builder(
          itemCount: movies.length,
          itemBuilder: (context, index) {
            final movie = movies[index];
            /*Se envía la función close del searchDelegate así cuando se selecione
            una película se ira a la página de está */
            return _MovieItem(
              movie: movie,
              onMovieSelected: (context, movie) {
                clearStreams();
                close(context, movie);
              },
            );
          },
        );
      },
    );
  }
}

class _MovieItem extends StatelessWidget {
  final Movie movie;
  // Definición más precisa:
  final void Function(BuildContext, Movie?) onMovieSelected;

  const _MovieItem({required this.movie, required this.onMovieSelected});

  @override
  Widget build(BuildContext context) {
    final textSyles = Theme.of(context).textTheme;
    //Obtiene el tamaño de la pantalla
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        onMovieSelected(context, movie);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Row(
          children: [
            //Imagen de la película
            SizedBox(
              width: size.width * 0.2,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  movie.posterPath,
                  loadingBuilder: (context, child, loadingProgress) =>
                      FadeIn(child: child),
                ),
              ),
            ),

            const SizedBox(width: 10),

            //Descripcion
            SizedBox(
              width: size.width * 0.7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(movie.title, style: textSyles.titleMedium),

                  (movie.overview.length > 100)
                      ? Text('${movie.overview.substring(0, 100)}...')
                      : Text(movie.overview),

                  //Estrellitas
                  Row(
                    children: [
                      Icon(
                        Icons.star_half_rounded,
                        color: Colors.yellow.shade800,
                      ),
                      SizedBox(width: 5),
                      Text(
                        HumanFormats.number(movie.voteAverage),
                        style: textSyles.bodyMedium!.copyWith(
                          color: Colors.yellow.shade900,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
