import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tokokita/helpers/user_info.dart';
import 'app_exception.dart';

class Api {
  Future<dynamic> post(dynamic url, dynamic data) async {
    var token = await UserInfo().getToken();
    var responseJson;
    try {
      // prepare headers
      final headers = <String, String>{
        HttpHeaders.acceptHeader: 'application/json',
        if (token != null && token.isNotEmpty)
          HttpHeaders.authorizationHeader: "Bearer $token",
      };

      // prepare body
      dynamic bodyToSend = data;
      if (data is Map) {
        bodyToSend = json.encode(data);
        headers[HttpHeaders.contentTypeHeader] = 'application/json';
      } else if (data is String) {
        // assume already encoded, but ensure content-type is set if not present
        headers[HttpHeaders.contentTypeHeader] =
            headers[HttpHeaders.contentTypeHeader] ?? 'application/json';
        bodyToSend = data;
      } else if (data == null) {
        bodyToSend = null;
      } else {
        // fallback: try to encode
        try {
          bodyToSend = json.encode(data);
          headers[HttpHeaders.contentTypeHeader] = 'application/json';
        } catch (_) {
          bodyToSend = data.toString();
          headers[HttpHeaders.contentTypeHeader] = 'text/plain';
        }
      }

      print('🔵 [API POST] URL: $url');
      print('🔵 [API POST] Headers: $headers');
      print('🔵 [API POST] Body: $bodyToSend');

      final response = await http.post(
        Uri.parse(url),
        body: bodyToSend,
        headers: headers,
      );
      print('🟢 [API POST] Status: ${response.statusCode}');
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> get(dynamic url) async {
    var token = await UserInfo().getToken();
    var responseJson;
    try {
      final headers = <String, String>{
        HttpHeaders.acceptHeader: 'application/json',
        if (token != null && token.isNotEmpty)
          HttpHeaders.authorizationHeader: "Bearer $token",
      };

      print('🔵 [API GET] URL: $url');
      print('🔵 [API GET] Headers: $headers');

      final response = await http.get(Uri.parse(url), headers: headers);
      print('🟢 [API GET] Status: ${response.statusCode}');
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> put(dynamic url, dynamic data) async {
    var token = await UserInfo().getToken();
    var responseJson;
    try {
      final headers = <String, String>{
        HttpHeaders.acceptHeader: 'application/json',
        if (token != null && token.isNotEmpty)
          HttpHeaders.authorizationHeader: "Bearer $token",
      };

      dynamic bodyToSend = data;
      if (data is Map) {
        bodyToSend = json.encode(data);
        headers[HttpHeaders.contentTypeHeader] = 'application/json';
      } else if (data is String) {
        headers[HttpHeaders.contentTypeHeader] =
            headers[HttpHeaders.contentTypeHeader] ?? 'application/json';
        bodyToSend = data;
      } else if (data == null) {
        bodyToSend = null;
      } else {
        try {
          bodyToSend = json.encode(data);
          headers[HttpHeaders.contentTypeHeader] = 'application/json';
        } catch (_) {
          bodyToSend = data.toString();
          headers[HttpHeaders.contentTypeHeader] = 'text/plain';
        }
      }

      print('🔵 [API PUT] URL: $url');
      print('🔵 [API PUT] Headers: $headers');
      print('🔵 [API PUT] Body: $bodyToSend');

      final response = await http.put(
        Uri.parse(url),
        body: bodyToSend,
        headers: headers,
      );
      print('🟢 [API PUT] Status: ${response.statusCode}');
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> delete(dynamic url) async {
    var token = await UserInfo().getToken();
    var responseJson;
    try {
      final headers = <String, String>{
        HttpHeaders.acceptHeader: 'application/json',
        if (token != null && token.isNotEmpty)
          HttpHeaders.authorizationHeader: "Bearer $token",
      };

      print('🔵 [API DELETE] URL: $url');
      print('🔵 [API DELETE] Headers: $headers');

      final response = await http.delete(Uri.parse(url), headers: headers);
      print('🟢 [API DELETE] Status: ${response.statusCode}');
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  dynamic _returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
      case 204:
        return response;
      case 400:
        throw BadRequestException(_safeBody(response));
      case 401:
      case 403:
        throw UnauthorisedException(_safeBody(response));
      case 422:
        throw InvalidInputException(_safeBody(response));
      case 500:
      default:
        throw FetchDataException(
          'Error occured while Communication with Server with StatusCode :${response.statusCode}\nBody: ${response.body}',
        );
    }
  }

  String _safeBody(http.Response response) {
    // try to extract message from JSON body if possible
    try {
      final decoded = json.decode(response.body);
      if (decoded is Map && decoded['message'] != null) {
        return decoded['message'].toString();
      }
    } catch (_) {}
    return response.body.toString();
  }
}
