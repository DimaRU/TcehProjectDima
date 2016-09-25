//
//  VenuesViewController.swift
//  TcehProject
//
//  Created by Dmitriy Borovikov on 04.09.16.
//  Copyright © 2016 Pronin. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreLocation
import SDWebImage

protocol VenuesViewControllerDelegate {
    func venueSelected(venue: Venue)
}

class VenuesViewController: UITableViewController, CLLocationManagerDelegate {
    
    var venues = [Venue]()

    var delegate: VenuesViewControllerDelegate?
    
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
 
        let refreshcontrol = UIRefreshControl()
        refreshcontrol.addTarget(self, action: #selector(self.refreshLocation), forControlEvents: .ValueChanged)
        self.refreshControl = refreshcontrol
    }

    func refreshLocation() {
        locationManager.startUpdatingLocation()
    }
    
    
    func loadNearbyVenue(location:CLLocation) {
        let lat = location.coordinate.latitude
        let lon = location.coordinate.longitude
        
        let params = [
            "ll": "\(lat),\(lon)",
            "client_id": "HYIJPMWKUCHP0OAD4QG2R21XJLLVTWIHASBJGPQ2M342IFAM",
            "client_secret": "04MUOTIS5QVIN2YJZL55LGN4FXRRZTL1XXGWFZGBUBMZ4JOK",
            "v": "20160914"
        ]
        
        Alamofire.request(.GET, "https://api.foursquare.com/v2/venues/search", parameters: params).responseJSON { response in
            if let value = response.result.value {
                let json = JSON(value)
                let jsonArray = json["response"]["venues"].array!
                
                var venues = [Venue]()
                for obj in jsonArray {
                    let name = obj["name"].string!
                    let distance = obj["location"]["distance"].int!
                    let latitude = obj["location"]["lat"].double!
                    let longitude = obj["location"]["lng"].double!
                    
                    var categoryImageURL = "https://ss3.4sqi.net/img/categories_v2/shops/default_bg_64.png"
                    if let venueCategory = obj["categories"].array?.first {
                        categoryImageURL = venueCategory["icon"]["prefix"].string! + "bg_64" + venueCategory["icon"]["suffix"].string!
                    }
                    print(categoryImageURL)
                    
                    let venue = Venue(name: name, latitude: latitude, longitude: longitude, distance: Int64(distance), categoryImageURL: categoryImageURL)
                    venues.append(venue)
                }
                
                venues.sortInPlace({ $0.distance < $1.distance})
                self.venues = venues
                self.tableView.reloadData()
                self.refreshControl!.endRefreshing()
            }
        }
        
    }
    
    
    
    @IBAction func tapCancel(sender: AnyObject) {
        
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
        
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return venues.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("VenueCell") as! VenueCell

        // Configure the cell...
        let venue = venues[indexPath.row] as Venue
        cell.labelVenue.text = venue.name
        cell.labelDistance.text = "\(venue.distance) m."
        cell.imageIcon.sd_setImageWithURL(NSURL(string: venue.categoryImageURL))

        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let venue = venues[indexPath.row]
        delegate?.venueSelected(venue)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        if let location = locations.last {
            loadNearbyVenue(location)
            locationManager.stopUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        switch status {
        case .AuthorizedAlways, .AuthorizedWhenInUse:
            locationManager.startUpdatingLocation()
        case .NotDetermined:
            locationManager.requestWhenInUseAuthorization()
        default:
            print("We are very dissapointed")
            // present dialog 'please enable location access'
        }
    }

}
