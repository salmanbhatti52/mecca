import 'dart:convert';

import 'package:MeccaIslamicCenter/APIModels/GetBooksModel.dart';
import 'package:MeccaIslamicCenter/APIModels/RelatedBooksModel.dart';
import 'package:MeccaIslamicCenter/APIModels/SignUp_LogIn_Model.dart';
import 'package:MeccaIslamicCenter/APIModels/all_bookmarked_books.dart';
import 'package:MeccaIslamicCenter/APIModels/book_download_model.dart';
import 'package:MeccaIslamicCenter/APIModels/book_view.dart';
import 'package:MeccaIslamicCenter/APIModels/forgetPasswordModel.dart';
import 'package:http/http.dart' as http;

import '../APIModels/API_Response.dart';
import '../APIModels/category_model_get.dart';
import '../APIModels/popular_books_model.dart';

class ApiServices {
  // SIGN UP API FUNCTION
  Future<APIResponse<SignUpLogInClass>> signUpAPI(Map data) async {
    String API = 'https://mecca.eigix.net/api/signup';
    return http.post(Uri.parse(API), body: data).then((value) {
      if (value.statusCode == 200) {
        final jsonData = json.decode(value.body);

        if (jsonData['data'] != null) {
          final itemCat = SignUpLogInClass.fromMap(jsonData['data']);
          return APIResponse<SignUpLogInClass>(
              data: itemCat,
              status: jsonData['status'],
              message: jsonData['message']);
        } else {
          return APIResponse<SignUpLogInClass>(
              data: SignUpLogInClass(),
              status: jsonData['status'],
              message: jsonData['message']);
        }
      }
      return APIResponse<SignUpLogInClass>(
        status: APIResponse.fromMap(json.decode(value.body)).status,
        message: APIResponse.fromMap(json.decode(value.body)).message,
      );
    }).onError((error, stackTrace) => APIResponse<SignUpLogInClass>(
          status: error.toString(),
          message: stackTrace.toString(),
        ));
  }

// LOG IN API FUNCTION
  Future<APIResponse<SignUpLogInClass>> logInAPI(Map data) async {
    String API = 'https://mecca.eigix.net/api/signin';
    return http.post(Uri.parse(API), body: data).then((value) {
      print("sad " + value.statusCode.toString());
      if (value.statusCode == 200) {
        final jsonData = json.decode(value.body);
        print("Here " + jsonData.toString());
        if (jsonData['data'] != null) {
          final itemCat = SignUpLogInClass.fromMap(jsonData['data']);
          return APIResponse<SignUpLogInClass>(
              data: itemCat,
              status: jsonData['status'],
              message: jsonData['message']);
        } else {
          return APIResponse<SignUpLogInClass>(
              data: SignUpLogInClass(),
              status: jsonData['status'],
              message: jsonData['message']);
        }
      }
      return APIResponse<SignUpLogInClass>(
        status: APIResponse.fromMap(json.decode(value.body)).status,
        message: APIResponse.fromMap(json.decode(value.body)).message,
      );
    }).onError((error, stackTrace) => APIResponse<SignUpLogInClass>(
          status: error.toString(),
          message: stackTrace.toString(),
        ));
  }

  // FORGET PASSWORD API FUNCTION
  Future<APIResponse<DataForget>> forgetPassword(Map data) async {
    String API = 'https://mecca.eigix.net/api/forgot_password';
    return http.post(Uri.parse(API), body: data).then((value) {
      //print("sad " + value.statusCode.toString());
      if (value.statusCode == 200) {
        final jsonData = json.decode(value.body);
        //print("Here " + jsonData.toString());
        if (jsonData['data'] != null) {
          final itemCat = DataForget.fromMap(jsonData['data']);
          return APIResponse<DataForget>(
              data: itemCat,
              status: jsonData['status'],
              message: jsonData['message']);
        } else {
          return APIResponse<DataForget>(
              data: DataForget(),
              status: jsonData['status'],
              message: jsonData['message']);
        }
      }
      return APIResponse<DataForget>(
        status: APIResponse.fromMap(json.decode(value.body)).status,
        message: APIResponse.fromMap(json.decode(value.body)).message,
      );
    }).onError((error, stackTrace) => APIResponse<DataForget>(
          status: error.toString(),
          message: stackTrace.toString(),
        ));
  }

