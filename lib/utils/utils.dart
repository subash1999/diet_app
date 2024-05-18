class GreetingUtil {
  static String getGreeting() {
    int hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else if (hour < 21) {
      return 'Good Evening';
    } else {
      return 'Good Night';
    }
  }

  static String getSunTimeEmoji() {
    int hour = DateTime.now().hour;
    if (hour < 6) {
      return '🌑'; // Night
    } else if (hour < 12) {
      return '🌅'; // Morning
    } else if (hour < 18) {
      return '🌞'; // Noon/Afternoon
    } else {
      return '🌇'; // Evening
    }
  }

  static String greetUserWithEmoji(String name) {
    String greeting = getGreeting();
    String sunTimeEmoji = getSunTimeEmoji();
    return '$greeting $name $sunTimeEmoji';
  }
}
