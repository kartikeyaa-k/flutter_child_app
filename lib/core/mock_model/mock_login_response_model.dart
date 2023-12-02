import 'package:child_app/core/mock_model/mock_user_model.dart';

class MockLoginResponseModel {
  final MockUserModel userModel;
  final String authToken;
  MockLoginResponseModel({
    required this.userModel,
    required this.authToken,
  });
}
