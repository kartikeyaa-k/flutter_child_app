import 'package:child_app/core/mock_model/deeplink_country_model.dart';
import 'package:equatable/equatable.dart';

enum DeeplinkStateStatus {
  init,
  deeplinkHandling,
  failure,

  authDeeplinkInitiating,
  authDeeplinkLaunched,

  requestContentDeeplinkInitializing,
  requestContentDeeplinkLaunched,

  contentDeeplinkReceived,
  authDeepLinkReceived,
}

class DeeplinkState extends Equatable {
  final DeeplinkStateStatus status;
  final DeeplinkCountryModel? deeplinkCountryModel;

  const DeeplinkState({
    this.status = DeeplinkStateStatus.init,
    this.deeplinkCountryModel,
  });

  @override
  List<Object?> get props => [
        status,
      ];

  DeeplinkState copyWith({
    DeeplinkStateStatus? status,
    DeeplinkCountryModel? deeplinkCountryModel,
  }) {
    return DeeplinkState(
      status: status ?? this.status,
      deeplinkCountryModel: deeplinkCountryModel ?? this.deeplinkCountryModel,
    );
  }
}
