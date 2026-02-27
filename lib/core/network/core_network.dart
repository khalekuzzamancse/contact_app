library api_client;
import 'dart:convert';
import 'package:contact_app/core/language/core_language.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
part '_dio.dart';
part '_http.dart';
part 'client_decorator.dart';


typedef Json = Map<String, dynamic>;
abstract interface class  NetworkClient {
  Future<Json> getOrThrow({required String url,  HttpHeaders? headers});
  Future<Json> postOrThrow({required String url, required dynamic payload,  HttpHeaders? headers});
  Future<Json> putOrThrow({required String url, dynamic payload,  HttpHeaders? headers});
  Future<Json> patchOrThrow({required String url, required dynamic payload,  HttpHeaders? headers});
  Future<Json> deleteOrThrow({required String url,  HttpHeaders? headers});
  void close();

  /// The decorator use header implicitly, if required a custom header or null header then use the
  /// [createBaseClient]
  static NetworkClient? _client;
  static NetworkClient createClientDecorator() {
    final dio = Dio();
    dio.options.headers = {'Content-Type': 'application/json; charset=UTF-8'};
  // return _DioClient();
   // return _HttpClient();
   return NetworkClientDecorator.create( _HttpClient());
  }
  static NetworkClient createBaseClient() {
    final dio = Dio();
    dio.options.headers = {'Content-Type': 'application/json; charset=UTF-8'};
    // return _DioClient();
    return _HttpClient();
  }
  static NetworkClient createSharedBaseClient() {
    // final dio = Dio();
    // dio.options.headers = {'Content-Type': 'application/json; charset=UTF-8'};
    // return _DioClient();
    _client ??= _HttpClient();
    return _client!;
  }
  static closeSharedClient(){
    _client?.close();
    _client=null;
  }

}

class HttpHeader {
  final String key;
  final String value;

  const HttpHeader(this.key, this.value);
  @override
  String toString()=>'$key: $value';

}

class HttpHeaders {
  final List<HttpHeader> headers;

  HttpHeaders(this.headers);
  static createAuthHeader(String token)=>HttpHeaders([HttpHeader('Authorization', 'Bearer $token')]);
  Map<String, String> toMap() {
    final map = <String, String>{};
    for (var header in headers) {
      map[header.key] = header.value;
    }
    return map;
  }
  @override
  String toString()=>'$headers';
}

void _throwTokenExpireExceptionOrDoNothing(String responseJson,String tag) {
  // var isTokenExpire = false;
  // try { //Catching the error related to parsing because this is extra parsing and it may be fail
  //   //so if fail consumer/client code will broken for no reason which is hard to debug
  //
  //
  //   //TODO:For this project doing this because sure about each response common structure
  //   //while pasting code to other project must remove this
  //   //This is doing for maintain the single source of truth for token expire exception
  //   final responseEntity = ServerResponse.fromJsonOrThrow(
  //       jsonDecode(responseJson));
  //   if (responseEntity.isTokenExpireError) {
  //     isTokenExpire = true;
  //     throw UnauthorizedException(debugMessage: 'source:$tag'); //return it from the catch block
  //   }
  // }
  // catch (e) {
  //   if (isTokenExpire) {
  //     throw UnauthorizedException(debugMessage: 'source:$tag');
  //   }
  //   //TODO:Need not do something
  // }
}