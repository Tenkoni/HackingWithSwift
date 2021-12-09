//
//  ViewController.swift
//  project_8
//
//  Created by Lui on 30/09/21.
//

import UIKit

class ViewController: UIViewController {

    var cluesLabel: UILabel!
    var answersLabel: UILabel!
    var currentAswer: UITextField!
    var scoreLabel: UILabel!
    var letterButtons = [UIButton]()
    
    var activatedButtons = [UIButton]()
    var solutions = [String]()
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    var level = 1
    var answered = 0
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        scoreLabel = UILabel()
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.textAlignment = .right
        scoreLabel.text = "Score: 0"
        view.addSubview(scoreLabel)
        
        cluesLabel = UILabel()
        cluesLabel.translatesAutoresizingMaskIntoConstraints = false
        cluesLabel.font = UIFont.systemFont(ofSize: 24)
        cluesLabel.text = "CLUES"
        cluesLabel.numberOfLines = 0
        cluesLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        view.addSubview(cluesLabel)
        
        answersLabel = UILabel()
        answersLabel.translatesAutoresizingMaskIntoConstraints = false
        answersLabel.font = UIFont.systemFont(ofSize: 24)
        answersLabel.text = "ANSWERS"
        answersLabel.textAlignment = .right
        answersLabel.numberOfLines = 0
        answersLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        view.addSubview(answersLabel)
        
        currentAswer = UITextField()
        currentAswer.translatesAutoresizingMaskIntoConstraints = false
        currentAswer.placeholder = "Tap letters to guess"
        currentAswer.textAlignment = .center
        currentAswer.font = UIFont.systemFont(ofSize: 44)
        currentAswer.isUserInteractionEnabled = false
        view.addSubview(currentAswer)
        
        let submit = UIButton(type: .system)
        submit.translatesAutoresizingMaskIntoConstraints = false
        submit.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
        submit.setTitle("Submit", for: .normal)
        view.addSubview(submit)
        
        let clear = UIButton(type: .system)
        clear.translatesAutoresizingMaskIntoConstraints = false
        clear.addTarget(self, action: #selector(clearTapped), for: .touchUpInside)
        clear.setTitle("Clear", for: .normal)
        view.addSubview(clear)
        
        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonsView)
        
        NSLayoutConstraint.activate([
            scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            cluesLabel.topAnchor.constraint(equalTo:  scoreLabel.bottomAnchor),
            cluesLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 100),
            cluesLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.6, constant: -100),
            
            answersLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            answersLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -100),
            answersLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.4, constant: -100),
            answersLabel.heightAnchor.constraint(equalTo: cluesLabel.heightAnchor),
            
            currentAswer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currentAswer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            currentAswer.topAnchor.constraint(equalTo: cluesLabel.bottomAnchor, constant: 20),
            
            submit.topAnchor.constraint(equalTo: currentAswer.bottomAnchor),
            submit.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -100),
            submit.heightAnchor.constraint(equalToConstant: 44),
            
            clear.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 100),
            clear.centerYAnchor.constraint(equalTo: submit.centerYAnchor),
            clear.heightAnchor.constraint(equalTo: submit.heightAnchor),
            
            buttonsView.widthAnchor.constraint(equalToConstant: 750),
            buttonsView.heightAnchor.constraint(equalToConstant: 320),
            buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsView.topAnchor.constraint(equalTo: clear.bottomAnchor, constant: 20),
            buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20)
            
        ])
        
        let height = 80
        let width = 150
        
        for row in 0..<4 {
            for column in 0..<5 {
                let letterButton = UIButton(type: .system)
                letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 36)
                letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
                letterButton.setTitle("OwO", for: .normal)
                //from the challenge, it looks ugly though
                letterButton.layer.borderWidth = 0 //the borders make me want to puke
                letterButton.layer.borderColor = UIColor.lightGray.cgColor
                
                let frame = CGRect(x: width*column, y: height*row, width: width, height: height)
                letterButton.frame = frame
                
                buttonsView.addSubview(letterButton)
                letterButtons.append(letterButton)
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadLevel()
    }
    
    @objc func letterTapped (_ sender: UIButton){
        
        guard let buttonTitle = sender.titleLabel?.text else { return }
        currentAswer.text = currentAswer.text?.appending(buttonTitle)
        activatedButtons.append(sender)
        UIView.animate(withDuration: 1, delay: 0, options: []) {
            sender.alpha = 0
        } completion: { finished in
            sender.isHidden = true
        }

        
    }
    
    @objc func submitTapped(_ sender: UIButton){
        guard let answerText = currentAswer.text else { return }
        
        if let solutionPosition = solutions.firstIndex(of: answerText) {
            activatedButtons.removeAll()
            
            var splitAnswers = answersLabel.text?.components(separatedBy: "\n")
            splitAnswers?[solutionPosition] = answerText
            answersLabel.text = splitAnswers?.joined(separator: "\n")
            
            currentAswer.text = ""
            score += 1
            answered += 1
            if answered % 7 == 0 {
                let ac = UIAlertController(title: "Finished!", message: "Get ready for the next level.", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "LETSGOOOOO", style: .default, handler: levelUP))
                present(ac, animated: true)
            }
        } else {
            let ac = UIAlertController(title: "You're wrong!", message: "**It was like she was looking at walking garbage.**", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "I'M SORRY", style: .destructive))
            present(ac, animated: true)
            score -= 1
        }
        
    }
    
    @objc func clearTapped(_ sender: UIButton){
        currentAswer.text = ""
        
        for button in activatedButtons {
            button.isHidden = false
        }
        activatedButtons.removeAll()
    }
    
    func loadLevel(){
        var clueString = ""
        var solutionString = ""
        var letterBits = [String]()
        DispatchQueue.global(qos: .userInitiated).async {
            [weak self] in
            if let levelFileURL = Bundle.main.url(forResource: "level\(self!.level)", withExtension: ".txt"){
                if let contentsURL = try? String(contentsOf: levelFileURL){
                    var lines = contentsURL.components(separatedBy: "\n")
                    lines.shuffle()
                    
                    for (index, line) in lines.enumerated(){
                        let parts = line.components(separatedBy: ": ")
                        let bits = parts[0].components(separatedBy: "|")
                        let clue = parts[1]
                        clueString += "\(index+1). \(clue)\n"
                        
                        let solutionWord = parts[0].replacingOccurrences(of: "|", with: "")
                        solutionString += "\(solutionWord.count) letters. \n"
                        self?.solutions.append(solutionWord)
                        
                        letterBits += bits
                        
                        
                    }
                }
            }
            
            DispatchQueue.main.async {
                [weak self] in
                self?.cluesLabel.text = clueString.trimmingCharacters(in: .whitespacesAndNewlines)
                self?.answersLabel.text = solutionString.trimmingCharacters(in: .whitespacesAndNewlines)
                self?.letterButtons.shuffle()
                
                if self?.letterButtons.count == letterBits.count{
                    for i in 0..<(self?.letterButtons.count)!{
                        self?.letterButtons[i].setTitle(letterBits[i], for: .normal)
                    }
                }
            }
           
        }
        
       
    }
    
    func levelUP(action: UIAlertAction) {
        level += 1
        
        solutions.removeAll(keepingCapacity: true)
        loadLevel()
        
        for button in letterButtons {
            button.isHidden = false
        }
    }


}

