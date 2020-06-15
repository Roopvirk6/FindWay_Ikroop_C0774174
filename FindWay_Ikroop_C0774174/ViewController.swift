
import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate{
    
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    @IBOutlet weak var walkingBtn: UIButton!
    
    
    @IBOutlet var locationBtn: UIButton!
    
    @IBOutlet weak var automobileBtn: UIButton!
    

    
    @IBOutlet weak var stepperZoom: UIStepper!
    
    var originalvalue = 0.0
    
    var locationManager = CLLocationManager()
       var lat: CLLocationDegrees??
       var lon: CLLocationDegrees??
       var location: CLLocation?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
         mapView.delegate = self
                 locationManager.delegate = self
                 
                 //Permission and finding inital location
                 locationManager.requestWhenInUseAuthorization()
                 locationManager.desiredAccuracy = kCLLocationAccuracyBest
                 locationManager.distanceFilter = kCLDistanceFilterNone
                 locationManager.startUpdatingLocation()
                 
                 //Map interactivity
                 mapView.showsUserLocation = true
                 mapView.isZoomEnabled = false
                 
                 //Added double tap gesture
        doubleTapped(gesture: <#UIGestureRecognizer#>)
                 

       
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
           let userLocation = locations[0]
           
           let latitude = userLocation.coordinate.latitude
           let longitude = userLocation.coordinate.longitude
           
           let latDelta: CLLocationDegrees = 0.05
           let longDelta: CLLocationDegrees = 0.05
           
           // 3 - Creating the span, location coordinate and region
           let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: longDelta)
           let customLocation = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
           let region = MKCoordinateRegion(center: customLocation, span: span)
                 
           // 4 - assign region to map
           mapView.setRegion(region, animated: true)
       }
    
       
       @objc func doubleTapped(gesture: UIGestureRecognizer){
           let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
                             tap.numberOfTapsRequired = 2
                             mapView.addGestureRecognizer(tap)
       }
    
    func addAnnotation(location: CLLocationCoordinate2D)
           {
             //Removing previous annotations and route
                      self.mapView.removeOverlays(self.mapView.overlays)
                      let oldAnnotations = self.mapView.annotations
                      self.mapView.removeAnnotations(oldAnnotations)
                      
                      //Adding new annotation
                      let annotation = MKPointAnnotation()
                      annotation.coordinate = location
                      lat = annotation.coordinate.latitude
                      lon = annotation.coordinate.longitude
                      annotation.title = "Destination"
                      self.mapView.addAnnotation(annotation)
        }

        func removePin(){
        
            mapView.removeAnnotations(mapView.annotations)
        }
    
    
    
    
    @IBAction func btnWalking(_ sender: Any)
    {
        mapView.removeOverlays(mapView.overlays)
        
        let sourcePlaceMark = MKPlacemark(coordinate: locationManager.location!.coordinate)
        let destinationPlacemark = MKPlacemark(coordinate: destination)
        
        //req a direction
        let directionReq = MKDirections.Request()
        
        
        //define source and dest
        directionReq.source = MKMapItem(placemark: sourcePlaceMark)
        directionReq.destination = MKMapItem(placemark: destinationPlacemark)
        
        directionReq.transportType = .walking
        
        let direction = MKDirections(request: directionReq)
        direction.calculate { (response, error) in
            guard let directionResponse = response else {
                return
            }
            //create route
            let route = directionResponse.routes[0]
            
            //draw polyline
            
           
            self.mapView.addOverlay(route.polyline, level: .aboveRoads)
            
            //define the bounding map rect
            let rect = route.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
            
            self.mapView.setVisibleMapRect(rect, animated: true)
            self.mapView.setVisibleMapRect(rect, edgePadding: UIEdgeInsets(top: 100, left: 100, bottom: 100, right: 100), animated: true)
            
        }
        
        
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
    
    
    
    
    @IBAction func stepperMode(_ sender: Any)
    {
        
        var newvalue = stepperZoom.value
        
        if(newvalue > self.originalvalue){

            self.originalvalue = stepperZoom.value

            zoomIn()
            
        }else {

            self.originalvalue = stepperZoom.value

        zoomOut()
            
        }
        
    }
    
    
    
    @IBAction func automobileBtn1(_ sender: Any)
    {
        mapView.removeOverlays(mapView.overlays)
        
        let sourcePlacemark = MKPlacemark(coordinate: locationManager.location!.coordinate)
        let destinationPlacemark = MKPlacemark(coordinate: destination)
        
        //req a direction
        let directionReq = MKDirections.Request()
        
        
        //define source and dest
        directionReq.source = MKMapItem(placemark: sourcePlacemark)
        directionReq.destination = MKMapItem(placemark: destinationPlacemark)
        
        directionReq.transportType = .automobile
        
        let direction = MKDirections(request: directionReq)
        direction.calculate { (response, error) in
            guard let directionResponse = response else {
                return
            }
            //create route
            let route = directionResponse.routes[0]
            
            //draw polyline
            
           
            self.mapView.addOverlay(route.polyline, level: .aboveRoads)
            
            //define the bounding map rect
            let rect = route.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
            
            self.mapView.setVisibleMapRect(rect, animated: true)
            self.mapView.setVisibleMapRect(rect, edgePadding: UIEdgeInsets(top: 100, left: 100, bottom: 100, right: 100), animated: true)
            
        }
        
        
    }
    
    
    
    
}




extension ViewController : MKMapViewDelegate{
    
    
    
    
    
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
             let alertController = UIAlertController(title: "Your Place", message: "Welcome", preferredStyle: .alert)
             let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
             alertController.addAction(cancelAction)
             present(alertController, animated: true, completion: nil)
         }
     
     //MARK:- render for overlay
     func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKCircle {
            let rendrer = MKCircleRenderer(overlay: overlay)
            rendrer.fillColor = UIColor.black.withAlphaComponent(0.5)
            rendrer.strokeColor = UIColor.red
            rendrer.lineWidth = 2
            return rendrer
        }else if overlay is MKPolyline{
             let renderer = MKPolylineRenderer(overlay: overlay)
             renderer.strokeColor = UIColor.red
             renderer.lineWidth = 4
             return renderer
         }else if overlay is MKPolygon{
             let renderer = MKPolygonRenderer(overlay: overlay)
             renderer.fillColor = UIColor.orange.withAlphaComponent(0.6)
             renderer.strokeColor = UIColor.red
             renderer.lineWidth = 2
             return renderer
         }
        return MKOverlayRenderer()
    
         }
         
}


