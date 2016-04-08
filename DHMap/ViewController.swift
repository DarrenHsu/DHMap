//
//  ViewController.swift
//  DHMap
//
//  Created by Dareen Hsu on 4/8/16.
//  Copyright © 2016 D.H. All rights reserved.
//

import UIKit
import GoogleMaps

class ViewController : UIViewController,CLLocationManagerDelegate {

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