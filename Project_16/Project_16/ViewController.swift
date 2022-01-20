//
//  ViewController.swift
//  Project_16
//
//  Created by Lui on 10/01/22.
//

import UIKit
import MapKit


class ViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet var mapView: MKMapView!
    let website = "https://en.wikipedia.org/wiki/"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(changeMapType))
        
        
        let tokyo = Capital(title: "Tokyo", coordinate: CLLocationCoordinate2D(latitude: 35.67, longitude: 139.65), info: "High technology, comfy vibes, I like this place.")
        let oslo = Capital(title: "Oslo", coordinate: CLLocationCoordinate2D(latitude: 59.95, longitude: 10.75), info: "Founded long time ago...")
        let paris = Capital(title: "Paris", coordinate: CLLocationCoordinate2D(latitude: 48.85, longitude: 2.35), info: "City of lights.")
        let rome = Capital(title: "Rome", coordinate: CLLocationCoordinate2D(latitude: 41.9, longitude: 12.5), info: "All roads lead to here...")
        let cdmx = Capital(title: "Mexico City", coordinate: CLLocationCoordinate2D(latitude: 19.43, longitude: -99.13), info: "Land full of ancient civilizations")
        
        //mapView.addAnnotation(london)
        mapView.addAnnotations([tokyo, oslo, paris, rome, cdmx])
        
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is Capital else { return nil}
        
        let identifier = "Capital"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            let btn = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = btn
        } else {
            annotationView?.annotation = annotation
        }
        //guard let annotationView = annotationView as? MKPinAnnotationView else { return nil } //one way to typecast
        if let annotationView = annotationView as? MKPinAnnotationView  { //another way, i feel this is more appropiate and wont crash the program in case the typecast fails
            annotationView.pinTintColor = UIColor(red: 209/255, green: 172/255, blue: 109/255, alpha: 1)
            return annotationView
        }
        return annotationView
        
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let capital = view.annotation as? Capital else { return }
        
        let placeName = capital.title
        let scapedName = placeName?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
//        let placeInfo = capital.info
//
//        let ac = UIAlertController(title: placeName, message: placeInfo, preferredStyle: .alert)
//        ac.addAction(UIAlertAction(title: "I see...", style: .default))
//        present(ac, animated: true)
                
        let url = URL(string: website + scapedName!)!
        if let vc = storyboard?.instantiateViewController(identifier: "WebPop") as? UIWebKitPopOut {
            //vc.modalPresentationStyle = .overCurrentContext
            //vc.modalTransitionStyle = .crossDissolve
            vc.url = url
            navigationController?.pushViewController(vc, animated: true)
        }
        
        
    }

    
    func setMap(action: UIAlertAction) {
        guard let mapType = action.title else { return }
        switch mapType {
        case "Standard":
            mapView.mapType = MKMapType.standard
        case "Hybrid":
            mapView.mapType = MKMapType.hybrid
        case "Muted Standard":
            mapView.mapType = MKMapType.mutedStandard
        case "Hybrid Flyover":
            mapView.mapType = MKMapType.hybridFlyover
        case "Satellite":
            mapView.mapType = MKMapType.satellite
        case "Satellite Flyover":
            mapView.mapType = MKMapType.satelliteFlyover
        
        default:
            return
        }
        
    }
    
    @objc func changeMapType(){
        let ac = UIAlertController(title: "Select map type", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Standard", style: .default, handler: setMap))
        ac.addAction(UIAlertAction(title: "Hybrid", style: .default, handler: setMap))
        ac.addAction(UIAlertAction(title: "Hybrid Flyover", style: .default, handler: setMap))
        ac.addAction(UIAlertAction(title: "Muted Standard", style: .default, handler: setMap))
        ac.addAction(UIAlertAction(title: "Satellite", style: .default, handler: setMap))
        ac.addAction(UIAlertAction(title: "Satellite Flyover", style: .default, handler: setMap))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }

}

