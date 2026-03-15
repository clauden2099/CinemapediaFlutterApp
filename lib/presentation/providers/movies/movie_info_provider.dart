import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:flutter_riverpod/legacy.dart';


/*Se indica el notifier con el que trabaja este state y el valor o estado que 
regresa este provider */
final movieInfoProvider = StateNotifierProvider<MoviesMapNotifier, Map<String,Movie>>((ref) {

  /*Se manda a llamar al repositorio ya que los providers son los que se comunican con estos
  creando la cadena de tal forma que los widgets->providers->repository->datasource 
  aunque los casos de uso deberían de estar entre los providers y los repositories pero
  como no están implementados en esta app no se usan
  */
  /*Aquí se esta regresando una instancia de movieRepositoryImpl */
  final moviesRepository = ref.watch(movieRepositoryProvider);

  /*Aquí se esta envíando la referencia de la función getMovieById al state */
  return MoviesMapNotifier(getMovie: moviesRepository.getMovieById);
});



typedef GetMovieCallback = Future<Movie> Function(String movieId);

/*Esta calse es el estate o valor que que proporcionan los providers
y cada cambio que se necesite generar en el state desde fuera se hace en 
está misma calse siendo así com si el state se modificara a sí mismo
o este tuviera la lógica para modificarse a si mismo */
class MoviesMapNotifier extends StateNotifier<Map<String, Movie>> {
  final GetMovieCallback getMovie;

  MoviesMapNotifier({required this.getMovie}) : super({});

  Future<void> loadMovie(String movieId) async {
    /*Aquí se hace una especie de cache ya que si se accede a una pelicula por 
    primera vez se guarda un objeto de movie y cuando se accede a la misma pelicula 
    se revisa si ese id de dicha pelicula no se encuentra en el map para así no realizar 
    otra petición http y mostrar la que se encuentra en el arreglo de la app*/
    if(state[movieId] != null) return;
    //Aquí se ejecuta la petición HTTP
    print('Realizando peticion http');
    final movie = await getMovie(movieId);
    /*Se mantiene el estado anterior y se agrega un nuevo valor a esté */
    state = {...state, movieId: movie};
  }
}
