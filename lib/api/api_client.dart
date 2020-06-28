import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:pintersest_clone/util/authentication_preferences.dart';

import 'errors/error.dart';

class ApiClient {
  ApiClient(this._client, this._authenticationPreferences);

  static const _serverUrl = 'http://localhost:8080';
  static const _serverDomain = 'localhost:8080';
  final Client _client;
  final AuthenticationPreferences _authenticationPreferences;

  Future<Response> get(String relativeUrl, {Map<String, String> query}) async {
    final token = await _authenticationPreferences.getAccessToken();
    final header = {'token': token};
    return _makeRequestWithErrorHandler(
      _client.get(
        Uri.http(_serverDomain, relativeUrl, query).toString(),
        headers: header,
      ),
    );
  }

  Future<Response> post(String relativeUrl, {String body}) async {
    final token = await _authenticationPreferences.getAccessToken();
    final header = {'token': token};
    return _makeRequestWithErrorHandler(
      _client.post('$_serverUrl$relativeUrl', body: body, headers: header),
    );
  }

  Future<String> multiPartPost(String relativeUrl,
      {File image, String json}) async {
    final request =
        http.MultipartRequest('POST', Uri.parse('$_serverUrl$relativeUrl'));
    request.fields['json'] = json;
    request.files.add(http.MultipartFile.fromBytes(
        'image', image.readAsBytesSync(),
        filename: 'image'));
    final response = await request.send();
    return response.stream.bytesToString();
  }

  static Future<Response> _makeRequestWithErrorHandler(
      Future<Response> requestFunction) async {
    final response = await requestFunction;
    if (response.statusCode >= 400) {
      throw _handleError(response.statusCode, response.body,
          response.request?.url?.toString());
    }

    return response;
  }

  static DefaultError _handleError(
      int statusCode, String errorResponse, String url) {
    if (statusCode == 400) {
      return BadRequestError();
    } else if (statusCode == 401) {
      return UnauthorizedError();
    } else if (statusCode == 403) {
      return ForbiddenServerError();
    } else if (statusCode == 404) {
      return NotFoundError(url);
    } else if (statusCode >= 500 && statusCode <= 599) {
      return UnknownServerError(errorResponse, statusCode);
    } else {
      return UnknownClientError(errorResponse);
    }
  }
}
