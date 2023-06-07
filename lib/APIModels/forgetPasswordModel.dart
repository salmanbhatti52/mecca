class DataForget {
  int? otp;
  String? message;

  DataForget({
    this.message,
    this.otp,
  });

  Map<String, dynamic> toMap() {
    return {
      'otp': otp,
      'message': message,
    };
  }

  factory DataForget.fromMap(Map<String, dynamic> map) {
    return DataForget(
      otp: map['otp'] ?? -1,
      message: map['message'] ?? '',
    );
  }
}

class ForgetApi {
  String? status;
  DataForget? data;
  String? message;

  ForgetApi({
    this.data,
    this.status,
    this.message,
  });

  Map<String, dynamic> toMap() {
    return {
      'status': status,
      'data': data,
      'message': message,
    };
  }

  factory ForgetApi.fromMap(Map<String, dynamic> map) {
    return ForgetApi(
      status: map['status'] ?? '',
      data: map['data'] as DataForget,
      message: map['message'] ?? '',
    );
  }
}
