import 'package:child_app/core/mock_model/mock_user_model.dart';
import 'package:equatable/equatable.dart';

enum AuthStateStatus {
  init,
  loading,
  failure,

  loginProcessing,
  loginSuccess,

  isAuthenticatedVerifying,
  isAuthenticatedSuccess,
  isNotAuthenticated,

  loggingOutProcessing,
  logoutSuccess,
}

class AuthState extends Equatable {
  final AuthStateStatus status;
  final bool isLoggedIn;
  final bool isSessionValid;
  final MockUserModel? user;

  const AuthState({
    this.status = AuthStateStatus.init,
    required this.isLoggedIn,
    this.isSessionValid = false,
    this.user,
  });

  @override
  List<Object?> get props => [status, isLoggedIn, isSessionValid, user];

  AuthState copyWith({
    AuthStateStatus? status,
    bool? isLoggedIn,
    bool? isSessionValid,
    MockUserModel? user,
  }) {
    return AuthState(
      status: status ?? this.status,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      isSessionValid: isSessionValid ?? this.isSessionValid,
      user: user ?? this.user,
    );
  }
}
