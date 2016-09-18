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

protocol VenuesViewControllerDelegate {
    func venueSelected(venue: String)
}

class VenuesViewController: UITableViewController {
    
    var venues = [Venue]()

    var delegate: VenuesViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = "https://api.foursquare.com/v2/venues/search?ll=40.7,-74&client_id=HYIJPMWKUCHP0OAD4QG2R21XJLLVTWIHASBJGPQ2M342IFAM&client_secret=04MUOTIS5QVIN2YJZL55LGN4FXRRZTL1XXGWFZGBUBMZ4JOK&v=20160914"
        
        Alamofire.request(.GET, url).responseJSON { response in
            if let value = response.result.value {
                let json = JSON(value)
                let jsonArray = json["response"]["venues"].array!
            
                var venues = [Venue]()
                for obj in jsonArray {
                    let name = obj["name"].string!
                    let distance = obj["location"]["distance"].int!
                    let latitude = obj["location"]["lat"].double!
                    let longitude = obj["location"]["lng"].double!
                    
                    let venue = Venue(name: name, latitude: latitude, longitude: longitude, distance: distance)
                    venues.append(venue)
                }
                
                self.venues = venues
                self.tableView.reloadData()
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

        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let venue = venues[indexPath.row]
        delegate?.venueSelected(venue.name)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }


}
