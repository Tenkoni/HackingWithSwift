//
//  ViewController.swift
//  consolidation5
//
//  Created by Lui on 09/11/21.
//

import UIKit

class ViewController: UITableViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var cards = [Card]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPerson))
        let defaults = UserDefaults.standard
        if let savedCards = defaults.object(forKey: "cards") as? Data {
            let jsonDecoder = JSONDecoder()
            do {
                cards = try jsonDecoder.decode([Card].self, from: savedCards)
            } catch {
                print("error loading")
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cards.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Card", for: indexPath) as? CardCell else {fatalError("couldn't unwrap cardcell")}
        let card = cards[indexPath.item]
        cell.cardName.text = card.name
        cell.cardName.textColor = .white
        let path = getDocumentsDirectory().appendingPathComponent(card.image)
        cell.cardImage.image = UIImage(contentsOfFile: path.path)
        cell.cardImage.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        cell.cardImage.layer.borderWidth = 2
        cell.cardImage.layer.cornerRadius = 3
        cell.layer.cornerRadius = 7
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(identifier: "Detail") as? DetailViewController {
            vc.selectedImage = cards[indexPath.row].image
            vc.currentIndex = indexPath.row
            vc.listSize = cards.count
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    
    @objc func addNewPerson(){
        
        let ac = UIAlertController(title: "Name picture", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "OK", style: .default){ [weak self, weak ac] _ in
            guard let newName = ac?.textFields?[0].text else {return}
            let card = Card(name: newName, image: "image")
            self?.cards.append(card)
            
            let picker = UIImagePickerController()
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                picker.sourceType = .camera
            }
            picker.allowsEditing = true
            picker.delegate = self
            self?.present(picker, animated: true)
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
        
        
    }

    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        cards.removeLast()
        dismiss(animated: true )
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            return
        }
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8){
            try? jpegData.write(to: imagePath)
        }
        cards.last?.image = imageName
        save()
        tableView.reloadData()
        dismiss(animated: true)
    }
    
    func save() {
        let jsonEncoder = JSONEncoder()
        
        if let savedData = try? jsonEncoder.encode(cards) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "cards")
        } else {
            print("save failed")
        }
    }

}
