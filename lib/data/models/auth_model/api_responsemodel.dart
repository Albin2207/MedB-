class ApiResponse<T> {
  final bool success;
  final String message;
  final T? data;

  ApiResponse({required this.success, required this.message, this.data});

  factory ApiResponse.success(String message, {T? data}) {
    return ApiResponse(success: true, message: message, data: data);
  }

  factory ApiResponse.error(String message) {
    return ApiResponse(success: false, message: message);
  }
}
