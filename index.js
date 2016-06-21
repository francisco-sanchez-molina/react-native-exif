import { NativeModules } from 'react-native';

var Exif = {}

Exif.getExif = function (uri) {
  var path = uri.replace('file://', '')
  return NativeModules.ReactNativeExif.getExif(path)
}


module.exports = Exif
