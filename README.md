# Water Me 🪴

> A simple, open and privacy friendly plant watering reminder for Android.
  
  [![Build APK](https://github.com/abertschi/water-me/actions/workflows/build.yml/badge.svg)](https://github.com/abertschi/water-me/actions/workflows/build.yml)
   ![Made with Flutter](https://img.shields.io/badge/Made%20with-Flutter-1f425f.svg)
<p align="left">
    <img src="./assets/preview2.png" alt="preview" width="800"/>
</p>

_Water me_ is a mobile application written in Flutter to  remind you to water your plants.

### Features and Components
- Add plants with watering frequency, name and picture
- No remote entity, local-only application
- Flutter, currently support for Android
- Camera access
- Local Notifications
- Workmanager with periodic task
- Provider package for MVC separation
  
    
Pull requests are welcome :heart:.

#### Feature Ideas
- Enable 'web' target to build a web app for ios/ web (needs a backend for notifications).
- Integrate firebase/ self hosted backend to enable a group mode to sync plant state within a group of users
- Add a 'note' field to a plant
- Show watering history in plant detail screen.
- Allow assignment of plants into groups, e.g. living room, office

### Build
This is a flutter based Android application. Ensure to have Android-Studio and flutter-sdk installed.
```
flutter pub get
flutter build apk
```

### Install
Download the APK in the [Release Section](https://github.com/abertschi/water-me/releases). Alternatively, download the artifact of the latest commit from the [Build APK Action](https://github.com/abertschi/water-me/actions/workflows/build.yml) (select latest successfull build, and download the APK under 'Artifacts'. This requires a Github Account).

### License
GPL v3

### About
Built with <3   
by Andrin Bertschi  
https://abertschi.ch
