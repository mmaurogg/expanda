import 'package:expanda/domain/entities/user_model.dart';

abstract class UserRepository {
  Future<UserModel?> getCurrentUser();
  Future<UserModel?> saveUser(UserModel user);
}
