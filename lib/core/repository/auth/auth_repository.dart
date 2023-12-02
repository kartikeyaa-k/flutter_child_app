import 'dart:async';
import 'dart:convert';
import 'package:child_app/core/constants/app_constants.dart';
import 'package:child_app/core/mock_model/mock_user_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthRepository {
  final FlutterSecureStorage secureStorage;

  AuthRepository(this.secureStorage);

  Future<MockUserModel> storeUser(String token, String uid) async {
    // Assume a successful login for the sake of the example
    // In a real-world scenario, you would make an API request to authenticate the user

    // Simulate a delay to mimic an API call
    await Future.delayed(const Duration(seconds: 2));

    // Create a fake user model with some details
    final userModel = MockUserModel(
      userId: 'exf-eds-ujh-klo-912',
      firstName: 'John',
      lastName: 'Doe',
    );

    // Store the encrypted token in secure storage
    // We also need to add this in dio auth interceptor
    await storeEncryptedToken(LocalDatabaseKeys.authToken, token);
    await storeUserBasics(LocalDatabaseKeys.userBasic, userModel);
    // Return the user model as a successful response
    return userModel;
  }

  Future<bool> isSessionValid() async {
    final String? encryptedToken =
        await getEncryptedToken(LocalDatabaseKeys.authToken);

    if (encryptedToken == null) {
      // Token not found, consider the session as invalid
      return false;
    }

    // Due to time constraints, not performing decryption
    final String decryptedToken = encryptedToken;

    // Decode the payload
    final Map<String, dynamic> payload =
        json.decode(utf8.decode(base64Url.decode(decryptedToken)));

    if (!payload.containsKey('exp') || payload['exp'] is! int) {
      // Token doesn't contain a valid expiration timestamp, consider the session as invalid
      return false;
    }

    final int expirationTimestamp = payload['exp'];

    // Check if the token is still valid
    return isTokenValid(expirationTimestamp);
  }

  bool isTokenValid(int expirationTimestamp) {
    final int currentTimestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    return currentTimestamp <= expirationTimestamp;
  }

  Future<void> storeUserBasics(String key, MockUserModel user) async {
    // Implement hive or other local db to store the user
  }

  Future<void> storeEncryptedToken(String key, String token) async {
    await secureStorage.write(
      key: key,
      value: token,
    );
  }

  Future<String?> getEncryptedToken(String key) async {
    return secureStorage.read(key: key);
  }

  Future<void> removeEncryptedToken(String key) async {
    await secureStorage.delete(key: key);
  }

  Future<void> logout() async {
    // Remove the encrypted token when logging out
    await removeEncryptedToken(LocalDatabaseKeys.authToken);
  }

  Future<MockUserModel?> getLocalUser() async {
    // return a fake user model from local database
    return MockUserModel(
      userId: 'exf-eds-ujh-klo-912',
      firstName: 'John',
      lastName: 'Doe',
    );
  }
}
