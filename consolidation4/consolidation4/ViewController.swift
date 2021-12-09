//
//  ViewController.swift
//  consolidation4
//
//  Created by Lui on 06/10/21.
//

import UIKit

class ViewController: UIViewController {

    var wordLabel: UILabel!
    var scoreLabel: UILabel!
    var letterButtons = [UIButton]()
    var allWords = [String]()
    let abece = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    var currentAnswer = [String]()
    var unknownWord = [String]()
    var score = 0 {
        didSet {
            scoreLabel.text = "Error: \(score)"
        }
    }
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        scoreLabel = UILabel()
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.textAlignment = .right
        scoreLabel.text = "Errors: 0"
        view.addSubview(scoreLabel)
        
        wordLabel = UILabel()
        wordLabel.translatesAutoresizingMaskIntoConstraints = false
        wordLabel.textAlignment = .center
        wordLabel.font = UIFont.systemFont(ofSize: 45)
        wordLabel.text = "?????"
        wordLabel.numberOfLines = 0
        wordLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        view.addSubview(wordLabel)
        
        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonsView)
        
        
        NSLayoutConstraint.activate([
            scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            wordLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            wordLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.8 ,constant: -100),
            wordLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            buttonsView.widthAnchor.constraint(equalToConstant: 750),
            buttonsView.heightAnchor.constraint(equalToConstant: 480),
            buttonsView.centerXAnchor.constraint(equalTo: wordLabel.centerXAnchor),
            buttonsView.topAnchor.constraint(equalTo: wordLabel.bottomAnchor, constant: 50 ),
            buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20)
        
        ])

        let height = 80
        let width = 150
        
        for row in 0..<6 {
            for column in 0..<5 {
                let letterButton = UIButton(type: .system)
                letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 36)
                letterButton.setTitle("", for: .normal)
                letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
                let frame = CGRect(x: width*column, y: height*row, width: width, height: height)
                letterButton.frame = frame
                buttonsView.addSubview(letterButton)
                letterButtons.append(letterButton)
            }
        }
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: ".txt") {
            if let startWords = try? String(contentsOf: startWordsURL){
                allWords = startWords.components(separatedBy: "\n")
            }
        }
        if allWords.isEmpty {
            allWords = ["emptyness"]
        }
        loadLevel()
    }


    func loadLevel() {
        guard let currentWord = allWords.randomElement() else { return }
        print(currentWord)
        for letter in currentWord{
            currentAnswer.append(String(letter))
            unknownWord.append("?")
            wordLabel.text = unknownWord.joined()
        }
        
        for i in 0..<abece.count {
            letterButtons[i].setTitle(abece[i], for: .normal)
            letterButtons[i].isHidden = false
        }
        
    }
    
    
    @objc func letterTapped (_ sender: UIButton){
        
        guard let buttonTitle = sender.titleLabel?.text else { return }
        let word = buttonTitle.lowercased()
        print(word)
        if currentAnswer.contains(word){
            sender.isHidden = true
            for (index,element) in currentAnswer.enumerated() {
                if element == word {
                    unknownWord[index] = element
                }
            }
            wordLabel.text = unknownWord.joined()
            
            
        } else {
            score+=1
            sender.isHidden = true
        }
        if score == 7 {
            let ac = UIAlertController(title: "Game Over", message: "You’ve met with a terrible fate, haven’t you?", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Play Again", style: .destructive, handler: newGame))
            present(ac, animated: true)
        } else if !unknownWord.contains("?") {
            let ac = UIAlertController(title: "Victory!", message: "Well done, you can actually speak English.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Play Again", style: .default, handler: newGame))
            present(ac, animated: true)

        }
        
        
    }
    
    func newGame (action: UIAlertAction){
        currentAnswer.removeAll()
        unknownWord.removeAll()
        score = 0
        loadLevel()
    }
    
}

