//
//  LTHealthKitManager.swift
//  LifeTracker
//
//  Created by Sergey Spivakov on 3/20/17.
//  Copyright © 2017 Sergey Spivakov. All rights reserved.
//

import Foundation
import HealthKit

class HealthKitManager: NSObject {
    
    static let healthKitStore = HKHealthStore()
    
    static func authorizeHealthKit() {
        
        let healthKitTypes: Set = [
            HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!,
            HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceWalkingRunning)!
        ]
        
        healthKitStore.requestAuthorization(toShare: healthKitTypes,
                                            read: healthKitTypes) { _, _ in }
    }
    
    static func getHeartRateData(completionBlock: @escaping ([HKSample]?) -> Void) -> Void{
        let type: HKQuantityType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!
        
        let q: HKObserverQuery = HKObserverQuery(sampleType: type, predicate: nil) { (query: HKObserverQuery, completionHandler:HKObserverQueryCompletionHandler, error: Error?) in
            if error != nil {
                print("Failed to set up observer query")
            }
            let timeSortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate , ascending: true)
            
            var lastSample:Date? = UserDefaults.standard.object(forKey: "lastTsUploaded") as? Date

            if lastSample != nil {
                lastSample = Date(timeIntervalSinceNow: -24 * 60 * 60)
            }
            let lowerBound = lastSample?.addingTimeInterval(1)
            
            let pred: NSPredicate = HKQuery.predicateForSamples(withStart: lowerBound, end: nil, options: .strictStartDate)
            
            let sampleQuery = HKSampleQuery(sampleType: type, predicate: pred, limit: 10, sortDescriptors: [timeSortDescriptor], resultsHandler: { (query, results, error) in
                if results == nil {
                    print("An error occured fetching the user's heart rate. In your app, try to handle this gracefully. The error was: \(String(describing: error))")
                }
                completionBlock(results)
            })
            
            HealthKitManager.healthKitStore.execute(sampleQuery)
            
        }
        HealthKitManager.healthKitStore.execute(q)
        HealthKitManager.healthKitStore.enableBackgroundDelivery(for: type, frequency: .immediate) { (success, error) in
            if !success {
                print("Failed to enable background delivery")
            }
        }
    }
}
