import 'dart:convert';
import 'package:crypto/crypto.dart';

class HashUtil {
  // Generates a SHA-256 hash for the given input string
  static String generateHash(String? input) {
    if (input == null) return ''; // Return empty string if input is null
    var bytes = utf8.encode(input); // Convert input to bytes
    var digest = sha256.convert(bytes); // Hash bytes using SHA-256
    return digest.toString(); // Return the hash as a string
  }

  // Validates if the given hash matches the hash of the input string
  static bool validateHash(String input, String hash) {
    String generatedHash = generateHash(input); // Generate hash of the input
    return generatedHash == hash; // Compare and return the validation result
  }
}
