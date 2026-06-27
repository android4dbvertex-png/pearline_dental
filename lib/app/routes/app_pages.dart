import 'package:get/get.dart';
import 'package:pearline_dental/app/modules/home/views/banner_detail_view.dart';
import 'package:pearline_dental/app/modules/payments/bindings/payment_binding.dart';
import 'package:pearline_dental/app/modules/payments/views/payment_view.dart';
import 'app_routes.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';
import '../modules/auth/login/bindings/login_binding.dart';
import '../modules/auth/login/views/login_view.dart';
import '../modules/auth/register/bindings/register_binding.dart';
import '../modules/auth/register/views/register_view.dart';
import '../modules/auth/otp/bindings/otp_binding.dart';
import '../modules/auth/otp/views/otp_view.dart';
import '../modules/auth/forgot_password/bindings/forgot_password_binding.dart';
import '../modules/auth/forgot_password/views/forgot_password_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/services/our_services/bindings/our_services_binding.dart';
import '../modules/services/our_services/views/our_services_view.dart';
import '../modules/services/service_detail/bindings/service_detail_binding.dart';
import '../modules/services/service_detail/views/service_detail_view.dart';
import '../modules/gallery/bindings/gallery_binding.dart';
import '../modules/gallery/views/gallery_view.dart';
import '../modules/notifications/bindings/notifications_binding.dart';
import '../modules/notifications/views/notifications_view.dart';
import '../modules/appointments/book_appointment/bindings/book_appointment_binding.dart';
import '../modules/appointments/book_appointment/views/book_appointment_view.dart';
import '../modules/appointments/my_appointments/bindings/my_appointments_binding.dart';
import '../modules/appointments/my_appointments/views/my_appointments_view.dart';
import '../modules/appointments/appointment_detail/bindings/appointment_detail_binding.dart';
import '../modules/appointments/appointment_detail/views/appointment_detail_view.dart';
import '../modules/contact_us/bindings/contact_us_binding.dart';
import '../modules/contact_us/views/contact_us_view.dart';
import '../modules/about_us/bindings/about_us_binding.dart';
import '../modules/about_us/views/about_us_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/settings/bindings/settings_binding.dart';
import '../modules/settings/views/settings_view.dart';
import '../modules/faq/bindings/faq_binding.dart';
import '../modules/faq/views/faq_view.dart';
import '../modules/terms_conditions/bindings/terms_conditions_binding.dart';
import '../modules/terms_conditions/views/terms_conditions_view.dart';
import '../modules/privacy_policy/bindings/privacy_policy_binding.dart';
import '../modules/privacy_policy/views/privacy_policy_view.dart';
import '../modules/tips/bindings/tips_binding.dart';
import '../modules/tips/views/tips_view.dart';
import '../modules/chat/bindings/chat_binding.dart';
import '../modules/chat/views/chat_view.dart';

class AppPages {
  static const initial = AppRoutes.splash;

  static final routes = [
    GetPage(
        name: AppRoutes.splash,
        page: () => const SplashView(),
        binding: SplashBinding()),
    GetPage(
        name: AppRoutes.login,
        page: () => const LoginView(),
        binding: LoginBinding()),
    GetPage(
        name: AppRoutes.register,
        page: () => const RegisterView(),
        binding: RegisterBinding()),
    GetPage(
        name: AppRoutes.otp,
        page: () => const OtpView(),
        binding: OtpBinding()),
    GetPage(
        name: AppRoutes.forgotPassword,
        page: () => const ForgotPasswordView(),
        binding: ForgotPasswordBinding()),
    GetPage(
        name: AppRoutes.home,
        page: () => const HomeView(),
        binding: HomeBinding()),
    GetPage(
        name: AppRoutes.services,
        page: () => const OurServicesView(),
        binding: OurServicesBinding()),
    GetPage(
        name: AppRoutes.serviceDetail,
        page: () => const ServiceDetailView(),
        binding: ServiceDetailBinding()),
    GetPage(
        name: AppRoutes.gallery,
        page: () => const GalleryView(),
        binding: GalleryBinding()),
    GetPage(
        name: AppRoutes.notifications,
        page: () => const NotificationsView(),
        binding: NotificationsBinding()),
    GetPage(
        name: AppRoutes.bookAppointment,
        page: () => const BookAppointmentView(),
        binding: BookAppointmentBinding()),
    // showBackButton: true — card se navigate karne par
    GetPage(
      name: AppRoutes.myAppointments,
      page: () => const MyAppointmentsView(showBackButton: true),
      binding: MyAppointmentsBinding(),
    ),
    GetPage(
        name: AppRoutes.appointmentDetail,
        page: () => const AppointmentDetailView(),
        binding: AppointmentDetailBinding()),
    GetPage(
        name: AppRoutes.contactUs,
        page: () => const ContactUsView(),
        binding: ContactUsBinding()),
    GetPage(
        name: AppRoutes.aboutUs,
        page: () => const AboutUsView(),
        binding: AboutUsBinding()),
    GetPage(
        name: AppRoutes.profile,
        page: () => const ProfileView(),
        binding: ProfileBinding()),
    GetPage(
        name: AppRoutes.settings,
        page: () => const SettingsView(),
        binding: SettingsBinding()),
    GetPage(
        name: AppRoutes.faq,
        page: () => const FaqView(),
        binding: FaqBinding()),
    GetPage(
        name: AppRoutes.termsConditions,
        page: () => const TermsConditionsView(),
        binding: TermsConditionsBinding()),
    GetPage(
        name: AppRoutes.privacyPolicy,
        page: () => const PrivacyPolicyView(),
        binding: PrivacyPolicyBinding()),
    GetPage(
        name: AppRoutes.tips,
        page: () => const TipsView(),
        binding: TipsBinding()),
    GetPage(
        name: AppRoutes.chat,
        page: () => const ChatView(),
        binding: ChatBinding()),
    GetPage(
        name: AppRoutes.payment,
        page: () => const PaymentView(),
        binding: PaymentBinding()),

    GetPage(
      name: AppRoutes.bannerDetail,
      page: () => const BannerDetailView(),
    ),
  ];
}
