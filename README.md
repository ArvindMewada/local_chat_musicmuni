# chat_app_musicmuni_sample

A new Flutter application.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

The assignment is basically the creation of a fully offline chat(so that you have no requirement of a backend to develop it)

The main features to be covered are:
   1. The two screens.
   1.  (A) For displaying the two entities.
      (B) Chat screen of the entity.
   2. Data to be stored in an SQLite database.
   3. The message being sent can include both audio and text messages.
   4. The audio messages must be playable on both chat screens.
   5. The animation of the audio recording button. (0:13 of the attached video)
   6. The nav bar on the first screen is completely optional
   7. Updation of the circle indicating the number of unread messages for each party.
       (A) If i send 2 messages from myself to the other entity, when i go back to the listing screen 
        the circle will have 2 displayed on it.
        
Dependencies:   
   sqflite: ^1.3.0 
        ->    SQLite plugin for Flutter. Supports iOS, Android and MacOS.    
              Support transactions and batches
              Automatic version managment during open
              Helpers for insert/query/update/delete queries
              DB operation executed in a background thread on iOS and Android
    path_provider:
    ->       A Flutter plugin for finding commonly used locations on the filesystem. Supports iOS,
             Android, Linux and MacOS. Not all methods are supported on all platforms.          
    permission_handler:
    ->       This plugin provides a cross-platform (iOS, Android) API to request permissions 
             and check their status. You can also open the device's app settings so users can
             grant a permission.On Android, you can show a rationale for requesting a permission.  
   file:
   ->       Can be used to implement custom file systems.
            Comes with an in-memory implementation out-of-the-box, making it super-easy to test 
            code that works with the file system.
            Allows using multiple file systems simultaneously. A file system is a first-class object.
             Instantiate however many you want and use them all.
   flutter_audio_recorder:
   ->       Flutter Audio Record Plugin that supports Record Pause Resume Stop and provide access 
            to audio level metering properties average power peak power  
    audioplayers:
    ->      A Flutter plugin to play multiple simultaneously audio files,
            works for Android, iOS, macOS and web.
   Intl: 
   ->       This package provides internationalization and localization facilities, including 
            message translation, plurals and genders, date/number formatting and parsing, and bidirectional text.
   bubble:
   ->       A Flutter widget for chat like a speech bubble in Whatsapp and others.
            

         
           