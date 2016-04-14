//
//  DHMapManager.swift
//  DHMap
//
//  Created by Dareen Hsu on 4/14/16.
//  Copyright © 2016 D.H. All rights reserved.
//

import UIKit

class DHMapManager: NSObject {
    static let sharedInstance = DHMapManager()

    var currentCity : String?
    var currentAddress : String?
    var selectedStory : StoryEntity?
}