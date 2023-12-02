import 'package:child_app/core/constants/app_constants.dart';
import 'package:child_app/core/enums/deeplink_enums.dart';
import 'package:child_app/core/extensions/null_empty_validator.dart';
import 'package:child_app/core/extensions/string_extensions.dart';
import 'package:child_app/core/global_cubits/deeplink_cubit/deeplink_state.dart';
import 'package:child_app/core/mock_model/deeplink_country_model.dart';
import 'package:child_app/core/repository/auth/auth_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uni_links/uni_links.dart';
import 'package:url_launcher/url_launcher.dart';

class DeeplinkCubit extends Cubit<DeeplinkState> {
  final AuthRepository authRepository;
  DeeplinkCubit(
    this.authRepository,
  ) : super(
          const DeeplinkState(),
        );

  Future<void> initDeepLinks() async {
    linkStream.listen(
      (String? link) async {
        debugPrint(link);
        if (link != null && link.isNotEmpty) {
          await handleDeepLink(link);
        }
      },
      onError: (error) {},
    );
  }

  Future<void> handleDeepLink(String link) async {
    try {
      emit(state.copyWith(
        status: DeeplinkStateStatus.deeplinkHandling,
      ));
      final uri = Uri.parse(link);
      final queryParams = uri.queryParameters;

      final token = queryParams.getValueFromQueryKey(DeeplinkConstants.token);
      final uId = queryParams
          .getValueFromQueryKey(DeeplinkConstants.userUniqueIdentifier);

      if (token.isNotNullOrEmpty && uId.isNotNullOrEmpty) {
        // Store the new token with uid
        // Fetch more details if required
        // in this example we are only saving the token just for the sake
        // of demonstrating time validity

        // Null check taken care above
        await authRepository.storeUser(token!, uId!);

        // Determine deeplink path, which module it is for
        final module = uri.path.toLowerCase();

        // For this assignment, we are only interested in country module

        if (module == DeeplinkModules.country.name) {
          var countryName = queryParams[DeeplinkConstants.countryNameQueryKey];

          if (countryName != null && countryName.isNotEmpty) {
            countryName = Uri.decodeComponent(countryName);
            final DeeplinkCountryModel navigationData = DeeplinkCountryModel(
              name: countryName,
            );
            emit(state.copyWith(
              status: DeeplinkStateStatus.contentDeeplinkReceived,
              deeplinkCountryModel: navigationData,
            ));
          }
        } else if (module == DeeplinkModules.login.name) {
          emit(state.copyWith(
            status: DeeplinkStateStatus.authDeepLinkReceived,
          ));
        }
      }
    } catch (e) {
      // Out of scope of this assignment
    }
  }

  Future<void> navigateToParentAppForCountrySelection() async {
    try {
      emit(state.copyWith(
        status: DeeplinkStateStatus.requestContentDeeplinkInitializing,
      ));
      final uri = Uri(
        scheme: DeeplinkConstants.parentAppScheme,
      );
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
        emit(state.copyWith(
          status: DeeplinkStateStatus.requestContentDeeplinkLaunched,
        ));
      } else {
        // This part is currently out of scope for this assignment.
        if (kDebugMode) {
          print('Could not launch $uri');
        }
      }
    } catch (e) {
      //
    }
  }

  Future<void> openParentAppForLogin() async {
    try {
      emit(state.copyWith(
        status: DeeplinkStateStatus.authDeeplinkInitiating,
      ));
      final uri = Uri(
        scheme: DeeplinkConstants.parentAppScheme,
        path: DeeplinkConstants.loginPath,
      );
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
        emit(state.copyWith(
          status: DeeplinkStateStatus.authDeeplinkLaunched,
        ));
      } else {
        // This part is currently out of scope for this assignment.
        if (kDebugMode) {
          print('Could not launch $uri');
        }
      }
    } catch (e) {
      //
    }
  }

  // Dispose method to clean up resources
  @override
  Future<void> close() async {
    // Clean up resources, close streams, etc.
    await super.close();
  }
}
