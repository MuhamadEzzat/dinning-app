import 'package:cloud_firestore/cloud_firestore.dart';

class DiningModel {
  final String id;
  final String name;
  final String description;
  final String? imageUrl;
  final String category;
  final double rating;
  final int reviewCount;
  final String address;
  final String phone;
  final String? website;
  final List<String> tags;
  final Map<String, dynamic>? location; // {lat: double, lng: double}
  final List<String>? menuItems;
  final Map<String, dynamic>? operatingHours;
  final bool isActive;
  final bool isKidsFriendly;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? createdBy;
  final List<String>? allowedRoles; // Role-based access control

  const DiningModel({
    required this.id,
    required this.name,
    required this.description,
    this.imageUrl,
    required this.category,
    this.rating = 0.0,
    this.reviewCount = 0,
    required this.address,
    required this.phone,
    this.website,
    this.tags = const [],
    this.location,
    this.menuItems,
    this.operatingHours,
    this.isActive = true,
    this.isKidsFriendly = false,
    required this.createdAt,
    required this.updatedAt,
    this.createdBy,
    this.allowedRoles,
  });

  factory DiningModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return DiningModel(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'],
      category: data['category'] ?? '',
      rating: (data['rating'] ?? 0.0).toDouble(),
      reviewCount: data['reviewCount'] ?? 0,
      address: data['address'] ?? '',
      phone: data['phone'] ?? '',
      website: data['website'],
      tags: data['tags']?.cast<String>() ?? [],
      location: data['location'],
      menuItems: data['menuItems']?.cast<String>(),
      operatingHours: data['operatingHours'],
      isActive: data['isActive'] ?? true,
      isKidsFriendly: data['isKidsFriendly'] ?? false,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      createdBy: data['createdBy'],
      allowedRoles: data['allowedRoles']?.cast<String>(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'category': category,
      'rating': rating,
      'reviewCount': reviewCount,
      'address': address,
      'phone': phone,
      'website': website,
      'tags': tags,
      'location': location,
      'menuItems': menuItems,
      'operatingHours': operatingHours,
      'isActive': isActive,
      'isKidsFriendly': isKidsFriendly,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'createdBy': createdBy,
      'allowedRoles': allowedRoles,
    };
  }

  DiningModel copyWith({
    String? id,
    String? name,
    String? description,
    String? imageUrl,
    String? category,
    double? rating,
    int? reviewCount,
    String? address,
    String? phone,
    String? website,
    List<String>? tags,
    Map<String, dynamic>? location,
    List<String>? menuItems,
    Map<String, dynamic>? operatingHours,
    bool? isActive,
    bool? isKidsFriendly,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? createdBy,
    List<String>? allowedRoles,
  }) {
    return DiningModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      website: website ?? this.website,
      tags: tags ?? this.tags,
      location: location ?? this.location,
      menuItems: menuItems ?? this.menuItems,
      operatingHours: operatingHours ?? this.operatingHours,
      isActive: isActive ?? this.isActive,
      isKidsFriendly: isKidsFriendly ?? this.isKidsFriendly,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      createdBy: createdBy ?? this.createdBy,
      allowedRoles: allowedRoles ?? this.allowedRoles,
    );
  }

  // Helper method to check if user can access this dining option
  bool canUserAccess(String userRole) {
    if (allowedRoles == null || allowedRoles!.isEmpty) return true;
    return allowedRoles!.contains(userRole);
  }

  // Helper method to check if it's suitable for kids mode
  bool isSuitableForKids() {
    return isKidsFriendly && isActive;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DiningModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'DiningModel(id: $id, name: $name, category: $category)';
  }
}

