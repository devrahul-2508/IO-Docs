import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_docs/models/api_response_document_model.dart';
import 'package:google_docs/models/document_model.dart';
import 'package:google_docs/network/dio_client.dart';
import 'package:google_docs/repository/local_storage.dart';

import '../models/error_model.dart';

final documentRepositoryProvider =
    Provider((ref) => DocumentRepository(dio: DioClient().dio));

class DocumentRepository {
  final Dio _dio;

  DocumentRepository({required Dio dio}) : _dio = dio;

  Future<ResponseModel> createDocument() async {
    ResponseModel response = ResponseModel(
        success: false, message: "Some unknown error occured", data: null);

    try {
      String token = Prefs.getToken("TOKEN");

      DocumentModel document =
          DocumentModel(id: " ", uid: " ", title: " ", content: []);

      if (token != " ") {
        var res = await _dio.post("api/docs/create",
            data: document.toJson(),
            options: Options(headers: {"x-auth-token": token}));

        switch (res.statusCode) {
          case 200:
            final document = DocumentModel.fromJson(res.data.toString());
            response = ResponseModel(
                success: true,
                message: "Successfully created document",
                data: document);

            break;
          default:
            response = ResponseModel(
                success: false,
                message: "Some unknown error occured",
                data: null);
        }
      }
    } catch (e) {
      response =
          ResponseModel(success: false, message: e.toString(), data: null);
    }
    return response;
  }

  Future<ResponseModel> getDocuments() async {
    ResponseModel response = ResponseModel(
        success: false, message: "Some unknown error occured", data: null);

    ApiResponseDocumentModels? documents;

    try {
      String token = Prefs.getToken("TOKEN");

      if (token != " ") {
        var res = await _dio.get("api/docs/me",
            options: Options(headers: {"x-auth-token": token}));

        switch (res.statusCode) {
          case 200:
            documents = ApiResponseDocumentModels.fromJson(res.data.toString());
            response = ResponseModel(
                success: true,
                message: "Successfully fetched document",
                data: documents);
            break;
          default:
            response = ResponseModel(
                success: false, message: "Switch case failed", data: null);
        }
      }
    } catch (e) {
      documents = null;
      response =
          ResponseModel(success: false, message: e.toString(), data: null);
    }
    return response;
  }

  Future<ResponseModel> updateDocumentTitle(String id, String title) async {
    ResponseModel response = ResponseModel(
        success: false, message: "Some unknown error occured", data: null);

    try {
      String token = Prefs.getToken("TOKEN");

      DocumentModel document =
          DocumentModel(id: id, uid: " ", title: title, content: []);

      if (token != " ") {
        var res = await _dio.put("api/docs/title",
            data: document.toJson(),
            options: Options(headers: {"x-auth-token": token}));

        switch (res.statusCode) {
          case 200:
            final document = DocumentModel.fromJson(res.data.toString());
            print(document);
            response = ResponseModel(
                success: true,
                message: "Successfully updated document title",
                data: document);
            break;
          default:
            response = ResponseModel(
                success: false,
                message: "Some unknown error occured",
                data: null);
        }
      }
    } catch (e) {
      response =
          ResponseModel(success: false, message: e.toString(), data: null);
    }
    return response;
  }

  Future<ResponseModel> getDocumentById(String id) async {
    ResponseModel response = ResponseModel(
        success: false, message: "Some unknown error occured", data: null);

    try {
      String token = Prefs.getToken("TOKEN");

      if (token != " ") {
        var res = await _dio.get("api/docs/$id",
            options: Options(headers: {"x-auth-token": token}));

        switch (res.statusCode) {
          case 200:
            final document = DocumentModel.fromJson(res.data.toString());
            response = ResponseModel(
                success: true,
                message: "Successfully fetched document",
                data: document);
            break;

          default:
            throw 'This Document does not exist, please create a new one.';
        }
      }
    } catch (e) {
      ResponseModel response =
          ResponseModel(success: false, message: e.toString(), data: null);
    }
    return response;
  }
}
