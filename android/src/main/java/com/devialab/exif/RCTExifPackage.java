package com.devialab.exif;

import java.util.Arrays;
import java.util.Collections;
import java.util.List;

import com.facebook.react.ReactPackage;
import com.facebook.react.bridge.JavaScriptModule;
import com.facebook.react.bridge.NativeModule;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.uimanager.ViewManager;


public class RCTExifPackage implements ReactPackage {

    @Override
    public List<NativeModule> createNativeModules(ReactApplicationContext reactContext) {
        return Arrays.<NativeModule>asList(
                new Exif(reactContext)
        );
    }

    // Do not annotate the method with @Override
    // This will provide backward compatibility for apps using react-native version < 0.47
    // Breaking change in react-native version 0.47 : Android Remove unused createJSModules calls
    // Find more information here : https://github.com/facebook/react-native/releases/tag/v0.47.2
    // https://github.com/facebook/react-native/commit/ce6fb337a146e6f261f2afb564aa19363774a7a8
    public List<Class<? extends JavaScriptModule>> createJSModules() {
        return Collections.emptyList();
    }

    @Override
    public List<ViewManager> createViewManagers(ReactApplicationContext reactContext) {
        return Collections.emptyList();
    }

}
