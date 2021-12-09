//
//  ViewController.swift
//  project_9
//
//  Created by Lui on 27/09/21.
//

import UIKit

class ViewController: UITableViewController {
    var petitions = [Petition]()
    var filterPetitions = [Petition]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let rightBarButtons = [UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(credits)), UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(filter)), UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(reloadData))]
        navigationItem.rightBarButtonItems = rightBarButtons
        
        performSelector(inBackground: #selector(fetchJSON), with: nil)
//        var urlString: String
//
//        if navigationController?.tabBarItem.tag == 0 {
//            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
//        } else {
//            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
//        }
//        DispatchQueue.global(qos: .userInitiated).async {
//            [weak self] in
//            if let url = URL(string: urlString) {
//                if let data = try? Data (contentsOf: url){
//                    self?.parse(json: data)
//                    return
//                }
//            }
//            self?.showError()
//        }
        
    }
    
    @objc func fetchJSON(){
        
        var urlString: String
        
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }

            if let url = URL(string: urlString) {
                if let data = try? Data (contentsOf: url){
                    parse(json: data)
                    return
                }
            }
        performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
    }
    
    
    @objc func showError() {

        let ac = UIAlertController(title: "Loading Error", message: "There was a problem loading the feed, check your connectrion and try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Okay", style: .default))
        present(ac, animated: true)

    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json){
            petitions = jsonPetitions.results
            filterPetitions = jsonPetitions.results
            tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
        } else {
            performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
        }
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterPetitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = filterPetitions[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = petitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func filterWord(_ parameters: String) {
        let upperParameters = parameters.uppercased()
        filterPetitions.removeAll(keepingCapacity: true)
        for petition in petitions {
            if petition.body.uppercased().contains(upperParameters) || petition.title.uppercased().contains(upperParameters) {
                filterPetitions.append(petition)
            }
        }
        tableView.performSelector(onMainThread:#selector(reloadData), with: nil, waitUntilDone: false)
    }
    
    @objc func credits() {
        let ac = UIAlertController(title: "Credits", message: "Information provided by 'We, the people' from the USA Government.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Okay", style: .default))
        present(ac, animated: true)
    }
    
    @objc func filter() {
        let ac = UIAlertController(title: "Filter", message: "Enter the search parameters.", preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) {
            [weak self]  _ in
            guard let parameter = self.ac?.textFields?[0].text else {return}
            self?.performSelector(inBackground: #selector(self?.filterWord), with: parameter)
        }
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    @objc func reloadData() {
        filterPetitions = petitions
        tableView.reloadData()
    }

}