  // modify password using otp api
  Future<APIResponse<List<SignUpLogInClass>>> updateForgetPassword(Map data) {
    print('object1');
    String api = 'https://mecca.eigix.net/api/modify_password';
    return http
        .post(
      Uri.parse(
        api,
      ),
      body: data,
    )
        .then((value) {
      print('success! ${value.body.toString()}');
      if (value.statusCode == 200) {
        print('success!');
        final jsonResult = jsonDecode(value.body);
        if (jsonResult['data'] != null) {
          final jsonResultArray = <SignUpLogInClass>[];
          for (var item in jsonResult['data']) {
            final jsonData = SignUpLogInClass.fromMap(item);
            jsonResultArray.add(jsonData);
          }
          // final jsonData = Signin_Signup_Model.fromMap(
          //   jsonResult['data'],
          // );
          return APIResponse<List<SignUpLogInClass>>(
            data: jsonResultArray,
            status: jsonResult['status'],
            message: jsonResult['message'],
          );
        } else {
          return APIResponse<List<SignUpLogInClass>>(
            data: [],
            status: jsonResult['status'],
            message: jsonResult['message'],
          );
        }
      }
      return APIResponse<List<SignUpLogInClass>>(
        status: APIResponse.fromMap(
          jsonDecode(value.body),
        ).status,
        message: APIResponse.fromMap(
          jsonDecode(value.body),
        ).message,
      );
    }).onError(
      (error, stackTrace) => APIResponse<List<SignUpLogInClass>>(
        status: error.toString(),
        message: stackTrace.toString(),
      ),
    );
  }

  // book view api
  Future<APIResponse<BookViewModel>> bookView(Map data) async {
    String API = 'https://mecca.eigix.net/api/book_view';
    return http.post(Uri.parse(API), body: data).then((value) {
      if (value.statusCode == 200) {
        final jsonData = json.decode(value.body);

        if (jsonData['data'] != null) {
          final itemCat = BookViewModel.fromMap(jsonData['data']);
          return APIResponse<BookViewModel>(
              data: itemCat,
              status: jsonData['status'],
              message: jsonData['message']);
        } else {
          return APIResponse<BookViewModel>(
              data: BookViewModel(),
              status: jsonData['status'],
              message: jsonData['message']);
        }
      }
      return APIResponse<BookViewModel>(
        status: APIResponse.fromMap(json.decode(value.body)).status,
        message: APIResponse.fromMap(json.decode(value.body)).message,
      );
    }).onError((error, stackTrace) => APIResponse<BookViewModel>(
          status: error.toString(),
          message: stackTrace.toString(),
        ));
  }

  // add bookmarks api
  Future<APIResponse<BookViewModel>> addBookMark(Map data) async {
    String API = 'https://mecca.eigix.net/api/add_book_bookmark';
    return http.post(Uri.parse(API), body: data).then((value) {
      if (value.statusCode == 200) {
        final jsonData = json.decode(value.body);

        if (jsonData['data'] != null) {
          //final itemCat = BookViewModel.fromMap(jsonData['data']);
          return APIResponse<BookViewModel>(
              // data: itemCat,
              data: BookViewModel(),
              status: jsonData['status'],
              message: jsonData['message']);
        } else {
          return APIResponse<BookViewModel>(
              data: BookViewModel(),
              status: jsonData['status'],
              message: jsonData['message']);
        }
      }
      return APIResponse<BookViewModel>(
        status: APIResponse.fromMap(json.decode(value.body)).status,
        message: APIResponse.fromMap(json.decode(value.body)).message,
      );
    }).onError((error, stackTrace) => APIResponse<BookViewModel>(
          status: error.toString(),
          message: stackTrace.toString(),
        ));
  }

  // remove from bookmark api
  Future<APIResponse> removeBookMark(Map data) {
    String api = 'https://mecca.eigix.net/api/remove_book_bookmark';
    return http.post(Uri.parse(api), body: data).then((value) {
      if (value.statusCode == 200) {
        final result = jsonDecode(value.body);
        return APIResponse(
          status: result['status'],
          message: result['message'],
        );
      }
      return APIResponse(
        status: APIResponse.fromMap(jsonDecode(value.body)).status,
        message: APIResponse.fromMap(jsonDecode(value.body)).message,
      );
    }).onError(
      (error, stackTrace) => APIResponse(
        status: error.toString(),
        message: stackTrace.toString(),
      ),
    );
  }

