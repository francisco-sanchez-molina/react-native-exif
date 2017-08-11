import {
    Platform,
    NativeModules,
} from 'react-native';

const Exif = {};

function unifyAndroid(exif) {
    const output = {};

    output.ImageWidth = parseInt(exif.ImageWidth);
    output.ImageHeight = parseInt(exif.ImageLength);
    output.Orientation = parseInt(exif.Orientation);
    output.originalUri = exif.originalUri;
    output.exif = exif;
    return output;
}

function unifyIOS(exif) {
    const output = {};

    output.ImageWidth = exif.PixelWidth;
    output.ImageHeight = exif.PixelHeight;
    output.Orientation = exif.Orientation;
    output.originalUri = exif.originalUri;
    output.exif = exif;
    return output;
}

Exif.getExif = function (uri) {
    const path = uri.replace('file://', '');
    return NativeModules.ReactNativeExif.getExif(path).then(result => {
        if (Platform.OS === 'android') {
            return unifyAndroid(result);
        }
        return unifyIOS(result);
    });
};

Exif.getLatLong = function (uri) {
    const path = uri.replace('file://', '');
    return NativeModules.ReactNativeExif.getLatLong(path);
};

module.exports = Exif;
