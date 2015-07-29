//
//  HealthDAO.swift
//  Flink
//
//  Created by Joao Pedro Brandao on 7/26/15.
//  Copyright (c) 2015 Flink. All rights reserved.
//

import Foundation
import HealthKit

/// Abstract class
class HealthDAO
{
    
    static private let healthKitStore:HKHealthStore = HKHealthStore()
    
    static let healthQuantityTypeIdentifiers = [
        HKQuantityTypeIdentifierBodyFatPercentage       ,
        HKQuantityTypeIdentifierLeanBodyMass            ,
        HKQuantityTypeIdentifierBodyMass                ,
        HKQuantityTypeIdentifierHeight                  ,
        HKQuantityTypeIdentifierHeartRate               ,
        HKQuantityTypeIdentifierActiveEnergyBurned      ,
        HKQuantityTypeIdentifierDistanceCycling         ,
        HKQuantityTypeIdentifierFlightsClimbed          ,
        HKQuantityTypeIdentifierStepCount               ,
        HKQuantityTypeIdentifierDistanceWalkingRunning   ]

    
    
    /* **************************************************************************************************
    **
    **  MARK: Class methods
    **
    ****************************************************************************************************/
    
    class func labelName(identifier:String) -> String
    {
        switch( identifier )
        {
            case HKQuantityTypeIdentifierBodyFatPercentage:
                return "Body Fat Percentage"
                
            case HKQuantityTypeIdentifierLeanBodyMass:
                return "Lean Body Mass"
                
            case HKQuantityTypeIdentifierBodyMass:
                return "Body Mass"
                
            case HKQuantityTypeIdentifierHeight:
                return "Height"
                
            case HKQuantityTypeIdentifierHeartRate:
                return "Heart Rate"
                
            case HKQuantityTypeIdentifierActiveEnergyBurned:
                return "Calories Burned"
                
            case HKQuantityTypeIdentifierDistanceCycling:
                return "Distance Cycled"
                
            case HKQuantityTypeIdentifierFlightsClimbed:
                return "Flights Climbed"
                
            case HKQuantityTypeIdentifierStepCount:
                return "Steps Taken"
                
            case HKQuantityTypeIdentifierDistanceWalkingRunning:
                return "Distance Walked/Ran"
                
            default:
                return ""
        }

    }
    
    class func getDataOfCategory(identifier:String) -> [HealthData]
    {
        var identHData:[HealthData] = []
        
        for data in Facade.instance.hData
        {
            if data.name == labelName(identifier)
            {
                identHData += [data]
            }
        }
        
        return identHData
    }
 
    
    class func authorizeHealthKit (completion: ((success:Bool, error:NSError!) -> Void)!)
    {
        // 1. Set the types you want to read from HK Store
        var healthKitTypesToRead: Set<HKObjectType> = [
            HKObjectType.characteristicTypeForIdentifier(HKCharacteristicTypeIdentifierDateOfBirth)       ,
            HKObjectType.characteristicTypeForIdentifier(HKCharacteristicTypeIdentifierBiologicalSex)
            ]
        
        for quants in healthQuantityTypeIdentifiers
        {
            healthKitTypesToRead.insert(HKObjectType.quantityTypeForIdentifier(quants))
        }
        
        // 2. Set the types you want to write to HK Store
        let healthKitTypesToWrite = NSSet(array: []) as Set
        
        // 3. If the store is not available (for instance, iPad) return an error and don't go on.
        if !HKHealthStore.isHealthDataAvailable()
        {
            let error = NSError(domain: "com.raywenderlich.tutorials.healthkit", code: 2, userInfo: [NSLocalizedDescriptionKey:"HealthKit is not available in this Device"])
            if( completion != nil )
            {
                completion(success:false, error:error)
            }
            return;
        }
        
        // 4.  Request HealthKit authorization
        healthKitStore.requestAuthorizationToShareTypes(nil, readTypes: healthKitTypesToRead, completion: completion)
    }
    
    
    class func getProfile() -> (age:Int?, biologicalSex:HKBiologicalSexObject?)
    {
        var error:NSError?
        var age:Int?
        
        // 1. Request birthday and calculate age
        if let birthDay = healthKitStore.dateOfBirthWithError(&error)
        {
            let today = NSDate()
            let calendar = NSCalendar.currentCalendar()
            let differenceComponents = NSCalendar.currentCalendar().components(.CalendarUnitYear, fromDate: birthDay, toDate: today, options: NSCalendarOptions(0) )
            age = differenceComponents.year
        }
        if error != nil {
            println("Error reading Birthday: \(error)")
        }
        
        // 2. Read biological sex
        var biologicalSex:HKBiologicalSexObject? = healthKitStore.biologicalSexWithError(&error);
        if error != nil {
            println("Error reading Biological Sex: \(error)")
        }
        