  // all books bookmarked api
  Future<APIResponse<List<AllBooksBookMarked>>> allBookMarkedBooks(Map data) {
    print('object1');
    String api = 'https://mecca.eigix.net/api/all_bookmarked_books';
    return http
        .post(
      Uri.parse(
        api,
      ),
      body: data,
    )
        .then((value) {
      print('success! ${value.body.toString()}');
      if (value.statusCode == 200) {
        print('success!');
        final jsonResult = jsonDecode(value.body);
        if (jsonResult['data'] != null) {
          final jsonResultArray = <AllBooksBookMarked>[];
          for (var item in jsonResult['data']) {
            final jsonData = AllBooksBookMarked.fromMap(item);
            jsonResultArray.add(jsonData);
          }
          // final jsonData = Signin_Signup_Model.fromMap(
          //   jsonResult['data'],
          // );
          return APIResponse<List<AllBooksBookMarked>>(
            data: jsonResultArray,
            status: jsonResult['status'],
            message: jsonResult['message'],
          );
        } else {
          return APIResponse<List<AllBooksBookMarked>>(
            data: [],
            status: jsonResult['status'],
            message: jsonResult['message'],
          );
        }
      }
      return APIResponse<List<AllBooksBookMarked>>(
        status: APIResponse.fromMap(
          jsonDecode(value.body),
        ).status,
        message: APIResponse.fromMap(
          jsonDecode(value.body),
        ).message,
      );
    }).onError(
      (error, stackTrace) => APIResponse<List<AllBooksBookMarked>>(
        status: error.toString(),
        message: stackTrace.toString(),
      ),
    );
  }

  // Book download api
  Future<APIResponse<BookDownloadModel>> bookDownload(Map data) async {
    String API = 'https://mecca.eigix.net/api/book_download';
    return http.post(Uri.parse(API), body: data).then((value) {
      if (value.statusCode == 200) {
        final jsonData = json.decode(value.body);

        if (jsonData['data'] != null) {
          final itemCat = BookDownloadModel.fromMap(jsonData['data']);
          return APIResponse<BookDownloadModel>(
              data: itemCat,
              status: jsonData['status'],
              message: jsonData['message']);
        } else {
          return APIResponse<BookDownloadModel>(
              data: BookDownloadModel(),
              status: jsonData['status'],
              message: jsonData['message']);
        }
      }
      return APIResponse<BookDownloadModel>(
        status: APIResponse.fromMap(json.decode(value.body)).status,
        message: APIResponse.fromMap(json.decode(value.body)).message,
      );
    }).onError((error, stackTrace) => APIResponse<BookDownloadModel>(
          status: error.toString(),
          message: stackTrace.toString(),
        ));
  }

  // search book api
  Future<APIResponse<List<AllBooksBookMarked>>> searchBook(Map data) {
    print('object1');
    String api = 'https://mecca.eigix.net/api/search_book';
    return http
        .post(
      Uri.parse(
        api,
      ),
      body: data,
    )
        .then((value) {
      print('success! ${value.body.toString()}');
      if (value.statusCode == 200) {
        print('success!');
        final jsonResult = jsonDecode(value.body);
        if (jsonResult['data'] != null) {
          final jsonResultArray = <AllBooksBookMarked>[];
          for (var item in jsonResult['data']) {
            final jsonData = AllBooksBookMarked.fromMap(item);
            jsonResultArray.add(jsonData);
          }
          // final jsonData = Signin_Signup_Model.fromMap(
          //   jsonResult['data'],
          // );
          return APIResponse<List<AllBooksBookMarked>>(
            data: jsonResultArray,
            status: jsonResult['status'],
            message: jsonResult['message'],
          );
        } else {
          return APIResponse<List<AllBooksBookMarked>>(
            data: [],
            status: jsonResult['status'],
            message: jsonResult['message'],
          );
        }
      }
      return APIResponse<List<AllBooksBookMarked>>(
        status: APIResponse.fromMap(
          jsonDecode(value.body),
        ).status,
        message: APIResponse.fromMap(
          jsonDecode(value.body),
        ).message,
      );
    }).onError(
      (error, stackTrace) => APIResponse<List<AllBooksBookMarked>>(
        status: error.toString(),
        message: stackTrace.toString(),
      ),
    );
  }

