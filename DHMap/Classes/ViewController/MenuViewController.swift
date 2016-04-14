//
//  MenuViewController.swift
//  DHMap
//
//  Created by Dareen Hsu on 4/8/16.
//  Copyright © 2016 D.H. All rights reserved.
//

import UIKit

class MenuTableViewCell : UITableViewCell {
    @IBOutlet weak var nameLabel : UILabel?
}

class MenuViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var menuTableView : UITableView?

    var cities : [NSDictionary]! = []
    var storyDict : NSMutableDictionary! = NSMutableDictionary()

    override func viewDidLoad() {
        super.viewDidLoad()

        setDefaultValue()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setDefaultValue() {
        cities = StoryEntity.findAllGroupByCity()
        for city : NSDictionary in cities {
            let name : String = city.objectForKey("city") as! String
            let array : [StoryEntity]! = StoryEntity.findAllStory(name)
            storyDict.setObject(array, forKey: name)
        }
    }

    // MARK: - UITableViewDataSource Methos
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return cities.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let cityDict : NSDictionary! = cities[section]
        let name : String! = cityDict.objectForKey("city") as! String
        let array : [StoryEntity]! = storyDict.objectForKey(name) as! [StoryEntity]

        return array.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : MenuTableViewCell = tableView.dequeueReusableCellWithIdentifier("tableCell") as! MenuTableViewCell

        let cityDict : NSDictionary! = cities[indexPath.section] 
        let name : String! = cityDict.objectForKey("city") as! String
        let array : [StoryEntity]! = storyDict.objectForKey(name) as! [StoryEntity]
        let story : StoryEntity! = array[indexPath.row]

        cell.nameLabel!.text = story.name

        return cell
    }

    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let city : NSDictionary! = cities![section]
        let header : String! = "\(city.objectForKey("city")!) \(city.objectForKey("count")!)"

        return header
    }

    // MARK: - UITableDelegate Methods
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        var controller : BaseViewController?
//        switch indexPath.row {
//        case 0:
//            controller = self.storyboard!.instantiateViewControllerWithIdentifier("PageViewController") as! PageViewController
//            break
//        default:
//            controller = self.storyboard!.instantiateViewControllerWithIdentifier("AddViewController") as! AddViewController
//            break
//        }
//
//        SlideNavigationController.sharedInstance()!.popAllAndSwitchToViewController(controller, withSlideOutAnimation: false, andCompletion: nil);
    }
}
