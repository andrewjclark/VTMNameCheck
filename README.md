# VTMNameCheck
A simple Swift class that tries to determine if a given string represents a persons name or not. It returns an isPerson bool, confidenceIsPerson float, and gender enum as a named tuple.

It works by initially loading names.txt, names-male.txt and names-female.txt from the app bundle into several Set objects, and then checks these against words in the calling string.

Requires Xcode 6.3 and Swift 1.2

#Usage
Add VTMNameChecker.swift, names.txt, names-male.txt and names-female.txt to your application. Instantiate the class in the usual way and then call the isPerson method...

```
let nameChecker = VTMNameCheck.sharedInstance
nameChecker.loadShallowGenderLists()

let firstNameResult = nameChecker.isPerson("Andrew J Clark")
println("Andrew J Clark result: \(firstNameResult)")
```

