//
//  ViewController.swift
//  FindWay_Ikroop_C0774174
//
//  Created by VirkIkroop on 2020-06-12.
//  Copyright © 2020 VirkIkroop. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController{
    
    @IBOutlet weak var mapView: MKMapView!
    
    
   let locationManager = CLLocationManager()
    let regionInMeters : Double = 100000

    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationServices()
        // Do any additional setup after loading the view.
        
        
    }
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func centerViewOnUserLocation(){
        if let location = locationManager.location?.coordinate
        {
            let region1 = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region1, animated: true)
        }
    }
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled(){
            setupLocationManager()
            checkLocationAuthorization()
        }
        else{
            //show alert
        }
    }
    
    func checkLocationAuthorization()
    {
        switch CLLocationManager.authorizationStatus(){
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            centerViewOnUserLocation()
            locationManager.startUpdatingLocation()
            break
        case .denied:
            //show alert
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            //show alert
            break
        case .authorizedAlways:
            break
        }
    }
    


}
extension ViewController:CLLocationManagerDelegate
{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
    }
    
    
}













