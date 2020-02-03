import 'dart:io';

import 'package:dio/dio.dart';
import 'package:sw_core_package/data/models/base/CoreResponse.dart';
//import 'package:logging/logging.dart';
import 'package:sw_core_package/data/models/error/CoreResponseError.dart';
import 'package:sw_core_package/remote/constants/RemoteConstants.dart';
import 'package:sw_core_package/utilities/CoreStorageManager.dart';
import 'package:sw_core_package/utilities/CoreStringUtils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:logger/logger.dart';
import 'package:sw_core_package/utilities/rxbus/CoreBusMessages.dart';
import 'package:sw_core_package/utilities/rxbus/rxbus.dart';

class SimpleLogPrinter extends LogPrinter {
  final String className;
  SimpleLogPrinter(this.className);

  @override
  void log(Level level, message, error, StackTrace stackTrace) {
    var emoji = PrettyPrinter.levelEmojis[level];
    println(('$emoji $className - $message'));
  }
}

abstract class CoreRequestBuilder {
  Dio _dio;
//  final Logger _logger = new Logger("RequestBuilder");
  final Logger logger = Logger(printer: SimpleLogPrinter('RequestBuilder'));

  Future<void> performRequest(
      String endPoint,
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
      try {
        if (error.response != null) {
          errorCode = error.response.statusCode;
          if (error.response.data != null) {
            errorMessage = retrieveErrorMessage(error.response.data);
          }
        } else {
          errorMessage = error.message;
        }
        onError(CoreResponseError.fromValues(errorCode, errorMessage));
      } catch (e) {
        onError(CoreResponseError.fromValues(0, ""));
      }
    }
  }

  Future<void> uploadImage(
      String endPoint,
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
     try{

        if (error.response != null) {
          errorCode = error.response.statusCode;
          if (error.response.data != null) {
            errorMessage = retrieveErrorMessage(error.response.data);
          }
        } else {
          errorMessage = error.message;
        }

        onError(CoreResponseError.fromValues(errorCode, errorMessage));
     }catch(e){
       onError(CoreResponseError.fromValues(0, ""));
     }

    }
  }

  String retrieveErrorMessage(Map<String, dynamic> jsonObject);

  Future<Map<String, dynamic>> buildHeader() async {
    var headers = Map<String, dynamic>();
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.get(CoreStorageManager.userTokenKey);
    if (CoreStringUtils.isNotEmpty(token)) {
      headers["x-access-token"] = token;
      logger.d("x-access-token: $token");
    }
    return headers;
  }

  BaseOptions buildRequestOptions() {
    return BaseOptions(
      baseUrl: CoreRemoteConstants.baseUrl,
      contentType: ContentType.parse("application/x-www-form-urlencoded"),
      responseType: ResponseType.json,
      connectTimeout: 30000,
      receiveTimeout: 30000,
    );
  }

  void setupInterceptors(String endPoint,
      {Map<String, dynamic> requestParams, FormData formData}) {
    int maxCharactersPerLine = 300;
    _dio = new Dio(buildRequestOptions());
    // setup request
    _dio.interceptors
        .add(InterceptorsWrapper(onRequest: (Options options) async {
      options.headers = await buildHeader();
      logger.v("Start Request");
      if (requestParams != null) {
        logger.v("requestParams: $requestParams");
      }
      if (formData != null) {
        logger.v("formData: $formData");
      }
      logger.v("path: ${CoreRemoteConstants.baseUrl}$endPoint");
      logger.v("method: ${options.method.toString()}\n");
      logger.v("header: ${options.headers}");
      logger.v("Content type: ${options.contentType}\n");
      return options;
    }));
    // setup response
    _dio.interceptors.add(InterceptorsWrapper(onResponse: (Response response) {
      logger.i(
          "Response: code - ${response.statusCode} for method - ${response.request.method.toString()}, and path - ${response.request.baseUrl + response.request.path}");
      String responseAsString = response.data.toString();
      if (responseAsString.length > maxCharactersPerLine) {
        int iterations =
            (responseAsString.length / maxCharactersPerLine).floor();
        for (int i = 0; i <= iterations; i++) {
          int endingIndex = i * maxCharactersPerLine + maxCharactersPerLine;
          if (endingIndex > responseAsString.length) {
            endingIndex = responseAsString.length;
          }
          logger.i(responseAsString.substring(
              i * maxCharactersPerLine, endingIndex));
        }
      } else {
        logger.i("Ressponse data: ${response.data}");
      }
      logger.d("End Request\n\n");
    }));
    // setup onError
    _dio.interceptors.add(InterceptorsWrapper(onError: (DioError error) {
      logger.e("Request got error");
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (error.response != null) {
        logger.e("${error.response}\n\n");
        if (error.response.statusCode == CoreHttpCode.TOKEN_INVALID) {
          RxBus.post(ShowCodeError(errorCode: CoreHttpCode.TOKEN_INVALID),
              tag: RxBusTag
                  .RxBusTag_TOKEN_INVALID); //RxBusTag.RxBusTag_TOKEN_INVALID
        }
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        logger.e(error.request);
        logger.e("${error.message}\n\n");
      }
      logger.d("\n\n");
    }));
  }
}
