import 'package:dio/dio.dart';

class  DioClient {
  
  
final Dio dio = Dio(BaseOptions(
  baseUrl: "http://192.168.29.89:3000/",
  responseType: ResponseType.plain));    
  
}