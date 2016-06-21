package com.devialab.exif;

import com.facebook.react.bridge.*;

public class Exif extends ReactContextBaseJavaModule  {

    public Exif(ReactApplicationContext reactContext) {
        super(reactContext);
    }

    @Override
    public String getName() {
        return "ReactNativeExif";
    }

    @ReactMethod
    public void getExif( String uri, Callback successCallback,  Callback errorCallback) throws Exception {
        successCallback.invoke("android test " + uri);
    }

}
