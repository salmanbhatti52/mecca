class BookViewModel {
  int? books_views_id, users_customers_id, books_id;
  String? added_date, status;

  BookViewModel({
    this.status,
    this.users_customers_id,
    this.added_date,
    this.books_id,
    this.books_views_id,
  });

  Map<String, dynamic> toMap() {
    return {
      'books_views_id': books_views_id,
      'users_customers_id': users_customers_id,
      'books_id': books_id,
      'added_date': added_date,
      'status': status,
    };
  }

  factory BookViewModel.fromMap(Map<String, dynamic> map) {
    return BookViewModel(
      books_views_id: map['books_views_id'],
      users_customers_id: map['users_customers_id'],
      books_id: map['books_id'],
      added_date: map['added_date'] ?? '',
      status: map['status'] ?? '',
    );
  }
}
