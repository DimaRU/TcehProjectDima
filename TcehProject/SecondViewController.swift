import UIKit
import MapKit

class SecondViewController: UIViewController, MKMapViewDelegate {

    let mapView = MKMapView()
    var entries = [Entry]()
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        entries = Entry.loadEntries()
        addAnnotations()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(mapView)
        //Размер + положение на экране
        mapView.frame = self.view.bounds
        //shortest way | old-school
        mapView.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
    
    
//    let constaintLeading = NSLayoutConstraint(item: mapView, attribute: .Leading, relatedBy: .Equal, toItem: self.view, attribute: .Leading, multiplier: 1, constant: 0)
        
        mapView.delegate = self
        // Настройки карты
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .Follow
        mapView.showsScale = true
        mapView.showsCompass = true
        //mapView.mapType = .Satellite
    }
    

    func addAnnotations()  {
        mapView.removeAnnotations(mapView.annotations)
        
        for entry in entries {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: entry.venue.latitude, longitude: entry.venue.longitude)
            annotation.title = "\(entry.category) for \(entry.amount)р"
            annotation.subtitle = entry.venue.name
                
            mapView.addAnnotation(annotation)
        }
        
        if let entry = entries.first {
            let center = CLLocationCoordinate2D(latitude: entry.venue.latitude, longitude: entry.venue.longitude)
            let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
            let region = MKCoordinateRegion(center: center, span: span)
            mapView.region = region
            
            //mapView.showAnnotations([], animated: <#T##Bool#>)
        }
        
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        var view  = mapView.dequeueReusableAnnotationViewWithIdentifier("entry") as? MKPinAnnotationView
        
        if view == nil {
           view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "entry")
        } else {
            view!.annotation = annotation
        }
        
        view!.canShowCallout = true
        view!.pinTintColor = UIColor.greenColor()
        view!.animatesDrop = true
        
        return view!
        
    }
    
    
}

