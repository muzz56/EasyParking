//
//  MapParkViewController.swift
//  ParkingApp
//
//  Created by Graphic on 2021-05-23.
//

import UIKit
import MapKit

struct Locations{
    var name : String
    var coordinates : CLLocationCoordinate2D
}

class MapParkViewController: UIViewController, MKMapViewDelegate {
    // Outlets
    @IBOutlet weak var mapParkView: MKMapView!
    
    // Variables
    let locationManager = CLLocationManager()
    var lat : Double = 0.0
    var lng : Double = 0.0
    var address : String = ""
    var currentLat : Double = 0.0
    var currentLng : Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.mapParkView?.delegate = self
       
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            print(#function, "Location access granted")
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            self.locationManager.startUpdatingLocation()
        }else{
            print(#function, "Location access denied")
        }
        print("Lat \(self.lat) Lng \(self.lng)")
    }
    
}

extension MapParkViewController: CLLocationManagerDelegate{
        
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            guard let currentLocation : CLLocationCoordinate2D = manager.location?.coordinate else{
                return
            }
            
            print(#function, "Current Location : lat \(currentLocation.latitude) lng \(currentLocation.longitude)")
            self.lat = currentLocation.latitude
            self.lng = currentLocation.longitude
            self.displayLocationOnMap(location: currentLocation)
        }
        
        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            print(#function, "Unable to get location \(error)")
        }
        
        func displayLocationOnMap(location : CLLocationCoordinate2D){
            let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            let region = MKCoordinateRegion(center: location, span: span)
            
            self.mapParkView?.setRegion(region, animated: true)
            
            //display annotation
            let annotation = MKPointAnnotation()
            annotation.coordinate = location
            annotation.title = "You'r here"
            self.mapParkView?.addAnnotation(annotation)
        }
    
    func showRouteOnMap(pickupCoordinate : CLLocationCoordinate2D, destinationCoordinate : CLLocationCoordinate2D){
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: pickupCoordinate, addressDictionary: nil))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destinationCoordinate, addressDictionary: nil))
        request.requestsAlternateRoutes = true
        request.transportType = .automobile
        
        let directions = MKDirections(request: request)
        directions.calculate(completionHandler: { response, error in
            guard let response = response else {return}
            if let route = response.routes.first{
               // self.]mapParkView?.addOverlay(route.polyline)
               // self.mapParkView?.setVisibleMapRect(route.polyline.boundingMapRect, edgePadding: UIEdgeInsets.init(top: 90, left: 15, bottom: 100, right: 15), animated: true)
            }
        })
    }
}
