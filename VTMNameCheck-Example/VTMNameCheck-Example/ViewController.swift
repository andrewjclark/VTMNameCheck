//
//  ViewController.swift
//  VTMNameCheck-Example
//
//  Created by Andrew J Clark on 18/04/2015.
//  Copyright (c) 2015 Andrew J Clark. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Example Usage
        
        let nameChecker = VTMNameCheck()
        
        println(nameChecker)
        
        let nameExamples = ["steve jobs", "alan turing", "some random computer", "chris", "123345", "apple inc", " frances allen", "ada lovelace", "zedrick"]
        
        var malePeople = Set<String>()
        var femalePeople = Set<String>()
        var eitherPeople = Set<String>()
        var unknownPeople = Set<String>()
        var nonPeople = Set<String>()
        
        for name in nameExamples {
            let result = nameChecker.isPerson(name)
            
            if result.isPerson == true {
                if result.gender == .Male {
                    malePeople.insert(name)
                } else if result.gender == .Female {
                    femalePeople.insert(name)
                } else if result.gender == .Either {
                    eitherPeople.insert(name)
                } else if result.gender == .Unknown {
                    unknownPeople.insert(name)
                }
            } else {
                nonPeople.insert(name)
            }
            
        }
        
        println("\n\nMales:\n\(malePeople)\n")
        println("Females:\n\(femalePeople)\n")
        println("Either Gender:\n\(eitherPeople)\n")
        println("Unknown Gender:\n\(unknownPeople)\n")
        println("Non People:\n\(nonPeople)\n")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

