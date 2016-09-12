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
    .catch(msg => console.warn('ERROR: ' + msg))

...

Exif.getExif('content://media/external/images/media/111')
    .then(msg => console.warn('OK: ' + JSON.stringify(msg)))
    .catch(msg => console.warn('ERROR: ' + msg))

...

Exif.getExif('assets-library://asset/asset.JPG?id=xxxx&ext=JPG')
    .then(msg => console.warn('OK: ' + JSON.stringify(msg)))
    .catch(msg => console.warn('ERROR: ' + msg))

```
### Exif values

Value | 
--- |
ImageWidth |
ImageHeight |
Orientation |

