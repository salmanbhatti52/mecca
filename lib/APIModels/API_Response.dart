class APIResponse<T> {
  T? data;
  String? message;
  String? status;

  APIResponse({
    this.status,
    this.message,
    this.data,
  });

  Map<String, dynamic> toMap() {
    return {
      'data': this.data,
      'message': this.message,
      'status': this.status,
    };
  }

  factory APIResponse.fromMap(Map<String, dynamic> map) {
    return APIResponse(
      data: map['data'] as T,
      message: map['message'] ?? '',
      status: map['status'] ?? '',
    );
  }
}
