//
//  ViewController.swift
//  project_6
//
//  Created by Lui on 24/08/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    
    var countries = [String]()
    var score = 0
    var correctAnswer = 0
    var totalQuestions = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(scoreTap))
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        
        button1.layer.borderWidth = 2
        button2.layer.borderWidth = 2
        button3.layer.borderWidth = 2
        button1.layer.borderColor = UIColor(red: 0.5, green: 0.3, blue: 0.7, alpha: 1).cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor

        
        askQuestion()
    }

    func askQuestion(_ action: UIAlertAction! = nil){
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        
        title = "Select \(countries[correctAnswer].uppercased()). Score: \(score)"
        

    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        var title: String
        if sender.tag == correctAnswer{
            title = "Correct"
            score += 1
        } else {
            title = "Wrong"
            score -= 1
        }
        
        totalQuestions += 1
        if(totalQuestions < 10){
            var message = "Your score is \(score)"
            
            if (title != "Correct"){
                message = """
                    Wrong: You selected \(countries[sender.tag].uppercased())
                    Your score is \(score)
                    """
            }
                
            let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
            present(ac, animated: true)
        
        }else {
            
            
            let final = UIAlertController(title: "Game Over", message: "Final score \(score)", preferredStyle: .alert)
            final.addAction(UIAlertAction(title: "Restart", style: .destructive, handler: askQuestion))
            present(final, animated: true)
            
            score = 0
            totalQuestions = 0
        }
        
    }
    
    @objc func scoreTap() {
        
        let vc = UIActivityViewController(activityItems: ["Your scorre is: \(score)"], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
    
    

}

