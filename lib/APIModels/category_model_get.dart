class CategoryGetModel {
  int? categories_id;
  String? name, added_date, status;
  bool? isCategorySelected = false;

  CategoryGetModel({
    this.status,
    this.added_date,
    this.name,
    this.categories_id,
    this.isCategorySelected = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'categories_id': categories_id,
      'name': name,
      'added_date': added_date,
      'status': status,
    };
  }

  factory CategoryGetModel.fromMap(Map<String, dynamic> map) {
    return CategoryGetModel(
      categories_id: map['categories_id'] ?? -1,
      name: map['name'] ?? '',
      added_date: map['added_date'] ?? '',
      status: map['status'] ?? '',
    );
  }
}
