//
//  ViewController.swift
//  radardobem
//
//  Created by Caio Colares on 24/06/17.
//  Copyright © 2017 Caio Colares. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import Alamofire

class ViewController: UIViewController, CLLocationManagerDelegate {

    let locationManager = CLLocationManager()
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    let url : String = "https://www.radardobem.com.br/mapa/load.php";
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager.requestAlwaysAuthorization()
        
        
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            self.locationManager.startUpdatingLocation()
            
            if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
                CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
                let lat = self.locationManager.location?.coordinate.latitude
                let lng = self.locationManager.location?.coordinate.longitude
                setMapCenter(latitude : lat!, longitude : lng!)
            }else{
                setMapCenter(latitude : 0, longitude : 0)
            }
            
        }
        
        let parameters = ["lng":-38.52562,"lat":-3.76999]
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default).responseJSON{response in
            print(response.request as Any)  // original URL request
            print(response.response as Any) // HTTP URL response
            print(response.data as Any)     // server data
            print(response.result)   // result of response serialization
            
            
            
            if let JSON = response.result.value {
                print(JSON);
                
                let array : [Any] = JSON as! [Any]
                
                for json in array{
                
                    let data = json as! Dictionary<String, AnyObject>
                    let latstr = data["nr_lat"] as! String
                    let lngstr = data["nr_lng"] as! String
                    
                    let lat = Double(latstr)
                    let lng = Double(lngstr)
                    
                    self.loadMap(latitude: lat!, longitude: lng!)
                }
                
            }
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func setMapCenter( latitude : Double, longitude :Double){
        let location = CLLocation(latitude:latitude, longitude: longitude)
        let regionRadius: CLLocationDistance = 1000
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func loadMap(latitude:Double,longitude:Double){
        
        let location = CLLocation(latitude:latitude, longitude: longitude)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location.coordinate
        mapView.addAnnotation(annotation)
    }

}

