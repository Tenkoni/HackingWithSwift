//
//  ViewController.swift
//  project_5
//
//  Created by Lui on 03/09/21.
//

import UIKit

class ViewController: UITableViewController {
    var allWords = [String]()
    var usedWords = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let rightBarButtons = [UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswers)), UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(newWord))]
        navigationItem.rightBarButtonItems = rightBarButtons

                if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: ".txt" ){
            if let startWords = try? String(contentsOf: startWordsURL){
                allWords = startWords.components(separatedBy: "\n")
            }
        }
        
        if allWords.isEmpty {
            allWords = ["emptyness"]
        }
        
        startGame()
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        return cell
    }

    func startGame(){
        title = allWords.randomElement()
        usedWords.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }
    
    @objc func promptForAnswers() {
        let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) {
            [weak self, weak ac] _ in
            guard let answer = ac?.textFields?[0].text else {return}
            self?.submit(answer)
        }
        
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    @objc func newWord(){
        startGame()
    }
    
    func submit(_ answer: String){
        let lowerAnswer = answer.lowercased()
        
        let errorTitle: String
        let errorMessage: String
        
        if isPossible(word: lowerAnswer){
            if isOriginal(word: lowerAnswer){
                if isReal(word: lowerAnswer){
                    usedWords.insert(lowerAnswer, at: 0)
                    
                    let indexPath = IndexPath(row: 0, section: 0)
                    tableView.insertRows(at: [indexPath], with: .automatic)
                    
                    return
                } else {
                    errorTitle = "Unrecognized word"
                    errorMessage = "That word doesn't even exists lmao, you don't even know English!"
                }
            } else {
                errorTitle = "Repeated word"
                errorMessage = "You can't come up with different words? Pathetic!"
            }
        } else {
            errorTitle = "Invalid word"
            errorMessage = "Are you retarded? How can you spell that from \(title!.lowercased())? And don't think on using shorter than 3 letters words or the same word"
        }
        showErrorMessage(withTitle: errorTitle, withMessage: errorMessage)
    }
    
    func isPossible(word: String) -> Bool{
        guard var tempWord = title?.lowercased() else {return false}
        if word.count < 3 {return false}
        if word == tempWord {return false}
        for letter in word {
            if let position = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: position)
            } else {
                return false
            }
        }
        return true
    }
    
    func isOriginal(word:String) -> Bool{
        return !usedWords.contains(word)
    }
    
    func isReal(word:String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        return misspelledRange.location == NSNotFound
    }
    
    
    func showErrorMessage(withTitle etitle:String, withMessage emessage:String){
        let errorAlert = UIAlertController(title: etitle, message: emessage, preferredStyle: .alert)
        errorAlert.addAction(UIAlertAction(title: "S-Sorry", style: .default))
        present(errorAlert, animated: true)
    }
    
}

