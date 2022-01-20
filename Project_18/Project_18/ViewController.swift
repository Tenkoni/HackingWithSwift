//
//  ViewController.swift
//  Project_18
//
//  Created by Lui on 11/01/22.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //naive debug method, using print
        //print(1,2,3,4,5, separator: "-", terminator: "")
        
        //debugging with aserts
        //basically a very strict debugging method, if the value isn't what you expected the app crashses immediately, these are removed by xcode when actually publishing an app
        //assert(1 == 1, "Math failure")
        //assert(2 == 1, "Math failure")
        
        //breakpoints
        //pause the program and check all the values at that time, they can also be conditional and also exception breakpoints, just click the exception icon on top left corner, then the + sign and add an exception breakpoint
        for i in 1...100 {
            print("Number \(i)")
        }
        //view debugging
        //can capture a view hierarchy, not in this app but can be easily seen on project13, just click on the overlapping rectangles, above the debugging console,if you just click and dragg a view you will view a stack of views in a 3d way.
        
    }


}

