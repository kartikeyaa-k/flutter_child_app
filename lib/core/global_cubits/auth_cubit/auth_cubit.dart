import 'package:child_app/core/global_cubits/auth_cubit/auth_state.dart';
import 'package:child_app/core/repository/auth/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository authRepository;

  AuthCubit({required this.authRepository})
      : super(const AuthState(isLoggedIn: false));

  Future<void> isAuthenticatedAndAuthorized() async {
    try {
      emit(
        state.copyWith(
          status: AuthStateStatus.isAuthenticatedVerifying,
        ),
      );
      // Perform login logic using authRepository
      final user = await authRepository.getLocalUser();

      if (user != null) {
        final isSessionValid = await authRepository.isSessionValid();
        if (isSessionValid) {
          // Emit a new state indicating successful login
          emit(
            state.copyWith(
              status: AuthStateStatus.isAuthenticatedSuccess,
              isLoggedIn: true,
              isSessionValid: true,
              user: user,
            ),
          );
        } else {
          emit(
            state.copyWith(
              status: AuthStateStatus.isNotAuthenticated,
              isLoggedIn: false,
            ),
          );
        }
      } else {
        emit(
          state.copyWith(
            status: AuthStateStatus.isNotAuthenticated,
          ),
        );
      }
    } catch (e) {
      // Handle login failure (you might want to emit different states for different failure scenarios)
      emit(
        state.copyWith(
          status: AuthStateStatus.isNotAuthenticated,
          isLoggedIn: false,
          isSessionValid: false,
        ),
      );
    }
  }

  Future<void> logoutUser() async {
    try {
      emit(
        state.copyWith(
          status: AuthStateStatus.loggingOutProcessing,
        ),
      );
      // Check if the user session is valid using authRepository
      await authRepository.logout();

      emit(
        state.copyWith(
          status: AuthStateStatus.logoutSuccess,
          isLoggedIn: false,
          isSessionValid: false,
        ),
      );
    } catch (e) {
      // Handle login failure
      // Currently mocking it be success
      emit(
        state.copyWith(
          status: AuthStateStatus.logoutSuccess,
          isLoggedIn: false,
          isSessionValid: false,
        ),
      );
    }
  }
}
