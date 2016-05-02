//
//  StoryEntity.swift
//  DHMap
//
//  Created by Dareen Hsu on 4/12/16.
//  Copyright © 2016 D.H. All rights reserved.
//

import Foundation
import CoreData

@objc(StoryEntity)
class StoryEntity: NSManagedObject {

    //MARK: - Test Methods
    static func createTestData() {
        for index in 31...40 {
            StoryEntity.addStory("我的台北商店\(index)", address: "台北市獅形南港路三段16巷18弄\(index)號", type: 1, telephone: "02-23895858#16\(index)", country: "台灣", city: "台北市")
        }
    }

    //MARK: - Predicate
    static func appendPredicate(pre : NSPredicate?, address : String?) -> NSPredicate? {
        if (address != nil) {
            let p : NSPredicate = NSPredicate.init(format: "address == %@", address!)
            if (pre != nil) {
                return NSCompoundPredicate.init(andPredicateWithSubpredicates: [p, pre!])
            }else {
                return p
            }
        }else {
            return (pre != nil) ? pre : NSPredicate.init(value: true)
        }
    }

    static func appendPredicate(pre : NSPredicate?, city : String?) -> NSPredicate? {
        if (city != nil) {
            let p : NSPredicate = NSPredicate.init(format: "city == %@", city!)
            if (pre != nil) {
                return NSCompoundPredicate.init(andPredicateWithSubpredicates: [p, pre!])
            }else {
                return p
            }
        }else {
            return (pre != nil) ? pre : NSPredicate.init(value: true)
        }
    }

    //MARK: - Helper: Add Methods
    static func addStory(name : String?, address : String?, type : NSNumber?, telephone : String?, country : String?, city : String?) {
        MagicalRecord.saveWithBlockAndWait { (context : NSManagedObjectContext!) -> Void in
            print("<DB> \(NSStringFromSelector(#function)) start")

            addStory(name, address: address, type: type, telephone: telephone, country: country, city: city, context: context)

            print("<DB> \(NSStringFromSelector(#function)) end")
        }
    }

    static func addStory(name : String?, address : String?, type : NSNumber?, telephone : String?, country : String?, city : String?, context : NSManagedObjectContext!) {
        let pre : NSPredicate = appendPredicate(nil, address: address)!
        var entity : StoryEntity? = StoryEntity.MR_findFirstWithPredicate(pre, inContext: context)
        if entity == nil {
            entity = StoryEntity.MR_createEntityInContext(context)
            entity?.address = address
        }

        entity?.name = name
        entity?.type = type
        entity?.telephone = telephone
        entity?.country = country
        entity?.city = city
    }

    //MARK: - Helper: Find Methods
    static func findAllStory() -> [StoryEntity] {
        print("<DB> \(NSStringFromSelector(#function)) start")

        let context : NSManagedObjectContext! = NSManagedObjectContext.MR_defaultContext()

        let entities : [StoryEntity]! = StoryEntity.MR_findAllSortedBy("address", ascending: true, inContext: context!) as! [StoryEntity]!

        print("<DB> \(NSStringFromSelector(#function)) end")

        return entities
    }

    static func findAllStory(city : String?) -> [StoryEntity] {
        print("<DB> \(NSStringFromSelector(#function)) start")

        let context : NSManagedObjectContext! = NSManagedObjectContext.MR_defaultContext()

        let pre : NSPredicate = appendPredicate(nil, city: city)!

        let entities : [StoryEntity]! = StoryEntity.MR_findAllSortedBy("address", ascending: true, withPredicate: pre, inContext: context) as! [StoryEntity]

        print("<DB> \(NSStringFromSelector(#function)) end")

        return entities
    }

    static func findAllGroupByCity() -> [NSDictionary]  {
        print("<DB> \(NSStringFromSelector(#function)) start")

        let context : NSManagedObjectContext! = NSManagedObjectContext.MR_defaultContext()
        let result : [NSDictionary]! = StoryEntity.MR_findAllGroupBy("city" , inContext: context) as! [NSDictionary]

        print("<DB> \(NSStringFromSelector(#function)) end")
        
        return result
    }

    static func searchMatchAddress(city : String!, address : String!) -> NSMutableArray {
        print("<DB> \(NSStringFromSelector(#function)) start")

        let result : NSMutableArray = NSMutableArray()
        let source : [StoryEntity]! = StoryEntity.findAllStory(city)

        for i in 0 ... address.characters.count - 1 {
            let str = (address! as NSString).substringToIndex(address.characters.count - i)
            for story in source {
                if story.address == address {
                    continue
                }

                do {
                    let regex = try NSRegularExpression(pattern: str, options: NSRegularExpressionOptions.CaseInsensitive)
                    let matches = regex.matchesInString(story.address!, options: [], range: NSMakeRange(0, (story.address! as NSString).length))

                    if matches.count > 0 {
                        let fullLength : CGFloat = CGFloat((story.address! as NSString).length)
                        let strLength : CGFloat = CGFloat(str.characters.count)
                        let p = strLength / fullLength * 100

                        if  p > 50 {
                            if !result.containsObject(story) {
                                result.addObject(story)
                            }
                        }else {
                            break
                        }
                    }
                } catch {}
            }
        }

        print("<DB> \(NSStringFromSelector(#function)) end")
        
        return result
    }
}
