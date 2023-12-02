import 'package:child_app/core/global_cubits/deeplink_cubit/deeplink_cubit.dart';
import 'package:child_app/core/global_cubits/deeplink_cubit/deeplink_state.dart';
import 'package:child_app/features/home_screen/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late DeeplinkCubit _deeplinkCubit;

  @override
  void initState() {
    _deeplinkCubit = BlocProvider.of<DeeplinkCubit>(context);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
        ),
        body: BlocConsumer<DeeplinkCubit, DeeplinkState>(
          listener: (context, state) {
            if (state.status == DeeplinkStateStatus.authDeepLinkReceived ||
                state.status == DeeplinkStateStatus.contentDeeplinkReceived) {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (_) => const HomeScreen()));
            }
          },
          builder: (context, state) {
            return Center(
              child: Column(
                children: [
                  const Text(
                    'Child App Login Screen',
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _deeplinkCubit.openParentAppForLogin();
                    },
                    child: state.status == DeeplinkStateStatus.deeplinkHandling
                        ? const CupertinoActivityIndicator()
                        : const Text('Login with Parent App'),
                  ),
                ],
              ),
            );
          },
        ));
  }
}
