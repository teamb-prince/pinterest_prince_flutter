import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class MyInAppBrowser extends InAppBrowser {
  @override
  Future onLoadStart(String url) async {
    print('\n\nStarted $url\n\n');
  }

  @override
  Future onLoadStop(String url) async {
    print('\n\nStopped $url\n\n');
  }

  @override
  void onLoadError(String url, int code, String message) {
    print("\n\nCan't load $url.. Error: $message\n\n");
  }

  @override
  void onExit() {
    print('\n\nBrowser closed!\n\n');
  }
}

class MyChromeSafariBrowser extends ChromeSafariBrowser {
  MyChromeSafariBrowser(dynamic browserFallback)
      : super(bFallback: browserFallback);

  @override
  void onOpened() {
    print('ChromeSafari browser opened');
  }

  @override
  void onCompletedInitialLoad() {
    print('ChromeSafari browser initial load completed');
  }

  @override
  void onClosed() {
    print('ChromeSafari browser closed');
  }
}
