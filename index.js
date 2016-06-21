import { NativeModules } from 'react-native';

var Exif = {}

Exif.getExif = function (uri, success, error) {
  var path = uri.replace('file://', '')
  NativeModules.ReactNativeExif.getExif(path, success, error)
  return uri
}


module.exports = Exif
