//
//  ViewController.swift
//  project_6b
//
//  Created by Lui on 14/09/21.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let label1 = createLabel(colour: .blue, text: "How")
        let label2 = createLabel(colour: .brown, text: "Do")
        let label3 = createLabel(colour: .cyan, text: "You")
        let label4 = createLabel(colour: .green, text: "Turn")
        let label5 = createLabel(colour: .magenta, text: "This")
        let label6 = createLabel(colour: .purple, text: "On")
        
        view.addSubview(label1)
        view.addSubview(label2)
        view.addSubview(label3)
        view.addSubview(label4)
        view.addSubview(label5)
        view.addSubview(label6)

//        let viewsDictionary = ["label1": label1, "label2": label2, "label3": label3, "label4": label4, "label5": label5, "label6":label6 ]
//        let metrics = ["labelHeight":88]
//
//        for label in viewsDictionary.keys {
//            view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[\(label)]|", options: [], metrics: nil, views: viewsDictionary))
//        }
//        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[label1(labelHeight@999)]-[label2(label1)]-[label3(label1)]-[label4(label1)]-[label5(label1)]-[label6(label1)]-(>=10)-|", options: [], metrics: metrics, views: viewsDictionary))
        
        var previous: UILabel?
        let labelArray = [label1, label2, label3, label4, label5, label6]
        for label in labelArray{
            label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
            label.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
            //label.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
            label.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 1/6, constant: -10).isActive = true
            if let previous = previous {
                label.topAnchor.constraint(equalTo: previous.bottomAnchor, constant: 10).isActive = true
            } else {
                label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
            }
            previous = label
        }
        
    }

    
    
    func createLabel( colour: UIColor, text: String) -> UILabel{
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = colour
        label.text = text
        label.sizeToFit()
        return label
    }
    
}

