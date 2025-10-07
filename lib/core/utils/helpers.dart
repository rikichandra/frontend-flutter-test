import 'package:intl/intl.dart';

class Helpers {
  static int _localIdCounter = 1000000;
 
  static int generateLocalId() {
    _localIdCounter++;
    return _localIdCounter;
  }
  
  static bool isLocalId(int id) {
    return id >= 1000000;
  }
  
  static String formatCurrency(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  static bool isValidPhoneNumber(String phoneNumber) {
    if (phoneNumber.isEmpty) return false;

    String cleanNumber = phoneNumber.replaceAll(RegExp(r'[\s\-\.]'), '');

    RegExp phoneRegex = RegExp(r'^(\+62|62|0)[0-9]{8,12}$');

    return phoneRegex.hasMatch(cleanNumber);
  }

  static String formatPhoneNumber(String phoneNumber) {
    if (!isValidPhoneNumber(phoneNumber)) return phoneNumber;

    String cleanNumber = phoneNumber.replaceAll(RegExp(r'[\s\-\.]'), '');
    
    if (cleanNumber.startsWith('0')) {
      cleanNumber = '+62${cleanNumber.substring(1)}';
    } else if (cleanNumber.startsWith('62')) {
      cleanNumber = '+$cleanNumber';
    } else if (!cleanNumber.startsWith('+62')) {
      cleanNumber = '+62$cleanNumber';
    }

    return cleanNumber;
  }
  
  static bool isValidEmail(String email) {
    if (email.isEmpty) return false;

    RegExp emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    return emailRegex.hasMatch(email);
  }
  
  static String capitalizeWords(String text) {
    if (text.isEmpty) return text;

    return text.split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }
  
  static bool isValidSalary(double salary) {        
    return salary > 0 && salary >= 1000000 && salary <= 1000000000;
  }

  static double parseSalary(String salaryString) {
    if (salaryString.isEmpty) return 0.0;

    String cleanSalary = salaryString
        .replaceAll('Rp', '')
        .replaceAll(' ', '')
        .replaceAll('.', '')
        .replaceAll(',', '');

    try {
      double salary = double.parse(cleanSalary);
      return salary;
    } catch (e) {
      return 0.0;
    }
  }

  static bool isValidSalaryString(String salaryString) {
    if (salaryString.isEmpty) return false;

    String cleanSalary = salaryString
        .replaceAll('Rp', '')
        .replaceAll(' ', '')
        .replaceAll('.', '')
        .replaceAll(',', '');
    
    try {
      double salary = double.parse(cleanSalary);
      return isValidSalary(salary);
    } catch (e) {
      return false;
    }
  }

  static String formatNumberWithSeparator(String input) {
    if (input.isEmpty) return input;

    String cleanInput = input.replaceAll('.', '').replaceAll(',', '');
    
    if (RegExp(r'^\d+$').hasMatch(cleanInput)) {      
      return cleanInput.replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]}.',
      );
    }

    return input;
  }
  
  static String removeNumberSeparators(String input) {
    return input.replaceAll('.', '').replaceAll(',', '');
  }
}
