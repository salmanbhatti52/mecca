class CatRelatedBooks {
  int? categories_id;
  String? name, added_date, status;

  CatRelatedBooks({
    this.status,
    this.name,
    this.categories_id,
    this.added_date,
  });

  Map<String, dynamic> toMap() {
    return {
      'categories_id': categories_id,
      'name': name,
      'added_date': added_date,
      'status': status,
    };
  }

  factory CatRelatedBooks.fromMap(Map<String, dynamic> map) {
    return CatRelatedBooks(
      categories_id: map['categories_id'] ?? -1,
      name: map['name'] ?? '',
      added_date: map['added_date'] ?? '',
      status: map['status'] ?? '',
    );
  }
}

class AuthorRelatedBooks {
  int? authors_id;
  String? name, description, image, added_date, status;

  AuthorRelatedBooks({
    this.name,
    this.status,
    this.authors_id,
    this.added_date,
    this.image,
    this.description,
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

  factory AuthorRelatedBooks.fromMap(Map<String, dynamic> map) {
    return AuthorRelatedBooks(
      authors_id: map['authors_id'] ?? -1,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      image: map['image'] ?? '',
      added_date: map['added_date'] ?? '',
      status: map['status'] ?? '',
    );
  }
}

class RelatedBooksModel {
  int? books_id, categories_id, authors_id;
  String? title;
  int? pages;
  String? book_url, cover;
  int? downloads;
  String? date_added, status;
  CatRelatedBooks? category;
  AuthorRelatedBooks? author;
  String? bookmarked;

  RelatedBooksModel({
    this.authors_id,
    this.status,
    this.categories_id,
    this.book_url,
    this.title,
    this.pages,
    this.books_id,
    this.cover,
    this.category,
    this.author,
    this.downloads,
    this.bookmarked,
    this.date_added,
  });

  Map<String, dynamic> toMap() {
    return {
      'books_id': books_id,
      'categories_id': categories_id,
      'authors_id': authors_id,
      'title': title,
      'pages': pages,
      'book_url': book_url,
      'cover': cover,
      'downloads': downloads,
      'date_added': date_added,
      'status': status,
      'category': category,
      'author': author,
      'bookmarked': bookmarked,
    };
  }

  factory RelatedBooksModel.fromMap(Map<String, dynamic> map) {
    return RelatedBooksModel(
      books_id: map['books_id'] ?? -1,
      categories_id: map['categories_id'] ?? -1,
      authors_id: map['authors_id'] ?? -1,
      title: map['title'] ?? '',
      pages: map['pages'] ?? -1,
      book_url: map['book_url'] ?? '',
      cover: map['cover'] ?? '',
      downloads: map['downloads'] ?? -1,
      date_added: map['date_added'] ?? '',
      status: map['status'] ?? '',
      // category: map['category'] != null ? CategoryBook.fromMap(map['category']) : null,
      // author: map['author'] != null ? AuthorBook.fromMap(map['author']) : null,
      category:  map['category'] != null ? CatRelatedBooks.fromMap(map['category'],) : null,
      author: map['author'] != null ?AuthorRelatedBooks.fromMap(map['author'],) : null,
      bookmarked: map['bookmarked'] ?? '',
    );
  }
}
