import 'package:clean_architecture_bloc/common/network/api_result.dart';
import 'package:clean_architecture_bloc/common/usecase/usecase.dart';
import 'package:clean_architecture_bloc/features/user/data/models/user.dart';
import 'package:clean_architecture_bloc/features/user/domain/repositories/user_repository.dart';

class CreateUserUseCase implements UseCase<bool, CreateUserParams> {
  final UserRepository userRepository;

  const CreateUserUseCase(this.userRepository);

  @override
  Future<ApiResult<bool>> call(CreateUserParams params) async {
    return await userRepository.createUser(params.user);
  }
}

class CreateUserParams {
  final User user;

  CreateUserParams(this.user);
}
