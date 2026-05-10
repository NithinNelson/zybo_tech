import 'package:equatable/equatable.dart';

class CategoryModel extends Equatable {
  final String id;
  final String name;
  final bool isSynced;
  final bool isDeleted;

  const CategoryModel({
    required this.id,
    required this.name,
    this.isSynced = false,
    this.isDeleted = false,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] ?? json['category_id'],
      name: json['name'],
      isSynced: json['is_synced'] == 1 || json['is_synced'] == true,
      isDeleted: json['is_deleted'] == 1 || json['is_deleted'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'is_synced': isSynced ? 1 : 0,
      'is_deleted': isDeleted ? 1 : 0,
    };
  }
  
  Map<String, dynamic> toApiJson() {
    return {
      'category_id': id,
      'name': name,
    };
  }

  CategoryModel copyWith({
    String? id,
    String? name,
    bool? isSynced,
    bool? isDeleted,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      isSynced: isSynced ?? this.isSynced,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  @override
  List<Object?> get props => [id, name, isSynced, isDeleted];
}
