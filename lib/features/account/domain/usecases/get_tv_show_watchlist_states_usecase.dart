import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:tmda/core/error/failure.dart';
import 'package:tmda/features/account/domain/entities/account_states.dart';
import 'package:tmda/features/account/domain/repositories/account_repository.dart';

@lazySingleton
class GetTvShowWatchListStatesUseCase{
  final AccountRepository accountRepository;
  const GetTvShowWatchListStatesUseCase(this.accountRepository);

  Future<Either<Failure, AccountStates>> call({required int tvShowId, required String sessionId}) async{
    return await accountRepository.getTvShowWatchListStates(tvShowId: tvShowId, sessionId: sessionId);
  }
}