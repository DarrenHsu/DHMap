//
//  MapViewController.swift
//  DHMap
//
//  Created by Dareen Hsu on 4/8/16.
//  Copyright © 2016 D.H. All rights reserved.
//

import GoogleMaps
import UIKit

class MapViewController : BaseViewController,CLLocationManagerDelegate {

    @IBOutlet weak var baseView : UIView?

    let clm : CLLocationManager = CLLocationManager()
    var mapView : GMSMapView?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup a fter loading the view, typically from a nib.

        GMSServices.provideAPIKey("AIzaSyBhtVzuRtWDJhEhTgXQ495JsW5D9j-4QXw")

        clm.distanceFilter = 10
        clm.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
        clm.delegate = self
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - CLLocationManagerDelegate Methods
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("location \(locations)")
        var camera : GMSCameraPosition?

        let location : CLLocation! = locations[0]

        if mapView == nil && location != nil {
            camera = GMSCameraPosition.cameraWithLatitude(location!.coordinate.latitude, longitude:location!.coordinate.longitude , zoom:15)
            mapView = GMSMapView.mapWithFrame(baseView!.bounds, camera: camera!)
            mapView!.frame = baseView!.bounds
            mapView!.myLocationEnabled = true

            baseView!.addSubview(mapView!)

            let geocoder : CLGeocoder! = CLGeocoder()
            geocoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
                if error != nil {

                }else {
                    let pm : [CLPlacemark]! = placemarks! as [CLPlacemark]
                    if pm != nil && pm!.count > 0 {
                        let placemark : CLPlacemark! = placemarks![0] as CLPlacemark

                        var address : String = ""
                        var city : String = ""

                        if placemark.subAdministrativeArea != nil {
                            address += placemark.subAdministrativeArea!
                            city = placemark.subAdministrativeArea!
                        }
                        if placemark.locality != nil {
                            address += placemark.locality!
                        }

                        address += placemark.addressDictionary!["Street"] as! String

                        print("address \(address)")

                        let stories : NSMutableArray = StoryEntity.searchMatchAddress(city, address: address)
                        for (index, story) in stories.enumerate() {
                            print("index \(index) address \((story as! StoryEntity).address!)")
                        }
                    }
                }
            })
        }
    }

    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("error \(error)")
    }

    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        print("status \(status)")

        switch status {
        case .Restricted:
            break
        case .Denied:
            break
        case .AuthorizedAlways ,.AuthorizedWhenInUse:
            manager.startUpdatingLocation()
            break
        default:
            manager.requestAlwaysAuthorization()
            break
        }
    }
}