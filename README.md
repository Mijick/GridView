<br>

<p align="center">
  <picture> 
    <source media="(prefers-color-scheme: dark)" srcset="https://github.com/Mijick/Assets/blob/main/GridView/Logotype/On%20Dark.svg">
    <source media="(prefers-color-scheme: light)" srcset="https://github.com/Mijick/Assets/blob/main/GridView/Logotype/On%20Light.svg">
    <img alt="GridView Logo" src="https://github.com/Mijick/Assets/blob/main/GridView/Logotype/On%20Dark.svg" width="76%"">
  </picture>
</p>


<h3 style="font-size: 5em" align="center">
    Layouts made simple
</h3>

<p align="center">
    Lay out your data in the blink of an eye. Keep your code clean
</p>

<p align="center">
    <a href="https://github.com/Mijick/GridView-Demo" rel="nofollow">Try demo we prepared</a>
</p>

<br>

<p align="center">
    <img alt="Library in beta version" src="https://github.com/Mijick/Assets/blob/main/GridView/Labels/Beta.svg"/>
    <img alt="Designed for SwiftUI" src="https://github.com/Mijick/Assets/blob/main/GridView/Labels/Language.svg"/>
    <img alt="Platforms: iOS" src="https://github.com/Mijick/Assets/blob/main/GridView/Labels/Platforms.svg"/>
    <img alt="Current Version" src="https://github.com/Mijick/Assets/blob/main/GridView/Labels/Version.svg"/>
    <img alt="License: MIT" src="https://github.com/Mijick/Assets/blob/main/GridView/Labels/License.svg"/>
</p>

<p align="center">
    <img alt="Made in Kraków" src="https://github.com/Mijick/Assets/blob/main/GridView/Labels/Origin.svg"/>
    <a href="https://twitter.com/MijickTeam">
        <img alt="Follow us on X" src="https://github.com/Mijick/Assets/blob/main/GridView/Labels/X.svg"/>
    </a>
    <a href=mailto:team@mijick.com?subject=Hello>
        <img alt="Let's work together" src="https://github.com/Mijick/Assets/blob/main/GridView/Labels/Work%20with%20us.svg"/>
    </a>  
    <a href="https://github.com/Mijick/GridView/stargazers">
        <img alt="Stargazers" src="https://github.com/Mijick/Assets/blob/main/GridView/Labels/Stars.svg"/>
    </a>    
</p>


<p align="center">
    <img alt="GridView Examples" src="https://github.com/Mijick/Assets/blob/main/GridView/GIFs/GridView.gif"/>
</p>


<br>

GridView is a free, and open-source library for SwiftUI that makes creating grids easier and much cleaner.
* **Improves code quality.** Create a grid using `GridView` constructor - simply pass your data and we'll deal with the rest. Simple as never!
* **Designed for SwiftUI.** While developing the library, we have used the power of SwiftUI to give you powerful tool to speed up your implementation process.

<br> 

# Getting Started
### ✋ Requirements

| **Platforms** | **Minimum Swift Version** |
|:----------|:----------|
| iOS 14+ | 5.0 |

### ⏳ Installation
    
#### [Swift Package Manager][spm]
Swift Package Manager is a tool for automating the distribution of Swift code and is integrated into the Swift compiler.

Once you have your Swift package set up, adding GridView as a dependency is as easy as adding it to the `dependencies` value of your `Package.swift`.

```Swift
dependencies: [
    .package(url: "https://github.com/Mijick/GridView", branch(“main”))
]
``` 
                      
<br>

# Usage
### 1. Call initialiser
To declare a Grid for your data set, call the constructor:

```Swift
struct ContentView: View {
    private let data = [SomeData]()

    var body: some View {
        GridView(data, id: \.self) { element in
            SomeItem(element: element)
        }
    }
}
```

### 2. Customise Grid
Your GridView can be customised by calling `configBuilder` inside the initialiser:

```Swift
struct ContentView: View {
    private let data = [SomeData]()

    var body: some View {
        GridView(data, id: \.self, content: SomeItem.init, configBuilder: { $0
            .insertionPolicy(.fill)
            .columns(4)
            .verticalSpacing(12)
        })
    }
}
```


### 3. Declare number of columns
You can change the number of columns of an item by calling .columns of Item:
```Swift
struct ContentView: View { ... }
struct SomeItem: View {
    ...

    var body: some View {
        ...
            .columns(2)
    }
}
```


<br>
      
# Try our demo
See for yourself how does it work by cloning [project][Demo] we created
                      
# License
GridView is released under the MIT license. See [LICENSE][License] for details.
                      
<br><br>
                      
# Our other open source SwiftUI libraries
[PopupView] - The most powerful popup library that allows you to present any popup
<br>
[Navigattie] - Easier and cleaner way of navigating through your app
<br>
[Timer] - Modern API for Timer
                    
                      
[MIT]: https://en.wikipedia.org/wiki/MIT_License
[SPM]: https://www.swift.org/package-manager
                      
[Demo]: https://github.com/Mijick/GridView-Demo
[License]: https://github.com/Mijick/GridView/blob/main/LICENSE

[PopupView]: https://github.com/Mijick/PopupView           
[Navigattie]: https://github.com/Mijick/Navigattie
[Timer]: https://github.com/Mijick/Timer
