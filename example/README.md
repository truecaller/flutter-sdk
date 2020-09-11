# truecaller_sdk_example

Demonstrates how to use the `truecaller_sdk` plugin.

You can find 2 example implementations under [example/lib](lib) directory

1. [main.dart](https://github.com/truecaller/flutter-sdk/blob/master/example/lib/main.dart) - a very basic, crude implementation of
 `truecaller_sdk` plugin which would look like this -

<img src="../images/main.jpg" width="250">

To run this file, just execute the following command after navigating to `/example` directory -

```flutter run --target=lib/main.dart```


2. [main_customization_screen.dart](https://github.com/truecaller/flutter-sdk/blob/master/example/lib/customization/main_customization_screen.dart) - sample implementation that shows different customization options available for `truecaller_sdk` plugin which would look like this -

<img src="../images/main_customization_screen.jpg" width="250">

To run this file, just execute the following command after navigating to `/example` directory -

```flutter run --target=lib/customization/main_customization_screen.dart```


##### Note : If you run these examples and proceed with user verification, SDK would give you error code 3 which indicates an incorrect app key. So you need to replace the partnerKey in [AndroidManifest.xml](android/app/src/main/AndroidManifest.xml) with your own app key as mentioned in [step 2](/README.md) of `Steps to integrate` section.


## License

[MIT-licensed](../LICENSE).
