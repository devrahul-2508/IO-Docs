// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:google_docs/models/document_model.dart';

class ApiResponseDocumentModels {
  final List<DocumentModel> documents;
  ApiResponseDocumentModels({
    required this.documents,
  });

  ApiResponseDocumentModels copyWith({
    List<DocumentModel>? documents,
  }) {
    return ApiResponseDocumentModels(
      documents: documents ?? this.documents,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'documents': documents.map((x) => x.toMap()).toList(),
    };
  }

  factory ApiResponseDocumentModels.fromMap(Map<String, dynamic> map) {
    return ApiResponseDocumentModels(
      documents: List<DocumentModel>.from((map['documents'] as List<dynamic>).map<DocumentModel>((x) => DocumentModel.fromMap(x as Map<String,dynamic>),),),
    );
  }

  String toJson() => json.encode(toMap());

  factory ApiResponseDocumentModels.fromJson(String source) => ApiResponseDocumentModels.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'ApiResponseDocumentModels(documents: $documents)';

  @override
  bool operator ==(covariant ApiResponseDocumentModels other) {
    if (identical(this, other)) return true;
  
    return 
      listEquals(other.documents, documents);
  }

  @override
  int get hashCode => documents.hashCode;
}
