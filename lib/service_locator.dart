import 'package:child_app/core/global_cubits/auth_cubit/auth_cubit.dart';
import 'package:child_app/core/repository/auth/auth_repository.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:child_app/core/global_cubits/deeplink_cubit/deeplink_cubit.dart';

final GetIt locator = GetIt.instance;

void setupServiceLocator() {
  locator.registerSingleton<FlutterSecureStorage>(const FlutterSecureStorage());

  locator.registerSingleton<AuthRepository>(
      AuthRepository(locator<FlutterSecureStorage>()));

  locator.registerSingleton<DeeplinkCubit>(
      DeeplinkCubit(locator.get<AuthRepository>()));

  locator.registerSingleton<AuthCubit>(
      AuthCubit(authRepository: locator<AuthRepository>()));
}
