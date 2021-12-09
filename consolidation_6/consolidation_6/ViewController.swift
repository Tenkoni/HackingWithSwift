//
//  ViewController.swift
//  consolidation_6
//
//  Created by Lui on 23/11/21.
//

import UIKit

class ViewController: UICollectionViewController {

    var countries = [Country]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchJSON()
        // Do any additional setup after loading the view.
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Country", for: indexPath) as? CountryCell else { fatalError("Unable to dequeue cell, dod.") }
       let country = countries[indexPath.item]
        cell.name.text = country.name
        cell.imageView.image = UIImage(named: country.image)
        cell.imageView.backgroundColor = .black
        cell.imageView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
       cell.imageView.layer.borderWidth = 2
       cell.imageView.layer.cornerRadius = 3
        cell.layer.cornerRadius = 7
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let country = countries[indexPath.item]
        if let vc = storyboard?.instantiateViewController(identifier: "Detail") as? DetailViewController {
            vc.country = country
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return countries.count
    }
    
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        print(String(decoding: json, as: UTF8.self))
        if let jsonPetitions = try? decoder.decode([Country].self, from: json){
            countries = jsonPetitions
            collectionView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
        } else {
            performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
        }
    }
    
    @objc func fetchJSON(){
        
        if let bundlePath = Bundle.main.path(forResource: "counties", ofType: "json") {
            if let data = try? String(contentsOfFile: bundlePath).data(using: .utf8){
                
                parse(json: data)
                return
                
            }
        }
        performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
    }
    
    @objc func showError() {

        let ac = UIAlertController(title: "Loading Error", message: "There was a problem loading the country data, check your connectrion and try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Okay", style: .default))
        present(ac, animated: true)

    }

    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
}

