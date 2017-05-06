//
//  ExerciseDataManager.swift
//  LifeTracker
//
//  Created by Sergey Spivakov on 4/7/17.
//  Copyright © 2017 Sergey Spivakov. All rights reserved.
//

import Foundation
import CoreData
import UIKit


class ExerciseDataManager{
    class func addExerciseAsync(name: String, type: String, time: NSNumber, countGoal: NSNumber, completionBlock: @escaping () -> Void){
        guard let appDelegate =
            UIApplication.shared.delegate as? LTAppDelegate else {
                return
        }
        DispatchQueue.global().async {
            let coordinator = appDelegate.storage.context.persistentStoreCoordinator
            let managedContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
            managedContext.persistentStoreCoordinator = coordinator
            managedContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            var exercise: Exercise?
            exercise = NSEntityDescription.insertNewObject(forEntityName: "Exercise", into: managedContext) as? Exercise
            exercise?.count = countGoal.int16Value
            exercise?.name = name
            exercise?.time = time.int64Value
            exercise?.date = NSDate()
            exercise?.type = type
            
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
            completionBlock()
        }
    }
}
