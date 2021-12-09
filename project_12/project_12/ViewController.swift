//
//  ViewController.swift
//  project_12
//
//  Created by Lui on 05/11/21.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //this is how userdefaults work.
        let defaults = UserDefaults.standard
        
        //saving values
        defaults.set(5, forKey: "Days")
        defaults.set(true, forKey: "UserFaceID")
        defaults.set(CGFloat.pi, forKey: "raspberrypi")
        
        defaults.set("Ereshkigal", forKey: "sumerianGoddess")
        defaults.set(Date(), forKey: "lastAccess")
        
        let array = ["Goodbye", "sucker"]
        defaults.set(array, forKey: "savedArray")
        
        let dict = ["Name": "Totoro", "Residence": "Tonari"]
        defaults.set(dict, forKey: "savedDict")
        
        //using values
        
        let savedInteger = defaults.integer(forKey: "Days")
        let savedBool = defaults.bool(forKey: "UserFaceID")
        let savedFloat = defaults.float(forKey: "raspberrypi")
        //for any objects is a bit more tricky, as you can kill it, so we use nil coalescing
        let savedArray = defaults.object(forKey: "savedArray") as? [String] ?? [String]()
        
        let savedDict = defaults.object(forKey: "savedDict") as? [String:String] ?? [String:String]()
        
    }


}

