import 'package:expanda/data/repositiories/user_repository.dart';
import 'package:expanda/domain/entities/user_model.dart';
import 'package:expanda/domain/repositories/user_respository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userUseCaseProvider = Provider<UserUseCase>((ref) {
  final repository = ref.read(userRepositoryProvider);
  return UserUseCase(repository);
});

class UserUseCase {
  final UserRepository _repository;

  UserUseCase(this._repository);

  Future<UserModel?> getCurrentUser() {
    return _repository.getCurrentUser();
  }

  Future<UserModel?> saveUser(UserModel user) {
    return _repository.saveUser(user);
  }
}
