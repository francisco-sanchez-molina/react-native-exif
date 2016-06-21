import { NativeModules } from 'react-native';

var Exif = {}

Exif.getExif = function (uri, success, error) {
  NativeModules.ReactNativeExif.getExif(uri, success, error)
  return uri
}


module.exports = Exif
