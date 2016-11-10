package com.devialab.exif;

import android.database.Cursor;

import android.media.ExifInterface; 

import android.net.Uri;

import android.provider.MediaStore;

import com.facebook.react.bridge.*;

import java.io.IOException;

import com.facebook.react.bridge.Arguments;

import com.facebook.react.bridge.WritableMap;

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
        ExifInterface.TAG_SUBSEC_TIME,
        ExifInterface.TAG_SUBSEC_TIME_DIG,
        ExifInterface.TAG_SUBSEC_TIME_ORIG,
        ExifInterface.TAG_WHITE_BALANCE
    };
    
    public Exif(ReactApplicationContext reactContext) {
        super(reactContext);
    }

    @Override
    public String getName() {
        return "ReactNativeExif";
    }

    @ReactMethod
    public void getExif(String uri, Promise promise) throws Exception {
        try { 
            if(uri.startsWith("content://")) {
                String [] proj = {MediaStore.Images.Media.DATA};
                Cursor cursor = getReactApplicationContext().getContentResolver().query(Uri.parse(uri), proj,  null, null, null);
                int column_index = cursor.getColumnIndexOrThrow(MediaStore.Images.Media.DATA);
                cursor.moveToFirst();
                uri = cursor.getString(column_index); 
                cursor.close();
            }
        } catch (Exception e) { 
            promise.reject(e.toString());
            return;
        }

        ExifInterface exif; 
        try { 
            exif = new ExifInterface(uri); 
        } catch (IOException e) { 
            promise.reject(e.toString());
            return;
        } 

        WritableMap exifMap = Arguments.createMap();
        for (String attribute : EXIF_ATTRIBUTES) {
            String value = exif.getAttribute(attribute);
            exifMap.putString(attribute, value);
        }

        exifMap.putString("originalUri", uri);

        promise.resolve(exifMap);
    }

}
