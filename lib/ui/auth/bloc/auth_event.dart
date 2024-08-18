part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}


class AuthClicked extends AuthEvent{
  final String username;
  final String    password;

  const AuthClicked(this.username, this.password);

}

class AuthStarted extends AuthEvent{

}

class ChangeStateLogin extends AuthEvent{

}
