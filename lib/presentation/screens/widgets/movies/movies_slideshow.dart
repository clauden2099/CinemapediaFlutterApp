import 'package:animate_do/animate_do.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:flutter/material.dart';

class MoviesSlideshow extends StatelessWidget {
  final List<Movie> movies;

  const MoviesSlideshow({super.key, required this.movies});

  @override
  Widget build(BuildContext context) {

    final colors = Theme.of(context).colorScheme;
    return SizedBox(
      height: 210,
      width: double.infinity,
      /*Con este widget se puede hacer el slide horizontal de una manera 
      más sencilla */
      child: Swiper(
        itemCount: movies.length,
        //El tamaño del elemento que se mostrara en pantalla
        viewportFraction: 0.8,
        //La separación entre cada elemento
        scale: 0.9,
        //Hace que se muevan solos de manera automatica
        autoplay: true,
        pagination: SwiperPagination(
          margin: const EdgeInsets.only(top: 0),
          builder: DotSwiperPaginationBuilder(
            activeColor: colors.primary,
            color: colors.secondary
          )
        ),
        itemBuilder: (context, index) {
          final movie = movies[index];
          return _Slide(movie: movie);
        },
      ),
    );
  }
}

class _Slide extends StatelessWidget {
  final Movie movie;

  const _Slide({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    final decoration = BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      boxShadow: const [
        BoxShadow(color: Colors.black45, blurRadius: 10, offset: Offset(0, 10)),
      ],
    );
    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      /*El DecoratedBox sirve para darle un estilo a un widget que por lo generar
      sería pintar un fondo o borde detras del contenido */
      child: DecoratedBox(
        decoration: decoration,
        /*Con ClipRRect sirve para envolver un widget hijo y recortar todo lo 
        que quede fuera del tamaño de este o se desborde */
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.network(
            movie.backdropPath,
            fit: BoxFit.cover,
            /*Esta propiedad sirve para realizar acciones mietras la imagen
            carga, no cargo, o ya esta lista */
            loadingBuilder: (context, child, loadingProgress) {
              //Si la imagen aún no carga
              if (loadingProgress != null) {
                return const DecoratedBox(
                  decoration: BoxDecoration(color: Colors.black12),
                );
              }
              return FadeIn(child: child);
            },
          ),
        ),
      ),
    );
  }
}
