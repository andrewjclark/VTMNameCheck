//
//  VTMNameCheck.swift
//
//  Created by Andrew J Clark on 18/04/2015
//
// names.txt, names-female.txt and names-male.txt are all taken from http://www.outpost9.com/files/WordLists.html which credits the following source:
// Bob Baldwin's collection from MIT
// Augmented by Matt Bishop and Daniel Klein

import Foundation

public enum Gender:Printable {
    case Male
    case Female
    case Either
    case Unknown
    
    public var description: String {
        get {
            switch(self) {
            case .Male:
                return "Male"
            case .Female:
                return "Female"
            case .Either:
                return "Either"
            default:
                return "Unknown"
            }
        }
    }
}

public enum NameIndexType {
    case Deep
    case Shallow
}

public class VTMNameCheck:Printable {
    
    class var sharedInstance: VTMNameCheck {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: VTMNameCheck? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = VTMNameCheck()
        }
        return Static.instance!
    }
    
    var allNames:[String] = []
    var knownMaleNames:[String] = []
    var knownFemaleNames:[String] = []
    
    public func loadShallowGenderLists() {
        if let filePath = NSBundle.mainBundle().pathForResource("names-male", ofType:"plist") {
            
            let loadedMaleNames = NSArray(contentsOfFile: filePath)
            if let array = loadedMaleNames as? Array<String> {
                knownMaleNames = array
            }
        }
        
        if let filePath = NSBundle.mainBundle().pathForResource("names-female", ofType:"plist") {
            let loadedFemaleNames = NSArray(contentsOfFile: filePath)
            if let array = loadedFemaleNames as? Array<String> {
                knownFemaleNames = array
            }
        }
    }
    
    public func loadDeepNamesList() {
        if let filePath = NSBundle.mainBundle().pathForResource("names", ofType:"plist") {
            let loadedNames = NSArray(contentsOfFile: filePath)
            if let array = loadedNames as? Array<String> {
                allNames = array
            }
        }
    }
    
    func nameCount() -> (all: Int, male: Int, female: Int) {
        // Return counts of all the name objects
        return (allNames.count, knownMaleNames.count, knownFemaleNames.count)
    }
    
    public var description: String {
        get {
            let nameCount = self.nameCount()
            
            return "All Names: \(allNames.count)  Male Names: \(knownMaleNames.count)  Female Names: \(knownFemaleNames.count)"
        }
    }
    
    public func nameSetFromFile(fileName: String) -> Set<String> {
        
        // Load the .txt file from the app bundle, divide it into the a Set of String objects.
        
        let filePath = NSBundle.mainBundle().pathForResource(fileName, ofType: "txt")
        
        let loadedString = String(contentsOfFile: filePath!, encoding: NSUTF8StringEncoding, error: nil)
        
        let allNamesWithoutTab = loadedString?.stringByReplacingOccurrencesOfString("\r", withString: "")
        
        let allNames = allNamesWithoutTab?.componentsSeparatedByString("\n")
        
        var nameSet = Set<String>()
        
        if let names = allNames {
            for name in names {
                nameSet.insert(name.lowercaseString)
            }
        }
        
        return nameSet
    }
    
    
    public func isPerson(name: String) -> (isPerson: Bool, confidenceIsPerson: Float, gender: Gender) {
        
        // Determine if the provided string is a person or not, returning confidence in this assessment and a guess at gender.
        
        let words = self.arrayOfWords(name)
        
        var nameHits = 0
        
        var wordsCount = words.count
        
        var gender = Gender.Unknown
        
        if wordsCount > 0 {
            
            // Check words against master names set
            var loopCount = 0
            for word in words {
                
                let isName = contains(allNames, word)
                let isMale = contains(knownMaleNames, word)
                let isFemale = contains(knownFemaleNames, word)
                
                if count(word) > 0 && loopCount == 0 {
                    if isMale && isFemale {
                        gender = .Either
                    } else if isMale && isFemale == false {
                        gender = .Male
                    } else if isFemale && isMale == false {
                        gender = .Female
                    }
                    loopCount += 1
                }
                
                if count(word) > 1 {
                    // Word is longer than 1 character
                    if isName || isMale || isFemale {
                        // Word is a name
                        nameHits += 1
                    }
                } else {
                    // Word is only 1 character long - ignore it and reduce wordsCount
                    wordsCount -= 1
                }
            }

        } else {
            // There are no words to check - return false.
            return (false, 0, gender)
        }
        
        // Confidence describes the proportion of checked words were names.
        
        let confidence:Float = Float(nameHits) / Float(wordsCount)
        
        // If 50% or more of the checked words are names then assume it is a person.
        
        if confidence >= 0.5 {
            return (true, confidence, gender)
        } else {
            return (false, confidence, gender)
        }
    }
    
    func arrayOfWords(string: String) -> Array<String> {
        
        // Remove non alphabetic characters and divide the given string into an array of words.
        
        var charactersToRemove = NSCharacterSet(charactersInString: "abcdefghijklmnopqrstuvwxyz ").invertedSet
        
        let trimmedString = string.lowercaseString.stringByTrimmingCharactersInSet(charactersToRemove)
        
        let wordsArray = trimmedString.componentsSeparatedByString(" ")
        
        return wordsArray
    }
}