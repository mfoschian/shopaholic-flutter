import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'dart:async';

import 'package:shop_aholic/app.dart';


class ShopListListener {

  StreamSubscription? _intentSub;

  Future<bool> _loadFrom(List<SharedMediaFile> files) async {
    SharedMediaFile? f = files.lastOrNull;
    if(f==null) return false;

    await App.loadShopList(f.path);
    return true;
  }

  void start({required Function onLoaded}) {
    try {
      _intentSub ??= ReceiveSharingIntent.instance.getMediaStream().listen((List<SharedMediaFile> value) async {
        await _loadFrom(value);
        onLoaded();
      });

      // Get the media sharing coming from outside the app while the app is closed.
      ReceiveSharingIntent.instance.getInitialMedia().then((List<SharedMediaFile> value) async {
        await _loadFrom(value);      
        // Tell the library that we are done processing the intent.
        ReceiveSharingIntent.instance.reset();
        onLoaded();
      });
    }
    catch(err) {
      // Platform not supported
    }
  }

  void stop() {
    if(_intentSub == null) return;
    _intentSub!.cancel();
  }

}

