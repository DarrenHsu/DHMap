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
    var currentAddress : String! = ""
    var currentCity : String! = ""

    override func viewDidLoad() {
        super.viewDidLoad()

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

    func presentMatchStory() {
        let queue : NSOperationQueue! = NSOperationQueue()
        let markDict : NSMutableDictionary! = NSMutableDictionary()

        let finalCompletionOperation  = NSBlockOperation.init {
            print("finished")
        }

        var previousCompletionHandler : NSOperation? = nil

        print("address \(self.currentAddress)")

        let stories : NSMutableArray = StoryEntity.searchMatchAddress(self.currentCity, address: self.currentAddress)

        for (index, story) in stories.enumerate() {
            let address = (story as! StoryEntity).address!

            print("index \(index) address \(address)")

            let geocodeRequest = NSBlockOperation()
            if previousCompletionHandler != nil {
                geocodeRequest.addDependency(previousCompletionHandler!)
            }

            let geocodeCompletionHandler : NSBlockOperation! = NSBlockOperation()
            finalCompletionOperation.addDependency(geocodeCompletionHandler)

            geocodeRequest.addExecutionBlock({
                var marker : GMSMarker? = markDict.objectForKey(address) as? GMSMarker
                if marker != nil {
                    return
                }

                let geocoder : CLGeocoder! = CLGeocoder()
                geocoder.geocodeAddressString(address, completionHandler: { (placemarks : [CLPlacemark]?, error : NSError?) in
                    if error != nil {
                        return;
                    }

                    let placemark : CLPlacemark? = placemarks![0]

                    let  position = CLLocationCoordinate2DMake((placemark?.location?.coordinate.latitude)!, (placemark?.location?.coordinate.longitude)!)
                    marker = GMSMarker(position: position)
                    marker!.title = (story as! StoryEntity).name
                    marker!.map = self.mapView

                    markDict.setObject(marker!, forKey: address)
                    queue.addOperation(geocodeCompletionHandler)
                })
            })

            queue.addOperation(geocodeRequest);
            previousCompletionHandler = geocodeCompletionHandler;
        }
        queue.addOperation(finalCompletionOperation)
    }

    // MARK: - CLLocationManagerDelegate Methods
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location : CLLocation! = locations[0]

        if mapView != nil && location == nil {
            return;
        }

        let camera : GMSCameraPosition! = GMSCameraPosition.cameraWithLatitude(location!.coordinate.latitude, longitude:location!.coordinate.longitude , zoom:15)
        mapView = GMSMapView.mapWithFrame(baseView!.bounds, camera: camera!)
        mapView!.frame = baseView!.bounds
        mapView!.myLocationEnabled = true

        baseView!.addSubview(mapView!)

        let geocoder : CLGeocoder! = CLGeocoder()
        geocoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
            if error == nil {
                let pm : [CLPlacemark]! = placemarks! as [CLPlacemark]
                if pm != nil && pm!.count > 0 {
                    let placemark : CLPlacemark! = placemarks![0] as CLPlacemark

                    if placemark.subAdministrativeArea != nil {
                        self.currentAddress = self.currentAddress + placemark.subAdministrativeArea!
                        self.currentCity = placemark.subAdministrativeArea!
                    }

                    if placemark.locality != nil {
                        self.currentAddress = self.currentAddress + placemark.locality!
                    }

                    self.currentAddress = self.currentAddress + (placemark.addressDictionary!["Street"] as! String)
                    self.presentMatchStory()
                }
            }
        })
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