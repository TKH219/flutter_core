import 'dart:io';

import 'package:dio/dio.dart';
import 'package:logging/logging.dart';
import 'package:sw_core_package/data/models/error/CoreResponseError.dart';
import 'package:sw_core_package/remote/constants/RemoteConstants.dart';
import 'package:sw_core_package/utilities/CoreStorageManager.dart';
import 'package:sw_core_package/utilities/CoreStringUtils.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class CoreRequestBuilder {
  Dio _dio;
  final Logger _logger = new Logger("RequestBuilder");

  Future<void> performRequest(String endPoint,
      String httpMethod,
      Map<String, dynamic> requestParams,
      Function(Map<String, dynamic> responseData) onResponse,
      dynamic Function(CoreResponseError error) onError) async {
    try {
      setupInterceptors(endPoint, requestParams: requestParams);
      Response response;
      switch (httpMethod) {
        case CoreHTTPMethod.get:
          response = await _dio.get(endPoint, queryParameters: requestParams);
          break;
        case CoreHTTPMethod.post:
          response = await _dio.post(endPoint, data: requestParams);
          break;
        case CoreHTTPMethod.put:
          response = await _dio.put(endPoint, data: requestParams);
          break;
        case CoreHTTPMethod.patch:
          response = await _dio.patch(endPoint, data: requestParams);
          break;
        case CoreHTTPMethod.delete:
          response = await _dio.delete(endPoint, data: requestParams);
          break;
        default:
          response = await _dio.patch(endPoint, data: requestParams);
      }
      // we should have header code as 200 here
      onResponse(response.data);
    } on DioError catch (error) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      String errorMessage;
      int errorCode = 0;
      if (error.response != null) {
        errorCode = error.response.statusCode;
        if (error.response.data != null) {
          errorMessage = retrieveErrorMessage(error.response.data);
        }
      } else {
        errorMessage = error.message;
      }
      onError(CoreResponseError.fromValues(errorCode, errorMessage));
    }
  }

  Future<void> uploadImage(String endPoint,
      FormData formData,
      Function(Map<String, dynamic> responseData) onResponse,
      dynamic Function(CoreResponseError error) onError) async {
    try {
      setupInterceptors(endPoint, formData: formData);
      Response response;
      response = await _dio.put(endPoint, data: formData);
      // we should have header code as 200 here
      onResponse(response.data);
    } on DioError catch (error) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      String errorMessage;
      int errorCode = 0;
      if (error.response != null) {
        errorCode = error.response.statusCode;
        if (error.response.data != null) {
          errorMessage = retrieveErrorMessage(error.response.data);
        }
      } else {
        errorMessage = error.message;
      }
      onError(CoreResponseError.fromValues(errorCode, errorMessage));
    }
  }

  String retrieveErrorMessage(Map<String, dynamic> jsonObject);

  Future<Map<String, dynamic>> buildHeader() async {
    var headers = Map<String, dynamic>();
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.get(CoreStorageManager.userTokenKey);
    if (CoreStringUtils.isNotEmpty(token)) {
      headers["x-access-token"] = token;
      _logger.fine("x-access-token: $token");
    }
    return headers;
  }

  BaseOptions buildRequestOptions() {
    return BaseOptions(
        baseUrl: CoreRemoteConstants.baseUrl,
        contentType: ContentType.parse("application/x-www-form-urlencoded"),
        responseType: ResponseType.json,
        connectTimeout: 20000,
        receiveTimeout: 15000,
    );
  }

  void setupInterceptors(String endPoint, {Map<String, dynamic> requestParams, FormData formData}) {
    int maxCharactersPerLine = 300;
    _dio = new Dio(buildRequestOptions());
    // setup request
    _dio.interceptors
        .add(InterceptorsWrapper(onRequest: (Options options) async {
      options.headers = await buildHeader();
      _logger.fine("<-- \n\nStart Request");
      if (requestParams != null) {
        _logger.fine("requestParams: $requestParams");
      }
      if (formData != null) {
        _logger.fine("formData: $formData");

      }
      _logger.fine("path: ${CoreRemoteConstants.baseUrl}$endPoint");
      _logger.fine("-->method: ${options.method.toString()},\nheader: ${options.headers}");
      _logger.fine("Content type: ${options.contentType}");
      return options;
    }));
    // setup response
    _dio.interceptors.add(InterceptorsWrapper(onResponse: (Response response) {
      _logger.fine(
          "<--Response: code - ${response.statusCode} for method - ${response
              .request.method.toString()}, and path - ${response.request.baseUrl + response.request.path}");
      String responseAsString = response.data.toString();
      if (responseAsString.length > maxCharactersPerLine) {
        int iterations =
        (responseAsString.length / maxCharactersPerLine).floor();
        for (int i = 0; i <= iterations; i++) {
          int endingIndex = i * maxCharactersPerLine + maxCharactersPerLine;
          if (endingIndex > responseAsString.length) {
            endingIndex = responseAsString.length;
          }
          _logger.fine(responseAsString.substring(
              i * maxCharactersPerLine, endingIndex));
        }
      } else {
        _logger.fine("Ressponse data: ${response.data}");
      }
      _logger.fine("<-- End Request");
    }));
    // setup onError
    _dio.interceptors.add(InterceptorsWrapper(onError: (DioError error) {
      _logger.fine("<-- Request got error");
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (error.response != null) {
        _logger.fine(error.response.data);
        _logger.fine(error.response.headers);
        _logger.fine(error.response.request);
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        _logger.fine(error.request);
        _logger.fine(error.message);
      }
    }));
  }
}
