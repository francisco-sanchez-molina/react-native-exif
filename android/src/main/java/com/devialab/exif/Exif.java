package com.devialab.exif;

import android.database.Cursor;
import android.media.ExifInterface;
import android.net.Uri;
import android.provider.MediaStore;
import com.facebook.react.bridge.*;
import java.io.IOException;
import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.WritableMap;

import com.devialab.exif.utils.RealPathUtil;

public class Exif extends ReactContextBaseJavaModule  {

    private static final String[] EXIF_ATTRIBUTES = new String[] {
        ExifInterface.TAG_APERTURE,
        ExifInterface.TAG_DATETIME,
        ExifInterface.TAG_DATETIME_DIGITIZED,
        ExifInterface.TAG_EXPOSURE_TIME,
        ExifInterface.TAG_FLASH,
        ExifInterface.TAG_FOCAL_LENGTH,
        ExifInterface.TAG_GPS_ALTITUDE,
        ExifInterface.TAG_GPS_ALTITUDE_REF,
        ExifInterface.TAG_GPS_DATESTAMP,
        ExifInterface.TAG_GPS_LATITUDE,
        ExifInterface.TAG_GPS_LATITUDE_REF,
        ExifInterface.TAG_GPS_LONGITUDE,
        ExifInterface.TAG_GPS_LONGITUDE_REF,
        ExifInterface.TAG_GPS_PROCESSING_METHOD,
        ExifInterface.TAG_GPS_TIMESTAMP,
        ExifInterface.TAG_IMAGE_LENGTH,
        ExifInterface.TAG_IMAGE_WIDTH,
        ExifInterface.TAG_ISO,
        ExifInterface.TAG_MAKE,
        ExifInterface.TAG_MODEL,
        ExifInterface.TAG_ORIENTATION,
        ExifInterface.TAG_X_RESOLUTION,
        ExifInterface.TAG_Y_RESOLUTION,
        ExifInterface.TAG_SUBSEC_TIME,
        ExifInterface.TAG_SUBSEC_TIME_DIG,
        ExifInterface.TAG_SUBSEC_TIME_ORIG,
        ExifInterface.TAG_WHITE_BALANCE,
        ExifInterface.TAG_BITS_PER_SAMPLE,
        ExifInterface.TAG_COMPRESSED_BITS_PER_PIXEL,
        ExifInterface.TAG_COLOR_SPACE,
        ExifInterface.TAG_FLASH,
        ExifInterface.TAG_SOFTWARE,
        ExifInterface.TAG_Y_CB_CR_POSITIONING,
        ExifInterface.TAG_RESOLUTION_UNIT,
        ExifInterface.TAG_EXPOSURE_PROGRAM,
        ExifInterface.TAG_EXIF_VERSION,
        ExifInterface.TAG_EXPOSURE_BIAS_VALUE,
        ExifInterface.TAG_MAX_APERTURE_VALUE,
        ExifInterface.TAG_METERING_MODE,
        ExifInterface.TAG_INTEROPERABILITY_INDEX,
        ExifInterface.TAG_MAKER_NOTE,
        ExifInterface.TAG_BITS_PER_SAMPLE,
        ExifInterface.TAG_SHUTTER_SPEED_VALUE
    };

    public Exif(ReactApplicationContext reactContext) {
        super(reactContext);
    }

    @Override
    public String getName() {
        return "ReactNativeExif";
    }

    @ReactMethod
    public void getExif(String uri, Promise promise) {
        try {
            ExifInterface exif = createExifInterface(uri);

            WritableMap exifMap = Arguments.createMap();
            for (String attribute : EXIF_ATTRIBUTES) {
                String value = exif.getAttribute(attribute);
                exifMap.putString(attribute, value);
            }

            exifMap.putString("originalUri", uri);

            promise.resolve(exifMap);
        } catch (Exception e) {
            promise.reject(e.toString());
        }
    }

    @ReactMethod
    public void getLatLong(String uri, Promise promise) {
        try {
            ExifInterface exif = createExifInterface(uri);

            float[] latlng = new float[2];
            exif.getLatLong(latlng);

            WritableMap responseMap = Arguments.createMap();
            responseMap.putDouble("latitude", latlng[0]);
            responseMap.putDouble("longitude", latlng[1]);

            promise.resolve(responseMap);
        } catch (Exception e) {

            promise.reject(e.toString());
        }
    }

    private ExifInterface createExifInterface(String uri) throws Exception {
        if (uri.startsWith("content://")) {
            uri = RealPathUtil.getRealPathFromURI(getReactApplicationContext(), Uri.parse(uri));
        }

        return new ExifInterface(uri);
    }
}
