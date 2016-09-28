import UIKit
import MapKit


class MapViewController: UIViewController, MKMapViewDelegate {

    let mapView = MKMapView()
    var entries = [Entry]()
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        entries = Entry.loadEntries()
        addAnnotations()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMapView()
        setupScaleButtons()
        setupMapTypeControl()
    }
    
    func setupMapView() {

        self.view.addSubview(mapView)
        //Размер + положение на экране
        mapView.frame = self.view.bounds
        //shortest way | old-school
        mapView.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
        
        //long way
        //        let constraintLeading = NSLayoutConstraint(item: mapView, attribute: .Leading, relatedBy: .Equal, toItem: self.view, attribute: .Leading, multiplier: 1, constant: 0)
        //        let constraintTrailing = NSLayoutConstraint.constraintsWithVisualFormat(
        //            "[mapView]-(0)-|", options: .AlignAllLastBaseline, metrics: nil, views: ["mapView": mapView])
        
        
        
        mapView.delegate = self
        // Настройки карты
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .Follow
        mapView.showsScale = true
        mapView.showsCompass = true
        mapView.mapType = .Standard
        
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
    
    func tapButtonPlus() {
        
        let zoomLevel: Double = mapView.zoomLevel() + 1
        mapView.setCenterCoordinate(mapView.centerCoordinate, zoomLevel: zoomLevel, animated: true)
    }
    
    func tapButtonMinus() {
        
        let zoomLevel: Double = mapView.zoomLevel() - 1
        mapView.setCenterCoordinate(mapView.centerCoordinate, zoomLevel: zoomLevel, animated: true)
    }
    
    
    func setupScaleButtons() {
        
        let buttonPlus = UIButton(type: .Custom)
        buttonPlus.translatesAutoresizingMaskIntoConstraints = false
      
        buttonPlus.setImage(UIImage(named: "1474761840_add.png"), forState: .Normal)
        buttonPlus.addTarget(self, action: #selector(tapButtonPlus), forControlEvents: .TouchUpInside)
        
        self.view.addSubview(buttonPlus)
        
        //Trailing edge
        // Up center
        NSLayoutConstraint(item: buttonPlus, attribute: .Trailing, relatedBy: .Equal, toItem: view, attribute: .TrailingMargin, multiplier: 1.0, constant: 8.0).active = true
        NSLayoutConstraint(item: buttonPlus, attribute: .CenterY, relatedBy: .Equal, toItem: view, attribute: .CenterY, multiplier: 1.0, constant: -25).active = true
        NSLayoutConstraint(item: buttonPlus, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 35).active = true
        NSLayoutConstraint(item: buttonPlus, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 35).active = true
        
        let buttonMinus = UIButton(type: .Custom)
        buttonMinus.translatesAutoresizingMaskIntoConstraints = false
        
        buttonMinus.setImage(UIImage(named: "1474761917_sub.png"), forState: .Normal)
        buttonMinus.addTarget(self, action: #selector(tapButtonMinus), forControlEvents: .TouchUpInside)
        
        self.view.addSubview(buttonMinus)
        
        //Trailing edge
        NSLayoutConstraint(item: buttonMinus, attribute: .Trailing, relatedBy: .Equal, toItem: view, attribute: .TrailingMargin, multiplier: 1.0, constant: 8).active = true
        NSLayoutConstraint(item: buttonMinus, attribute: .CenterY, relatedBy: .Equal, toItem: view, attribute: .CenterY, multiplier: 1.0, constant: 25).active = true
        NSLayoutConstraint(item: buttonMinus, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 35).active = true
        NSLayoutConstraint(item: buttonMinus, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 35).active = true
    }
    
    func mapTypeCotrolChanged(sender:UISegmentedControl!)
    {
        print("Selected Segment Index: \(sender.selectedSegmentIndex)")
        switch sender.selectedSegmentIndex {
        case 0:
            mapView.mapType = .Standard
        case 1:
            mapView.mapType = .Hybrid
        case 2:
            mapView.mapType = .Satellite
        default:
            return
        }
    }
    
    func setupMapTypeControl() {
        
        let mapTypeCotrol = UISegmentedControl(items: ["Map", "Hybrid", "Sattelite"])
        mapTypeCotrol.tintColor = UIColor.blackColor()
        //mapTypeCotrol.frame = CGRectMake(0, 500, 170, 20)
        mapTypeCotrol.selectedSegmentIndex = 0

        //mapTypeCotrol.translatesAutoresizingMaskIntoConstraints = false
        
        mapTypeCotrol.addTarget(self, action: #selector(mapTypeCotrolChanged), forControlEvents: .ValueChanged)
        
        self.view.addSubview(mapTypeCotrol)

        let c1 = NSLayoutConstraint(item: mapTypeCotrol, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 170)
        let c2 = NSLayoutConstraint(item: mapTypeCotrol, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 20)
        let c3 = NSLayoutConstraint(item: mapTypeCotrol, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1.0, constant: 8)
        let c4 = NSLayoutConstraint(item: mapTypeCotrol, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1.0, constant: 30)
        self.view.addConstraints([c1, c2, c3, c4])

    }

}

