import { NativeModules } from 'react-native';

var Exif = {}

Exif.getExif = function (uri) {
  var path = uri.replace('file://', '')
  return NativeModules.ReactNativeExif.getExif(path)
}


module.exports = Exif


/*ios

exifDic properties: {
	    ColorModel = RGB;
	    Depth = 8;
	    Orientation = 1;
	    PixelHeight = 240;
	    PixelWidth = 320;
	    ProfileName = "sRGB IEC61966-2.1";
	    "{Exif}" =     {
	        ColorSpace = 1;
	        PixelXDimension = 320;
	        PixelYDimension = 240;
	    };
	    "{JFIF}" =     {
	        DensityUnit = 0;
	        JFIFVersion =         (
	            1,
	            0,
	            1
	        );
	        XDensity = 72;
	        YDensity = 72;
	    };
	    "{TIFF}" =     {
	        Orientation = 1;
	    };
	}*/
