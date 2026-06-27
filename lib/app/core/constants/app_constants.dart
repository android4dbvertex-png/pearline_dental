class ApiEndpoints {
  static const String baseUrl =
      'https://pearlines.onrender.com/api'; // ← real URL

  // Auth
  static const String login = '/auth/login';
  static const String register = '/auth/signup';
  static const String sendOtp = '/auth/send-otp';
  static const String verifyOtp = '/auth/verify-otp';
  static const String forgotPassword = '/auth/forgot-password';
  static const String logout = '/auth/logout';

  // User Profile
  static const String userProfile = '/users/me';
  static const String updateProfile = '/users/profile';
  static const String uploadProfilePhoto = '/users/profile-photo';
  static const String changePassword = '/users/change-password';

  // Appointments
  //static const String appointments = '/appointments';
  static const String bookAppointment = '/appointments';
  static const String myAppointments = '/appointments/my';
  static const String updateAppointment = '/appointments/my';
  // Services
  static const String services = '/services';

  // Gallery
  static const String gallery = '/gallery';
  static const String videos = '/videos';

  // banners
  static const String banners = '/banners';

  // Notifications
  static const String notifications = '/notifications';

// payments
  static const String createOrder = '/payments/create-order';
  static const String myPayments = '/payments/my-payments';
  static const String myPaymentRequests = "/payment-request/my";
  static const String createCustomOrder = '/payments/create-custom-order';

  // Misc
  static const String faq = '/faqs';
  static const String aboutUs = '/about-us';
  static const String termsConditions = '/terms-conditions';
  static const String privacyPolicy = '/privacy-policy';
  static const String tips = '/tips';

  // live chat
  static const String chats = '/chats';
  static const String messages = '/messages';

  static get razorpayKeyId => null;

  // static String? get uploadProfilePhoto => null;

  // static String? get userProfile => null;
}

class AppConstants {
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
  static const String isLoggedInKey = 'is_logged_in';
  static const String isAppointmentBookedKey = 'is_appointment_booked';
  // Contact Info
  static const String phone = '+919790099950';
  static const String email = 'pearllinedentocare@gmail.com';
  static const String whatsappNumber = '919790099950';
}
