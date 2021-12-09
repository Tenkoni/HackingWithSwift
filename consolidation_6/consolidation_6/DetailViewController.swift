//
//  DetailViewController.swift
//  consolidation_6
//
//  Created by Lui on 25/11/21.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var pop: UILabel!
    @IBOutlet var lang: UILabel!
    var country: Country!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let selectedCountry = country else { return }
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(shareCountry))
        
        
        
        title = selectedCountry.name
        imageView.image = UIImage(named: selectedCountry.image)
        imageView.layer.borderColor = UIColor(white: 0, alpha: 0.5).cgColor
        imageView.layer.borderWidth = 2
        imageView.layer.cornerRadius = 10
        pop.text = selectedCountry.population
        lang.text = selectedCountry.language
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
    
    
    @objc func shareCountry () {
        let vc = UIActivityViewController(activityItems: [title, imageView.image, pop.text, lang.text], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
