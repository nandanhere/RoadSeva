# RoadSeva
<p align="center"> 
 <a href="https://developer.apple.com/swift/"> <img src="https://github.com/nandanhere/RoadSeva/blob/main/assets/images/pothole.png" alt="swift" width="150" height="150"/> </a>
  </p>
  
- RoadSeva is an application built for both Android and iOS as to notify the required authorities if any potholes are discovered by daily pedestrians.
- This app aims to tackle unsafe roads and places that might be prone to accidents due to potholes and other road incapabilities.
- The app hence tries to provide a proper gateway for users to notify the respective authorities like the municipal corporation or the elected corporator. All the user has to do is use the app and pinpoint the location, the rest is automatically done and the authorities get notified.

## How Is It Made?

RoadSeva uses Flutter to build its core Frontend and implements Firebase’s Cloud FireStore as its backend to store and access required data.

## Installation

- Follow regular github processes and install the repoistory as your local repo.
- Then, run the code in VSCode after connecting your device.
- For iOS users, first set up the regular details in the Signing & Capabilities section of the app in Runner.xcodeproj and then run the application (Note: If you are using a free certificate, ensure that there are at max 2 apps installed that are under your certificate as this will be the third app)
- Try ```flutter clean``` if any first time error is seen
- Ensure that you are properly connected to the internet as Firebase requires it.


The following project aims to soon become open source after shifting to a proper backend rather than firebase.

## Special Thanks To
- Open Street Map
- <div> App Logo made by <a href="https://www.flaticon.com/authors/freepik" title="Freepik">Freepik</a> from <a href="https://www.flaticon.com/" title="Flaticon">www.flaticon.com</a></div>
- Flutter, for being an amazing platform