  // get categories api
  Future<APIResponse<List<CategoryGetModel>>> getCategory() {
    print('object1');
    String api = 'https://mecca.eigix.net/api/categories';
    return http
        .get(
      Uri.parse(
        api,
      ),
    )
        .then((value) {
      print('success! ${value.body.toString()}');
      if (value.statusCode == 200) {
        print('success!');
        final jsonResult = jsonDecode(value.body);
        if (jsonResult['data'] != null) {
          final jsonResultArray = <CategoryGetModel>[];
          for (var item in jsonResult['data']) {
            final jsonData = CategoryGetModel.fromMap(item);
            jsonResultArray.add(jsonData);
          }
          // final jsonData = Signin_Signup_Model.fromMap(
          //   jsonResult['data'],
          // );
          return APIResponse<List<CategoryGetModel>>(
            data: jsonResultArray,
            status: jsonResult['status'],
            message: jsonResult['message'],
          );
        } else {
          return APIResponse<List<CategoryGetModel>>(
            data: [],
            status: jsonResult['status'],
            message: jsonResult['message'],
          );
        }
      }
      return APIResponse<List<CategoryGetModel>>(
        status: APIResponse.fromMap(
          jsonDecode(value.body),
        ).status,
        message: APIResponse.fromMap(
          jsonDecode(value.body),
        ).message,
      );
    }).onError(
      (error, stackTrace) => APIResponse<List<CategoryGetModel>>(
        status: error.toString(),
        message: stackTrace.toString(),
      ),
    );
  }

  // get books api
  Future<APIResponse<List<GetBooksModel>>> getBooks() {
    print('object1');
    String api = 'https://mecca.eigix.net/api/books';
    return http
        .get(
      Uri.parse(
        api,
      ),
    )
        .then((value) {
      print('success! ${value.body.toString()}');
      if (value.statusCode == 200) {
        print('success!');
        final jsonResult = jsonDecode(value.body);
        if (jsonResult['data'] != null) {
          final jsonResultArray = <GetBooksModel>[];
          for (var item in jsonResult['data']) {
            final jsonData = GetBooksModel.fromMap(item);
            jsonResultArray.add(jsonData);
          }
          // final jsonData = Signin_Signup_Model.fromMap(
          //   jsonResult['data'],
          // );
          return APIResponse<List<GetBooksModel>>(
            data: jsonResultArray,
            status: jsonResult['status'],
            message: jsonResult['message'],
          );
        } else {
          return APIResponse<List<GetBooksModel>>(
            data: [],
            status: jsonResult['status'],
            message: jsonResult['message'],
          );
        }
      }
      return APIResponse<List<GetBooksModel>>(
        status: APIResponse.fromMap(
          jsonDecode(value.body),
        ).status,
        message: APIResponse.fromMap(
          jsonDecode(value.body),
        ).message,
      );
    }).onError(
      (error, stackTrace) => APIResponse<List<GetBooksModel>>(
        status: error.toString(),
        message: stackTrace.toString(),
      ),
    );
  }

  // post poplar books api
  Future<APIResponse<List<PoplarBooksModel>>> getPopularBooks(Map data) {
    print('object1');
    String api = 'https://mecca.eigix.net/api/popular_books';
    return http
        .post(
      Uri.parse(
        api,
      ),
      body: data,
    )
        .then((value) {
      print('success! ${value.body.toString()}');
      if (value.statusCode == 200) {
        print('success!');
        final jsonResult = jsonDecode(value.body);
        if (jsonResult['data'] != null) {
          final jsonResultArray = <PoplarBooksModel>[];
          for (var item in jsonResult['data']) {
            final jsonData = PoplarBooksModel.fromMap(item);
            jsonResultArray.add(jsonData);
            print("https://mecca.eigix.net/public/${jsonResult['book_url']}");
          }
          // final jsonData = Signin_Signup_Model.fromMap(
          //   jsonResult['data'],
          // );
          return APIResponse<List<PoplarBooksModel>>(
            data: jsonResultArray,
            status: jsonResult['status'],
            message: jsonResult['message'],
          );
        } else {
          return APIResponse<List<PoplarBooksModel>>(
            data: [],
            status: jsonResult['status'],
            message: jsonResult['message'],
          );
        }
      }
      return APIResponse<List<PoplarBooksModel>>(
        status: APIResponse.fromMap(
          jsonDecode(value.body),
        ).status,
        message: APIResponse.fromMap(
          jsonDecode(value.body),
        ).message,
      );
    }).onError(
      (error, stackTrace) => APIResponse<List<PoplarBooksModel>>(
        status: error.toString(),
        message: stackTrace.toString(),
      ),
    );
  }

