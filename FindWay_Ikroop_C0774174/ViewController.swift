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
    
    
    @IBOutlet weak var addressLabel: UILabel!
    
    
    
   let locationManager = CLLocationManager()
    let regionInMeters : Double = 100000
    var previousLocations : CLLocation?

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
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
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
            startTrackingUserLocation()
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
    
    func startTrackingUserLocation() {
        mapView.showsUserLocation = true
        centerViewOnUserLocation()
        locationManager.startUpdatingLocation()
        previousLocations = getCenterLocation(for: mapView)
        
    }
    func getCenterLocation(for mapView: MKMapView) -> CLLocation
    {
        let latitude = mapView.centerCoordinate.latitude
        let longitude = mapView.centerCoordinate.longitude
        return CLLocation(latitude: latitude, longitude: longitude)
    }


}
extension ViewController:CLLocationManagerDelegate
{
    //func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
     //   guard let location = locations.last else{ return}
     //   let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
     //   let region = MKCoordinateRegion.init(center: center, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
     //   mapView.setRegion(region, animated: true)
        
   // }
    
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
        
    }
    
    
}

extension ViewController:MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let center = getCenterLocation(for: mapView)
        let geocoder = CLGeocoder()
        guard let previousLocations = self.previousLocations else {
            return
        }
        guard center.distance(from: previousLocations) > 50 else {return}
        self.previousLocations = center
        
        geocoder.reverseGeocodeLocation(center){[weak self] (placemarks, error) in
            guard let self = self else {return}
            
            if let _ = error{
                //todo list
                return
                
            }
            guard let placemark = placemarks?.first else {
                //todo list
                return
            }
            
            let streetNumber = placemark.subThoroughfare ?? ""
            let streetName = placemark.thoroughfare ?? ""
            
            DispatchQueue.main.async {
                self.addressLabel.text = "\(streetNumber) \(streetName)"
            }
            
            
        }
    }
    
}













