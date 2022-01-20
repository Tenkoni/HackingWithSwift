//
//  ActionViewController.swift
//  Extension
//
//  Created by Lui on 13/01/22.
//

import UIKit
import MobileCoreServices

class ActionViewController: UIViewController {

    @IBOutlet var script: UITextView!
    
    var pageTitle = ""
    var pageURL = ""
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItems = [UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done)), UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(showDefaultScripts))]
        
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)

        
        if let inputItem = extensionContext?.inputItems.first as? NSExtensionItem {
            if let itemProvider = inputItem.attachments?.first {
                itemProvider.loadItem(forTypeIdentifier: kUTTypePropertyList as String) { [weak self] (dict, error) in
                    guard let itemDictionary = dict as? NSDictionary else {return}
                    guard let javaScriptValues = itemDictionary[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary else {return}
                    
                    self?.pageTitle = javaScriptValues["title"] as? String ?? ""
                    self?.pageURL = javaScriptValues["URL"] as? String ?? ""
                    
                    
                    DispatchQueue.main.async {
                        self?.title = self?.pageTitle
                        self?.script.text = self?.defaults.string(forKey: self?.pageURL ?? "")
                    }
                }
            }
        }
        
    }

    @IBAction func done() {
        let item = NSExtensionItem()
        let scriptJava = script.text
        let argument: NSDictionary = ["customJavaScript": scriptJava ?? ""]
        let webDictionary: NSDictionary = [NSExtensionJavaScriptFinalizeArgumentKey: argument]
        let customJavaScript = NSItemProvider(item: webDictionary, typeIdentifier: kUTTypePropertyList as String)
        item.attachments = [customJavaScript]
        defaults.set(scriptJava ?? "", forKey: pageURL)
        extensionContext?.completeRequest(returningItems: [item])
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey]  as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            script.contentInset = .zero
        } else { //nice improvement would be adding the predictive text menu to the height when it shows, so we dont ahve obsucred text
            script.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        
        script.scrollIndicatorInsets = script.contentInset
        let selectedRange = script.selectedRange
        script.scrollRangeToVisible(selectedRange)
        
    }
    
    @objc func showDefaultScripts() {
        let ac = UIAlertController(title: "Select prewritten script", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Hello World Alert", style: .default, handler: defaultScripts))
        ac.addAction(UIAlertAction(title: "Goodbye World Alert", style: .default, handler: defaultScripts))
        ac.addAction(UIAlertAction(title: "Black Background", style: .default, handler: defaultScripts))
        present(ac, animated: true)
    }
    
    func defaultScripts(alert: UIAlertAction){
        switch alert.title {
        case "Hello World Alert":
            script.text = "alert(\"Hello world\");"
        case "Black Background":
            script.text = "document.body.style.backgroundColor = \"black\";"
        case "Goodbye World Alert":
            script.text = "alert(\"Goodbye world\");"
        default:
            script.text = ""
        }
        
        
    }

}
