import 'package:dartz/dartz.dart';
import 'package:tmda/core/error/failure.dart';
import 'package:tmda/features/movie/domain/entities/movies.dart';
import 'package:tmda/features/movie/domain/repositories/movies_repository.dart';

class GetNewMoviesUseCase {
  final MoviesRepository movieRepository;
  const GetNewMoviesUseCase({required this.movieRepository});
  Future<Either<Failure, List<Movies>>> call() async{
    return await movieRepository.getNewMovies();
  }
}