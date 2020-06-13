
import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate{

    @IBOutlet weak var mapView: MKMapView!
    
    
    @IBOutlet weak var transportType: UISegmentedControl!
    
    
    @IBOutlet weak var stepperzoom: UIStepper!
    
    
    @IBOutlet weak var findWay: UIButton!
    
    var originalvalue = 0.0
    var regionMeters : Double = 10000
    let locationManager: CLLocationManager = {
       let manager = CLLocationManager()
       manager.requestWhenInUseAuthorization()
       return manager
    }()
       
    var destinationCoordinates : CLLocationCoordinate2D?
    var coordinate: CLLocationCoordinate2D?
       
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.isZoomEnabled = false
        mapView.showsUserLocation = true
        mapView.delegate = self
        
        mapView.showsCompass = true
        mapView.showsScale = true
        currentLocation()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer:)))
        mapView.addGestureRecognizer(tap)
        

       
    }
    
    
    
    
    @IBAction func locationBtn(_ sender: Any) {
       routemod()
    }
    
  
    
    func zoomIn() {
         var region: MKCoordinateRegion = mapView.region
                                           region.span.latitudeDelta /= 2.0
                                           region.span.longitudeDelta /= 2.0
                                           mapView.setRegion(region, animated: true)
    }
    
    func zoomOut(){
         var region: MKCoordinateRegion = mapView.region
                                            region.span.latitudeDelta = min(region.span.latitudeDelta * 2.0, 180.0)
                                            region.span.longitudeDelta = min(region.span.longitudeDelta * 2.0, 180.0)
                                            mapView.setRegion(region, animated: true)
    }
    
    
    
    
    @IBAction func stepperMod(_ sender: Any) {
    
        var newvalue = stepperzoom.value
        
        if(newvalue > self.originalvalue){

            self.originalvalue = stepperzoom.value

            zoomIn()
            
        }else {

            self.originalvalue = stepperzoom.value

        zoomOut()
            
        }
        
       
    }
    
    
    @objc func handleTap(recognizer: UITapGestureRecognizer) {
     
    let mapAnnotations  = self.mapView.annotations
    self.mapView.removeAnnotations(mapAnnotations)
    let tapLocation = recognizer.location(in: mapView)
    self.destinationCoordinates = mapView.convert(tapLocation, toCoordinateFrom: mapView)
        
        recognizer.numberOfTapsRequired = 2
        
        if recognizer.state == .ended
        {
            
             let annotation = MKPointAnnotation()
             annotation.coordinate = self.destinationCoordinates!
             self.mapView.addAnnotation(annotation)
        }
    }
    
    func currentLocation() {
       locationManager.delegate = self
       locationManager.desiredAccuracy = kCLLocationAccuracyBest
       if #available(iOS 11.0, *) {
          locationManager.showsBackgroundLocationIndicator = true
       } else {
        
       }
       locationManager.startUpdatingLocation()
    }

    func routemod() {
        let destCoordinate = MKDirections.Request()
               let sourceCoordinate = mapView.userLocation.coordinate
               
               let source = CLLocationCoordinate2DMake(sourceCoordinate.latitude, sourceCoordinate.longitude)
               let destination = CLLocationCoordinate2DMake(self.destinationCoordinates?.latitude ?? 0, self.destinationCoordinates?.longitude ?? 0)
               
               let sourcePlacemark = MKPlacemark(coordinate: source)
               let destPlacemark = MKPlacemark(coordinate: destination)
        
        switch transportType.selectedSegmentIndex {
                       case 0 :
                           destCoordinate.transportType = .walking
                           for overlay in mapView.overlays{
                               mapView.removeOverlay(overlay)
                           }
                       case 1 :
                           destCoordinate.transportType = .automobile
                           for overlay in mapView.overlays{
                               mapView.removeOverlay(overlay)

                           }
                       default:
                           break
                    
                    }
        
        destCoordinate.source = MKMapItem(placemark: sourcePlacemark)
        destCoordinate.destination =  MKMapItem(placemark: destPlacemark)
        
        
        let direction = MKDirections(request: destCoordinate)
        direction.calculate{
            (response, error) in
               guard let locResponse = response else{
                          if let error = error{
                              print(error)
                          }
                          return
                    }
                for route in locResponse.routes{
                       self.mapView.addOverlay(route.polyline,level:.aboveRoads)
                       self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
                   }
                  
               }
        
        
    }
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {

        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        renderer.strokeColor = UIColor.red
        renderer.lineWidth = 8.0
        return renderer

    }
}


extension ViewController: CLLocationManagerDelegate {
     func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last! as CLLocation
        let currentLocation = location.coordinate
        let coordinateRegion = MKCoordinateRegion(center: currentLocation, latitudinalMeters: regionMeters, longitudinalMeters: regionMeters)
        mapView.setRegion(coordinateRegion, animated: true)
        locationManager.stopUpdatingLocation()
     }
     
     func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
     }
}

