import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nike_store_flutter/common/exception.dart';
import 'package:nike_store_flutter/data/local/shared.dart';
import 'package:nike_store_flutter/data/models/auth.dart';
import 'package:nike_store_flutter/data/repo/auth_repo.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final IAuthRepository authRepository;
  bool isLogin;
  AuthBloc(this.authRepository, {this.isLogin = true})
      : super(AuthInitial(isLogin)) {
    on<AuthEvent>((event, emit) async {
      try {
        if (event is AuthClicked) {
          emit(AuthLoading(isLogin));
          if (isLogin) {
            await authRepository.login(event.username, event.password);
            emit(AuthSuccess(isLogin));
          } else {
            await authRepository.signUp(event.username, event.password);
            emit(AuthSuccess(isLogin));
          }
        } else if (event is ChangeStateLogin) {
          isLogin = !isLogin;
          emit(AuthInitial(isLogin));
        }
      } catch (e) {
        emit(AuthError(AppException(), isLogin));
      }
    });
  }
}
