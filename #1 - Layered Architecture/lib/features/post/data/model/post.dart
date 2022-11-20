import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter/foundation.dart' show immutable;

part 'post.g.dart';

List<Post> postFromJson(String str) =>
    List<Post>.from(json.decode(str).map((x) => Post.fromJson(x)));

String postToJson(List<Post> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@immutable
@JsonSerializable()
class Post {
  const Post({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
  });

  final int id;
  @JsonKey(name: 'user_id')
  final int userId;
  final String title;
  final String body;

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);

  Map<String, dynamic> toJson() => _$PostToJson(this);

  @override
  String toString() {
    return 'Post{id: $id, userId: $userId, title: $title, body: $body}';
  }
}