        // 4. Return the information read in a tuple
        return (age, biologicalSex)
    }
    
    
    
    
    //+ getHealthData(data : HealthData) : HealthData[]
    class func getHealthData (sampleType:HKSampleType, startDate:NSDate, endDate:NSDate, completion: (([HKSample]!, NSError!) -> Void)!)
    {
        // 1. Build the Predicate
        let predicate = HKQuery.predicateForSamplesWithStartDate(startDate, endDate:endDate, options: .None)
        
        // 2. Build the sort descriptor to return the samples in descending order
        let sortDescriptor = NSSortDescriptor(key:HKSampleSortIdentifierStartDate, ascending: true)
        // 3. we want to limit the number of samples returned by the query to just 1 (the most recent)
        let limit = Int(HKObjectQueryNoLimit)
        
        // 4. Build samples query
        let sampleQuery = HKSampleQuery(sampleType: sampleType, predicate: predicate, limit: limit, sortDescriptors: [sortDescriptor])
            { (sampleQuery, results, error ) -> Void in
                
                if let queryError = error
                {
                    completion(nil,error)
                    return;
                }
                
                // Get the first sample
                let mostRecentSample = results as? [HKQuantitySample]
                
                // Execute the completion closure
                if completion != nil
                {
                    completion(mostRecentSample,nil)
                }
        }
        
        // 5. Execute the Query
        self.healthKitStore.executeQuery(sampleQuery)
    
    }
    
    class func loadHealthData(startDate:NSDate, endDate:NSDate)
    {
        var sampleType:HKSampleType
        // make call back functions for
        
        
        for quant in healthQuantityTypeIdentifiers
        {
            sampleType = HKSampleType.quantityTypeForIdentifier(quant)
            getHealthData(sampleType, startDate: startDate, endDate: endDate)
            { (values, error) -> Void in
                    
                if error != nil
                {
                    println("Error reading \(quant) from HealthKit Store: \(error.localizedDescription)")
                }
                
                for val in values
                {
                    if let weight = val as? HKQuantitySample
                    {
                        var value:Double = -1
                        var unit:String = "NO UNIT"
                        
                        switch quant
                        {
                            case HKQuantityTypeIdentifierBodyFatPercentage:
                                value = weight.quantity.doubleValueForUnit(HKUnit.percentUnit())*100
                                unit = "%"
                                break
                            case HKQuantityTypeIdentifierLeanBodyMass:
                                value = weight.quantity.doubleValueForUnit(.gramUnitWithMetricPrefix(.Kilo))
                                unit = "kg"
                                break
                            case HKQuantityTypeIdentifierBodyMass:
                                value = weight.quantity.doubleValueForUnit(HKUnit.gramUnitWithMetricPrefix(.Kilo))
                                unit = "kg"
                                break
                            case HKQuantityTypeIdentifierHeight:
                                value = weight.quantity.doubleValueForUnit(HKUnit.meterUnitWithMetricPrefix(.Centi))
                                unit = "cm"
                                break
                            case HKQuantityTypeIdentifierHeartRate:
                                let count = HKUnit.countUnit()
                                value = weight.quantity.doubleValueForUnit(count.unitDividedByUnit(HKUnit.secondUnit()))
                                unit = "bpm"
                                break
                            case HKQuantityTypeIdentifierActiveEnergyBurned:
                                value = weight.quantity.doubleValueForUnit(HKUnit.kilocalorieUnit())
                                unit = "kcal"
                                break
                            case HKQuantityTypeIdentifierDistanceCycling:
                                value = weight.quantity.doubleValueForUnit(HKUnit.meterUnitWithMetricPrefix(HKMetricPrefix.Kilo))
                                unit = "km"
                                break
                            case HKQuantityTypeIdentifierFlightsClimbed:
                                value = weight.quantity.doubleValueForUnit(HKUnit.countUnit())
                                unit = "count"
                                break
                            case HKQuantityTypeIdentifierStepCount:
                                value = weight.quantity.doubleValueForUnit(HKUnit.countUnit())
                                unit = "count"
                                break
                            case HKQuantityTypeIdentifierDistanceWalkingRunning:
                                value = weight.quantity.doubleValueForUnit(HKUnit.meterUnitWithMetricPrefix(HKMetricPrefix.Kilo))
                                unit = "km"
                                break
                            default:
                                continue
                        }
                        
                        var hdatum:HealthData = HealthData(name: self.labelName(weight.quantityType.identifier), value: value, unit: unit, startDate: weight.startDate, endDate: weight.endDate)
                        
                        Facade.instance.hData += [hdatum]
                        println("name: \(hdatum.name)\nvalue: \(value)\nunit: \(unit)")
                        println("print hdatum in HealthDAO load func\n\n")
                    }
                }
            }

        }
    }
    
    class func save (user: User)
    {
        // TODO: Salvar em NSUserDefaults
    }
}