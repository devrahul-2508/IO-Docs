import 'dart:convert';

import 'package:flutter/foundation.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class DocumentModel {
  final String id;
  final String uid;
  final String title;
  final List content;
  DocumentModel({
    required this.id,
    required this.uid,
    required this.title,
    required this.content,
  });

  DocumentModel copyWith({
    String? id,
    String? uid,
    String? title,
    List? content,
  }) {
    return DocumentModel(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      title: title ?? this.title,
      content: content ?? this.content,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'uid': uid,
      'title': title,
      'content': content,
    };
  }

  factory DocumentModel.fromMap(Map<String, dynamic> map) {
    return DocumentModel(
      id: map['_id'] as String,
      uid: map['uid'] as String,
      title: map['title'] as String,
      content: List.from((map['content'] as List),
    ));
  }

  String toJson() => json.encode(toMap());

  factory DocumentModel.fromJson(String source) => DocumentModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'DocumentModel(id: $id, uid: $uid, title: $title, content: $content)';
  }

  @override
  bool operator ==(covariant DocumentModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.uid == uid &&
      other.title == title &&
      listEquals(other.content, content);
  }

  @override
  int get hashCode {
    return id.hashCode ^
      uid.hashCode ^
      title.hashCode ^
      content.hashCode;
  }
}
