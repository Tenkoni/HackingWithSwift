//
//  ViewController.swift
//  Consolidation_8
//
//  Created by Lui on 18/01/22.
//

import UIKit

class ViewController: UITableViewController {

    var notes = [Note]()
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: .add, style: .plain, target: self, action: #selector(createNote))

        //let sampleNote = Note(title: "Example note", content: "Example body for your note")
        //notes.append(sampleNote)
        if let savedNotes = defaults.object(forKey: "Notes") as? Data {
            let jsonDecoder = JSONDecoder()
            do {
                notes = try jsonDecoder.decode([Note].self, from: savedNotes)
            } catch  {
                print("Failed")
            }
        }
        
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let note = notes[indexPath.row]
        cell.textLabel?.text = note.title
        cell.detailTextLabel?.text = note.content
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(identifier: "TextView") as? TextViewController {
            vc.receivedNote = notes[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        for (index, note) in notes.enumerated().reversed() {
            if note.title == "" {
                notes.remove(at: index)
            }
        }
        tableView.reloadData()
        save()
    }
    
    @objc func createNote () {
        let ac = UIAlertController(title: "New note", message: "Type the note title.", preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak ac] _ in
            guard let title = ac?.textFields?[0].text else {return}
            let newNote = Note(title: title, content: "")
            self?.notes.append(newNote)
            self?.tableView.reloadData()
            self?.save()

        }
        ac.addAction(submitAction)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
        
    }
    
    func save() {
        let jsonEnconder = JSONEncoder()
        if let savedFata = try? jsonEnconder.encode(notes) {
            defaults.set(savedFata, forKey: "Notes")
        } else {
            print("Save failed")
        }
    }
    
}

