import {
	Platform,
	NativeModules } from 'react-native';

var Exif = {}

function unifyAndroid(exif) {
	var output = {}

	output.ImageWidth = parseInt(exif.ImageWidth);
	output.ImageHeight = parseInt(exif.ImageLength);
	output.Orientation = parseInt(exif.Orientation);
	output.originalUri = exif.originalUri;
	output.exif = exif;
	return output
}

function unifyIOS(exif) {
	var output = {}

	output.ImageWidth = exif.PixelWidth
	output.ImageHeight = exif.PixelHeight
	output.Orientation = exif.Orientation
	output.originalUri = exif.originalUri
	return output
}

Exif.getExif = function (uri) {
	var path = uri.replace('file://', '')
	return NativeModules.ReactNativeExif.getExif(path).then(result => {
		if (Platform.OS === 'android') {
			return unifyAndroid(result)
		} else {
			return unifyIOS(result)
		}
	})
}


module.exports = Exif
