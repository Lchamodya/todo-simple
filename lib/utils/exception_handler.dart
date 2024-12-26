import 'dart:io';

String handleException(dynamic exception) {
  if (exception is FormatException) {
    return 'Error: The provided data format is invalid. Please correct your input.';
  } else if (exception is FileSystemException) {
    return 'Error: A file system issue occurred. Please check your file paths or permissions.';
  } else if (exception is SocketException) {
    return 'Error: Network issue detected. Please check your internet connection.';
  } else if (exception is HttpException) {
    return 'Error: Unable to complete the request. Please check the server or your connection.';
  } else {
    return 'Error: An unexpected issue occurred. Please try again later.';
  }
}
