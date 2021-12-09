//
//  ViewController.swift
//  recap1
//
//  Created by Lui on 27/08/21.
//

import UIKit

class ViewController: UITableViewController {
    
    var countries = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Flag Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        
        countries.sort(by: <)

    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Country", for: indexPath)
        cell.imageView?.image = UIImage(named: countries[indexPath.row])
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.orange.cgColor
        cell.textLabel?.text = countries[indexPath.row].uppercased()
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(identifier: "Detail") as? DetailViewController {
            vc.selectedImage = countries[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }

}

