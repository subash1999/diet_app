import 'dart:math';

class OTP {
  static String generateOTP() {
    final random = Random();
    // Generate a random number within the range of 100000 to 999999
    int randomNumber = random.nextInt(900000) + 100000;
    // Convert the number to a string and return
    return randomNumber.toString();
  }
}
