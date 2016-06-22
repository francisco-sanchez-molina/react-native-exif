# React Native Exif 
An image exif reader

## Installation
```sh
npm install francisco-sanchez-molina/react-native-exif --save
rnpm link react-native-exif
```


## Usage

```javascript
import Exif from 'react-native-exif'

....

Exif.getExif('/sdcard/tt.jpg')
    .then(msg => console.warn('OK: ' + JSON.stringify(msg)))
    .catch(meg => console.warn('ERROR: ' + msg))
```
### Exif values

Value | 
--- |
ImageWidth |
ImageHeight |
Orientation |

