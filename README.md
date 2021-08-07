# scai_ios_test

As dependency manager using Swift Package manager.
Library: 
RxSwift
https://github.com/ReactiveX/RxSwift.git

TableView/CollectionView DataSource
https://github.com/RxSwiftCommunity/RxDataSources.git

Gesture utility
https://github.com/RxSwiftCommunity/RxGesture

Database
https://github.com/RxSwiftCommunity/RxRealm.git
https://github.com/realm/realm-cocoa.git

Disposable
https://github.com/RxSwiftCommunity/NSObject-Rx


### How to build
1. Open the project file `scai_ios_test.xcworkspace` from the project directory
2. Please wait for the `Swift Package Manger` to finish downloading of third-party libraries
3. Press the play button and run the project.
4. Please check `scai_ios_testTests` to run test cases.


### Project structure:
- Application:
    `Application.swift` Setup initial screen, network provider and navigation. 
    `Navigator.swift` setup the screen navigation for screen `enum`. Also includes the `info.plist`.
- Network: 
    `RequestProtocol.swift` Provide implementation of network api request as `enum` group. 
    `NetworkManager.swift` call api using `URLSession`, fetch data and decode into readable `Codable` Model.
- Models: 
    Created models for json file mapping here. Those model will be decoded directly from network call.
     A name starts with `RM` is a realm Model others are codable model.
- Scene:
    - TabBar: 
        - ViewController
        - ViewModel
        - Storyboard
    - Gallery:
        - ViewController
        - ViewModel
        - Storyboard
    - Detail:
        - ViewController
        - ViewModel
        - Storyboard
    - TypeSelect:
        - ViewController
        - ViewModel
        - Storyboard
    - Landing:
        - ViewController
        - ViewModel
        - Storyboard
- Extension: Some extension related to increase the coding efficiency.
- Common:
    - NavigationController:
    - ViewController:
    - ViewModelType:
- Resources:
    - Assets.xcassets
