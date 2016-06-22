# React Native Exif 
A image exif reader

## Installation
```sh
npm install francisco-sanchez-molina/react-native-exif --save
```


## Usage

```javascript
import Exif from 'react-native-exif'

....

Exif.getExif('/sdcard/tt.jpg')
    .then(msg => console.log('OK: ' + JSON.stringify(msg)))
    .catch(meg => console.warn('ERROR: ' + msg))
```
### Exif values

Value | 
--- |
ImageWidth |
ImageHeight |
Orientation |

