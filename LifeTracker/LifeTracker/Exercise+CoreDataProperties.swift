//
//  Exercise+CoreDataProperties.swift
//  LifeTracker
//
//  Created by Sergey Spivakov on 4/7/17.
//  Copyright © 2017 Sergey Spivakov. All rights reserved.
//

import Foundation
import CoreData


extension Exercise {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Exercise> {
        return NSFetchRequest<Exercise>(entityName: "Exercise")
    }

    @NSManaged public var count: Int16
    @NSManaged public var name: String?
    @NSManaged public var date: NSDate?
    @NSManaged public var time: Int64
    @NSManaged public var type: String?

}
