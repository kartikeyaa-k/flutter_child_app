import 'package:child_app/core/global_cubits/auth_cubit/auth_cubit.dart';
import 'package:child_app/core/global_cubits/deeplink_cubit/deeplink_cubit.dart';
import 'package:child_app/features/splash_screen/splash_screen.dart';
import 'package:child_app/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Root extends StatefulWidget {
  const Root({super.key});

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  late DeeplinkCubit deeplinkCubit;

  @override
  void initState() {
    deeplinkCubit = locator<DeeplinkCubit>();
    deeplinkCubit.initDeepLinks();
    super.initState();
  }

  @override
  void dispose() {
    deeplinkCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider.value(value: deeplinkCubit),
          BlocProvider<AuthCubit>(
            create: (_) => locator.get<AuthCubit>(),
          ),
        ],
        child: const MaterialApp(
          home: SplashScreen(),
        ));
  }
}
