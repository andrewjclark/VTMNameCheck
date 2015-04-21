# VTMNameCheck
A simple Swift singleton that tries to determine if a given string represents a persons name or not. It returns an isPerson bool, confidenceIsPerson float, and gender enum as a named tuple.

After instantiating a singleton the user should call loadShallowGenderLists() and/or loadDeepNamesList(). The shallow list takes approx 20ms to load whereas the deep list takes 100ms to load. The names are loaded into 3 Array's and are compared against incoming words.

Requires Xcode 6.3 and Swift 1.2
Calling loadShallowGenderLists is required to estimate gender.

#Usage
Add VTMNameChecker.swift, names.plist, names-male.plist and names-female.plist to your application. Instantiate the class using the sharedInstance method, then load the list

```
let nameChecker = VTMNameCheck.sharedInstance
nameChecker.loadShallowGenderLists()

let firstNameResult = nameChecker.isPerson("Andrew J Clark")
println("Andrew J Clark result: \(firstNameResult)")
```