  // search books api
  Future<APIResponse<List<AllBooksBookMarked>>> searchBooks(Map data) {
    print('object1');
    String api = 'https://mecca.eigix.net/api/search_book';
    return http
        .post(
      Uri.parse(
        api,
      ),
      body: data,
    )
        .then((value) {
      print('success! ${value.body.toString()}');
      if (value.statusCode == 200) {
        print('success!');
        final jsonResult = jsonDecode(value.body);
        if (jsonResult['data'] != null) {
          final jsonResultArray = <AllBooksBookMarked>[];
          for (var item in jsonResult['data']) {
            final jsonData = AllBooksBookMarked.fromMap(item);
            jsonResultArray.add(jsonData);
            print("https://mecca.eigix.net/public/${jsonResult['book_url']}");
          }
          // final jsonData = Signin_Signup_Model.fromMap(
          //   jsonResult['data'],
          // );
          return APIResponse<List<AllBooksBookMarked>>(
            data: jsonResultArray,
            status: jsonResult['status'],
            message: jsonResult['message'],
          );
        } else {
          return APIResponse<List<AllBooksBookMarked>>(
            data: [],
            status: jsonResult['status'],
            message: jsonResult['message'],
          );
        }
      }
      return APIResponse<List<AllBooksBookMarked>>(
        status: APIResponse.fromMap(
          jsonDecode(value.body),
        ).status,
        message: APIResponse.fromMap(
          jsonDecode(value.body),
        ).message,
      );
    }).onError(
      (error, stackTrace) => APIResponse<List<AllBooksBookMarked>>(
        status: error.toString(),
        message: stackTrace.toString(),
      ),
    );
  }

  // update password api
  Future<APIResponse<SignUpLogInClass>> updatePassword(Map data) async {
    String API = 'https://mecca.eigix.net/api/change_password';
    return http.post(Uri.parse(API), body: data).then((value) {
      print("sad " + value.statusCode.toString());
      if (value.statusCode == 200) {
        final jsonData = json.decode(value.body);
        print("Here " + jsonData.toString());
        if (jsonData['data'] != null) {
          final itemCat = SignUpLogInClass.fromMap(jsonData['data']);
          return APIResponse<SignUpLogInClass>(
              data: itemCat,
              status: jsonData['status'],
              message: jsonData['message']);
        } else {
          return APIResponse<SignUpLogInClass>(
              data: SignUpLogInClass(),
              status: jsonData['status'],
              message: jsonData['message']);
        }
      }
      return APIResponse<SignUpLogInClass>(
        status: APIResponse.fromMap(json.decode(value.body)).status,
        message: APIResponse.fromMap(json.decode(value.body)).message,
      );
    }).onError((error, stackTrace) => APIResponse<SignUpLogInClass>(
          status: error.toString(),
          message: stackTrace.toString(),
        ));
  }

  // delete account api
  Future<APIResponse> deleteAccount(Map data) {
    String api = 'https://mecca.eigix.net/api/delete_account';
    return http.post(Uri.parse(api), body: data).then((value) {
      if (value.statusCode == 200) {
        final result = jsonDecode(value.body);
        return APIResponse(
          status: result['status'],
          message: result['message'],
        );
      }
      return APIResponse(
        status: APIResponse.fromMap(jsonDecode(value.body)).status,
        message: APIResponse.fromMap(jsonDecode(value.body)).message,
      );
    }).onError(
      (error, stackTrace) => APIResponse(
        status: error.toString(),
        message: stackTrace.toString(),
      ),
    );
  }

  // related books api
  Future<APIResponse<List<RelatedBooksModel>>> relatedBooks(Map data) {
    print('object1');
    String api = 'https://mecca.eigix.net/api/related_books';
    return http
        .post(
      Uri.parse(
        api,
      ),
      body: data,
    )
        .then((value) {
      print('success! ${value.body.toString()}');
      if (value.statusCode == 200) {
        print('success!');
        final jsonResult = jsonDecode(value.body);
        if (jsonResult['data'] != null) {
          final jsonResultArray = <RelatedBooksModel>[];
          for (var item in jsonResult['data']) {
            final jsonData = RelatedBooksModel.fromMap(item);
            jsonResultArray.add(jsonData);
          }
          // final jsonData = Signin_Signup_Model.fromMap(
          //   jsonResult['data'],
          // );
          return APIResponse<List<RelatedBooksModel>>(
            data: jsonResultArray,
            status: jsonResult['status'],
            message: jsonResult['message'],
          );
        } else {
          return APIResponse<List<RelatedBooksModel>>(
            data: [],
            status: jsonResult['status'],
            message: jsonResult['message'],
          );
        }
      }
      return APIResponse<List<RelatedBooksModel>>(
        status: APIResponse.fromMap(
          jsonDecode(value.body),
        ).status,
        message: APIResponse.fromMap(
          jsonDecode(value.body),
        ).message,
      );
    }).onError(
      (error, stackTrace) => APIResponse<List<RelatedBooksModel>>(
        status: error.toString(),
        message: stackTrace.toString(),
      ),
    );
  }
}
