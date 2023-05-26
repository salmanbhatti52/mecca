class BookDownloadModel {
  int? books_id, categories_id, authors_id;
  String? title;
  String? book_url;
  int? downloads;
  String? date_added;
  String? status;

  BookDownloadModel({
    this.categories_id,
    this.book_url,
    this.authors_id,
    this.title,
    this.date_added,
    this.books_id,
    this.status,
    this.downloads,
  });

  Map<String, dynamic> toMap() {
    return {
      'books_id': books_id,
      'categories_id': categories_id,
      'authors_id': authors_id,
      'title': title,
      'book_url': book_url,
      'downloads': downloads,
      'date_added': date_added,
      'status': status,
    };
  }

  factory BookDownloadModel.fromMap(Map<String, dynamic> map) {
    return BookDownloadModel(
      books_id: map['books_id'] ?? -1,
      categories_id: map['categories_id'] ?? -1,
      authors_id: map['authors_id'] ?? -1,
      title: map['title'] ?? '',
      book_url: map['book_url'] ?? '',
      downloads: map['downloads'] ?? -1,
      date_added: map['date_added'] ?? '',
      status: map['status'] ?? '',
    );
  }
}
