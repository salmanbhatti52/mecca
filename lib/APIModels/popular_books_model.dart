class AuthorBook {
  int? authors_id;
  String? name, description, image, added_date, status;

  AuthorBook({
    this.added_date,
    this.status,
    this.name,
    this.description,
    this.image,
    this.authors_id,
  });

  Map<String, dynamic> toMap() {
    return {
      'authors_id': authors_id,
      'name': name,
      'description': description,
      'image': image,
      'added_date': added_date,
      'status': status,
    };
  }

  factory AuthorBook.fromMap(Map<String, dynamic> map) {
    return AuthorBook(
      authors_id: map['authors_id'] ?? -1,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      image: map['image'] ?? '',
      added_date: map['added_date'] ?? '',
      status: map['status'] ?? '',
    );
  }
}

class CategoryBook {
  int? categories_id;
  String? name, added_date, status;

  CategoryBook({
    this.name,
    this.status,
    this.added_date,
    this.categories_id,
  });

  Map<String, dynamic> toMap() {
    return {
      'categories_id': categories_id,
      'name': name,
      'added_date': added_date,
      'status': status,
    };
  }

  factory CategoryBook.fromMap(Map<String, dynamic> map) {
    return CategoryBook(
      categories_id: map['categories_id'] ?? -1,
      name: map['name'] ?? '',
      added_date: map['added_date'] ?? '',
      status: map['status'] ?? '',
    );
  }
}

class PoplarBooksModel {
  int? books_id, categories_id, authors_id;
  String? title, book_url, cover;
  int? downloads, pages;
  String? date_added, status;
  CategoryBook? category;
  AuthorBook? author;
  String? bookmarked;
  int? view_count;

  PoplarBooksModel({
    this.status,
    this.view_count,
    this.books_id,
    this.date_added,
    this.title,
    this.author,
    this.authors_id,
    this.book_url,
    this.bookmarked,
    this.categories_id,
    this.category,
    this.downloads,
    this.cover,
    this.pages,
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
      'category': category,
      'author': author,
      'bookmarked': bookmarked,
      'view_count': view_count,
      'cover': cover,
      'pages': pages,
    };
  }

  factory PoplarBooksModel.fromMap(Map<String, dynamic> map) {
    return PoplarBooksModel(
      books_id: map['books_id'] ?? -1,
      categories_id: map['categories_id'] ?? -1,
      authors_id: map['authors_id'] ?? -1,
      title: map['title'] ?? '',
      book_url: map['book_url'] ?? '',
      downloads: map['downloads'] ?? '',
      date_added: map['date_added'] ?? '',
      status: map['status'] ?? '',
      cover: map['cover'] ?? '',
      view_count: map['view_count'] ?? -1,
      // category: CategoryBook.fromMap(map['category'],),
      // author: AuthorBook.fromMap(map['author'],),
      category: map['category'] != null ? CategoryBook.fromMap(map['category']) : null,
      author: map['author'] != null ? AuthorBook.fromMap(map['author']) : null,
      bookmarked: map['bookmarked'] ?? '',
      pages: map['pages'] ?? -1,
    );
  }
}
