package com.devialab.exif;

import com.facebook.common.logging.FLog;
import com.facebook.react.bridge.*;

public class Exif extends ReactContextBaseJavaModule  {

    private boolean isPaused;

    public Exif(ReactApplicationContext reactContext) {
        super(reactContext);
    }

    @Override
    public String getName() {
        return "RCTExif";
    }

    @ReactMethod
    public void getExif( String uri, Callback successCallback,  Callback errorCallback) throws Exception {
        successCallback.invoke("android test " + uri);
    }

}
