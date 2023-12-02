import 'package:child_app/core/global_cubits/auth_cubit/auth_cubit.dart';
import 'package:child_app/core/global_cubits/auth_cubit/auth_state.dart';
import 'package:child_app/core/global_cubits/deeplink_cubit/deeplink_cubit.dart';
import 'package:child_app/core/global_cubits/deeplink_cubit/deeplink_state.dart';
import 'package:child_app/core/mock_data/mock_parsed_countries.dart';
import 'package:child_app/core/mock_model/mock_country_with_cities_model.dart';
import 'package:child_app/core/utils/snackbar/app_snackbar.dart';
import 'package:child_app/features/login_screen/login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  late DeeplinkCubit deeplinkCubit;
  late AuthCubit _authCubit;

  CountryWithCitiesModel? countryWithCities;
  @override
  void initState() {
    deeplinkCubit = BlocProvider.of<DeeplinkCubit>(context);
    _authCubit = BlocProvider.of<AuthCubit>(context);
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _authCubit.isAuthenticatedAndAuthorized();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Child Home Screen',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.purple.shade200,
          automaticallyImplyLeading: false,
          actions: [
            InkWell(
              onTap: () {
                _authCubit.logoutUser();
              },
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.logout_outlined, color: Colors.red),
              ),
            ),
          ],
        ),
        body: BlocListener<AuthCubit, AuthState>(
          listener: (context, authState) {
            if (authState.status == AuthStateStatus.isNotAuthenticated) {
              showSnackbar(context, 'Session Timeout!');
              _authCubit.logoutUser();
            } else if (authState.status == AuthStateStatus.logoutSuccess) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (_) => const LoginScreen(),
                ),
                (route) => false,
              );
            }
          },
          child: BlocBuilder<DeeplinkCubit, DeeplinkState>(
            buildWhen: (c, p) =>
                c.status !=
                DeeplinkStateStatus.requestContentDeeplinkInitializing,
            builder: (context, state) {
              if (state.status == DeeplinkStateStatus.contentDeeplinkReceived &&
                  deeplinkCubit.state.deeplinkCountryModel != null) {
                // Assume its for city related content
                countryWithCities = countriesWithCitiesData.firstWhere(
                    (element) =>
                        element.countryName.toLowerCase() ==
                        deeplinkCubit.state.deeplinkCountryModel!.name
                            .toLowerCase());
              }
              return RefreshIndicator(
                onRefresh: () async {
                  _authCubit.isAuthenticatedAndAuthorized();
                },
                child: Center(
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          'Welcome, John Doe',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.fade,
                        ),
                      ),
                      ElevatedButton(
                          onPressed: () {
                            deeplinkCubit
                                .navigateToParentAppForCountrySelection();
                          },
                          child:
                              const Text('Select a country from Parent app')),
                      const SizedBox(
                        height: 24,
                      ),
                      if (countryWithCities != null) ...[
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            deeplinkCubit.state.deeplinkCountryModel!.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.fade,
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: countryWithCities?.cities.length,
                            itemBuilder: (_, index) {
                              return ListTile(
                                leading: const Icon(Icons.location_city),
                                title: Text(
                                  countryWithCities!.cities[index],
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
