//
//  ViewController.swift
//  Project_22
//
//  Created by Lui on 19/01/22.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet var distanceReading: UILabel!
    @IBOutlet var beaconName: UILabel!
    var locationManager: CLLocationManager?
    var initialBeaconDetected = true
    var customView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customView = UIView(frame: CGRect(x: 0, y: 0, width: 256, height: 256))
        customView.layer.cornerRadius = 128
        customView.backgroundColor = .red
        customView.layer.zPosition = -1
        customView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(customView)
        customView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        customView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        customView.widthAnchor.constraint(equalToConstant: 256).isActive = true
        customView.heightAnchor.constraint(equalToConstant: 256).isActive = true
        
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization() //requests authorization to use the user location even when the app is not in use
        //locationManager?.requestWhenInUseAuthorization() //requests autorization to use user location only when in use, we can only pick one of these
        view.backgroundColor = .gray
        
        
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if manager.authorizationStatus == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    startScanning()
                }
            }
        }
    }

    func startScanning() {
        let uuid = UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5")! //This is a uuid associated to a test beacon provided by apple
        //with this we are detecting for beacons with the same uuid, but diffent minor locations
        let beaconRegion = CLBeaconRegion(uuid: uuid, major: 1, minor: 1, identifier: "MyBeacon")
        let beaconRegion2 = CLBeaconRegion(uuid: uuid, major: 1, minor: 2, identifier: "MyBeacon2")
        let beaconRegion3 = CLBeaconRegion(uuid: uuid, major: 1, minor: 3, identifier: "MyBeacon3")
        
        locationManager?.startMonitoring(for: beaconRegion)
        locationManager?.startMonitoring(for: beaconRegion2)
        locationManager?.startMonitoring(for: beaconRegion3)
        locationManager?.startRangingBeacons(satisfying: beaconRegion.beaconIdentityConstraint)
        locationManager?.startRangingBeacons(satisfying: beaconRegion2.beaconIdentityConstraint)
        locationManager?.startRangingBeacons(satisfying: beaconRegion3.beaconIdentityConstraint)
    }
    
    func update(distance: CLProximity) {
        UIView.animate(withDuration: 1){ [weak self] in
            switch distance {
            case .far:
                self?.view.backgroundColor = .blue
                self?.distanceReading.text = "Far"
                self?.customView.transform = CGAffineTransform.identity.scaledBy(x: 0.25, y: 0.25)
            case .near:
                self?.view.backgroundColor = .orange
                self?.distanceReading.text = "Near"
                self?.customView.transform = CGAffineTransform.identity.scaledBy(x: 0.5, y: 0.5)
            case .immediate:
                self?.view.backgroundColor = .red
                self?.distanceReading.text = "Right here"
                self?.customView.transform = CGAffineTransform.identity.scaledBy(x: 1, y: 1)
            default:
                self?.view.backgroundColor = .gray
                self?.distanceReading.text = "Unknown"
                self?.customView.transform = CGAffineTransform.identity.scaledBy(x: 0.001, y: 0.001)

            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didRange beacons: [CLBeacon], satisfying beaconConstraint: CLBeaconIdentityConstraint) {
        if let beacon = beacons.first {
            if initialBeaconDetected {
                let ac = UIAlertController(title: "Beacon detected!", message: "A beacon has been detected in range", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Okay", style: .default ))
                present(ac, animated: true)
                initialBeaconDetected = false
            }
            update(distance: beacon.proximity)
            beaconName.text = beaconConstraint.uuid.uuidString //would need to test in a real device, but this makes me wonder how to differentiante between minor and major beacons
        } else {
            update(distance: .unknown)
        }
    }
    
}

