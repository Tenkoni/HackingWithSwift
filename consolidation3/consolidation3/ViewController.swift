//
//  ViewController.swift
//  consolidation3
//
//  Created by Lui on 24/09/21.
//

import UIKit

class ViewController: UITableViewController {

    var listItems = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Shopping List"
        let rightBarButtons = [UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptInput)),UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(shareList))]
        let leftBarButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(reset))
        navigationItem.rightBarButtonItems = rightBarButtons
        navigationItem.leftBarButtonItem = leftBarButton
        
        restartList()
        
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath)
        cell.textLabel?.text = listItems[indexPath.row]
        return cell
    }

    
    @objc func promptInput(){
        let ac = UIAlertController(title: "Enter item", message: nil, preferredStyle: .alert)
        ac.addTextField()
        let submitAction = UIAlertAction(title: "Submit", style: .default) {
            [weak self, weak ac] _ in
            guard let answer = ac?.textFields?[0].text else {return}
            self?.submit(answer)
        }
        
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    @objc func reset (){
        let ac = UIAlertController(title: "Erase list", message: "Do you want to delete the current list?", preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) {
            [weak self] _ in
            self?.restartList()
        }
        ac.addAction(deleteAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        ac.addAction(cancelAction)
        present(ac, animated: true )
        
    }
    
    @objc func shareList(){
        let vc = UIActivityViewController(activityItems: [listItems.joined(separator: ", ")], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
    
    func submit(_ answer: String) {
        listItems.insert(answer, at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    
    func restartList(){
        listItems.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }
}

