//
//  ViewController.swift
//  LastMileHero
//
//  Created by liang on 2/27/16.
//  Copyright © 2016 liang. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, MKMapViewDelegate,CLLocationManagerDelegate, UISearchBarDelegate {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var label4: UILabel!
    @IBOutlet weak var label5: UILabel!
    @IBOutlet weak var label6: UILabel!
    @IBOutlet weak var label7: UILabel!
    @IBOutlet weak var label8: UILabel!
    @IBOutlet weak var label9: UILabel!
    @IBOutlet weak var label10: UILabel!
    @IBOutlet weak var label12: UILabel!
    @IBOutlet weak var emptyLabel: UILabel!
    @IBOutlet weak var label11: UILabel!
    let locationManager = CLLocationManager()
    var locationOrigin = CLLocation()
    var locationDestination = CLLocation()
//    var searchController:UISearchController!
    var annotation:MKAnnotation!
    var localSearchRequest:MKLocalSearchRequest!
    var localSearch:MKLocalSearch!
    var localSearchResponse:MKLocalSearchResponse!
    var error:NSError!
    var pointAnnotation:MKPointAnnotation!
    var pinAnnotationView:MKPinAnnotationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.mapView.showsUserLocation = true
        self.mapView.delegate = self
        self.searchBar.delegate = self
        self.label1.backgroundColor = UIColor.whiteColor()
        self.label2.backgroundColor = UIColor.whiteColor()
        self.label3.backgroundColor = UIColor.whiteColor()
        self.label4.backgroundColor = UIColor.whiteColor()
        self.label5.backgroundColor = UIColor.whiteColor()
        self.label6.backgroundColor = UIColor.whiteColor()
        self.label7.backgroundColor = UIColor.whiteColor()
        self.label8.backgroundColor = UIColor.whiteColor()
        self.label9.backgroundColor = UIColor.whiteColor()
        self.label10.backgroundColor = UIColor.whiteColor()
        self.label11.backgroundColor = UIColor.whiteColor()
        self.label12.backgroundColor = UIColor.whiteColor()
        self.emptyLabel.backgroundColor = UIColor.whiteColor()
        
        self.label1.hidden = true
        self.label2.hidden = true
        self.label3.hidden = true
        self.label4.hidden = true
        self.label5.hidden = true
        self.label6.hidden = true
        self.label7.hidden = true
        self.label8.hidden = true
        self.label9.hidden = true
        self.label10.hidden = true
        self.label11.hidden = true
        self.label12.hidden = true
        self.emptyLabel.hidden = true
    }
    
    
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        renderer.strokeColor = UIColor.blueColor()
        return renderer
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Mark: location delegate methods
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.locationOrigin = locations.last!
        let center = CLLocationCoordinate2D(latitude: self.locationOrigin.coordinate.latitude, longitude: self.locationOrigin.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        self.mapView.setRegion(region, animated: true)
        self.locationManager.stopUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error: " + error.localizedDescription)
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        var overlays = self.mapView.overlays
        mapView.removeOverlays(overlays)
        //1
        searchBar.resignFirstResponder()
        if self.mapView.annotations.count != 0{
            annotation = self.mapView.annotations[0]
            self.mapView.removeAnnotation(annotation)
        }
        //2
        localSearchRequest = MKLocalSearchRequest()
        localSearchRequest.naturalLanguageQuery = searchBar.text
        localSearch = MKLocalSearch(request: localSearchRequest)
        localSearch.startWithCompletionHandler { (localSearchResponse, error) -> Void in
            
            if localSearchResponse == nil{
                let alertController = UIAlertController(title: nil, message: "Place Not Found", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
                return
            }
            //3
            self.pointAnnotation = MKPointAnnotation()
            self.pointAnnotation.title = searchBar.text
            self.pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: localSearchResponse!.boundingRegion.center.latitude, longitude:     localSearchResponse!.boundingRegion.center.longitude)
            
            
            self.pinAnnotationView = MKPinAnnotationView(annotation: self.pointAnnotation, reuseIdentifier: nil)
            self.mapView.addAnnotation(self.pinAnnotationView.annotation!)
            self.locationDestination = CLLocation(latitude: localSearchResponse!.boundingRegion.center.latitude, longitude: localSearchResponse!.boundingRegion.center.longitude)
            print(localSearchResponse!.boundingRegion.center.latitude)
            print(localSearchResponse!.boundingRegion.center.longitude)
            
            
            let request = MKDirectionsRequest()
            request.source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: self.locationOrigin.coordinate.latitude, longitude: self.locationOrigin.coordinate.longitude), addressDictionary: nil))
            request.destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: self.locationDestination.coordinate.latitude, longitude: self.locationDestination.coordinate.longitude), addressDictionary: nil))
            print("O D")
            print(self.locationOrigin.coordinate.latitude)
            print(self.locationOrigin.coordinate.longitude)
            print(self.locationDestination.coordinate.latitude)
            print(self.locationDestination.coordinate.longitude)
            
            request.requestsAlternateRoutes = true
            request.transportType = .Any
            
            let directions = MKDirections(request: request)
            
            directions.calculateDirectionsWithCompletionHandler { [unowned self] response, error in
                guard let unwrappedResponse = response else { return }
                
                for route in unwrappedResponse.routes {
                    self.mapView.addOverlay(route.polyline)
                    self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
                }
            }
            
            request.transportType = .Automobile
            let directionsDriving = MKDirections(request: request)
            directionsDriving.calculateETAWithCompletionHandler { response, error -> Void in
                if let err = error {
                    self.label10.text = err.userInfo["NSLocalizedFailureReason"] as? String
                    return
                }
                
                self.label10.text = "\(Int(response!.expectedTravelTime/60+15)) min"
                self.label6.text = "$\(Int((response!.expectedTravelTime/60+15)/2))"
                
                self.label12.text = "\(Int(response!.expectedTravelTime/60+15)+10) min"
                self.label8.text = "$\(Int((response!.expectedTravelTime/60+15)/2/2))"
            }
            
            
            request.transportType = .Transit
            let directionsTransit = MKDirections(request: request)
                    directionsTransit.calculateETAWithCompletionHandler { response, error -> Void in
                        if let err = error {
                            self.label9.text = err.userInfo["NSLocalizedFailureReason"] as? String
                            return
                        }
            
                        self.label9.text = "\(Int(response!.expectedTravelTime/60)) min"
                        self.label4.text = "$\(Int(response!.expectedTravelTime/60/60))"
                    }
            self.label1.hidden = false
            self.label2.hidden = false
            self.label3.hidden = false
            self.label4.hidden = false
            self.label5.hidden = false
            self.label6.hidden = false
            self.label7.hidden = false
            self.label8.hidden = false
            self.label9.hidden = false
            self.label10.hidden = false
            self.label11.hidden = false
            self.label12.hidden = false
            self.emptyLabel.hidden = false
        }
        
        let urlPath: String = "https://api.uber.com/v1/estimates/price?start_latitude=38.909883&start_longitude=-77.043784&end_latitude=39.000967&end_longitude=-76.889081&server_token=cNlQtoV5SPezK3Ko3cL_4nYiZKnGQI5fnTWFsOBj"
        var url: NSURL = NSURL(string: urlPath)!
        var request1: NSURLRequest = NSURLRequest(URL: url)
        var response: AutoreleasingUnsafeMutablePointer<NSURLResponse? >= nil
        var reponseError: NSError?
        var urlData: NSData?
        do {
            urlData = try NSURLConnection.sendSynchronousRequest(request1, returningResponse:response)
        } catch let error as NSError {
            reponseError = error
            urlData = nil
        }
        print(response)
        
        
//        var err: NSError
//        print(response)
//        var jsonResult: NSDictionary = try NSJSONSerialization.JSONObjectWithData(dataVal, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
//        print("Synchronous \(jsonResult)")
//
//        
    }
//


}

