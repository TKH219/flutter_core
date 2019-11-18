import 'package:url_launcher/url_launcher.dart';

class CoreUrlUtils {

  static launchURL(String url) async {
    if (await canLaunch(url)) {
      launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

}