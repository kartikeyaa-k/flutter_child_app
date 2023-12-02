import 'package:child_app/core/global_cubits/auth_cubit/auth_cubit.dart';
import 'package:child_app/core/global_cubits/auth_cubit/auth_state.dart';
import 'package:child_app/features/home_screen/home_screen.dart';
import 'package:child_app/features/login_screen/login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late AuthCubit authCubit;

  @override
  void initState() {
    authCubit = BlocProvider.of<AuthCubit>(context);
    authCubit.isAuthenticatedAndAuthorized();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state.status == AuthStateStatus.isNotAuthenticated ||
              state.status == AuthStateStatus.isAuthenticatedSuccess ||
              state.status == AuthStateStatus.isAuthenticatedVerifying) {
            if (state.isLoggedIn && state.isSessionValid) {
              _navigateToHomeScreen();
            } else {
              _navigateToLoginScreen();
            }
          }
        },
        builder: (context, state) {
          return const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Child Splash Screen',
                style: TextStyle(
                  fontSize: 24,
                ),
              ),
              SizedBox(
                height: 16,
              ),
              CupertinoActivityIndicator(),
            ],
          );
        },
      ),
    ));
  }

  void _navigateToHomeScreen() {
    /// This ideally be handled using business logic
    Future.delayed(
      const Duration(seconds: 2),
      () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const HomeScreen(),
          ),
        );
      },
    );
  }

  void _navigateToLoginScreen() {
    /// This ideally be handled using business logic
    Future.delayed(
      const Duration(seconds: 2),
      () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const LoginScreen(),
          ),
        );
      },
    );
  }
}
