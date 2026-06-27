import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsController extends GetxController {
  // ── Contact Details ───────────────────────────────────────────────────────
  final String phone = '+919790099950';
  final String email = 'pearllinedentocare@gmail.com';
  final String facebook = 'https://www.facebook.com/share/18nAp8y5PB/';
  final String instagram =
      'https://www.instagram.com/pearllinedentocare?igsh=MXVhaXNqZGx0dDBpag==';
  final String whatsapp = 'https://wa.me/919790099950';

  Future<void> launchPhone() async {
    final uri = Uri.parse('tel:$phone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> launchEmail() async {
    final uri = Uri.parse('mailto:$email');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> launchFacebook() async {
    final uri = Uri.parse(facebook);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> launchInstagram() async {
    final uri = Uri.parse(instagram);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> launchWhatsapp() async {
    final uri = Uri.parse(whatsapp);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
