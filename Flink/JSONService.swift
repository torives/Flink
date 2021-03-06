//
//  JSONService.swift
//  Flink
//
//  Created by Victor Yves Crispim on 07/5/15.
//  Copyright (c) 2015 Flink. All rights reserved.
//

import Foundation

/**
 *
 *  Use this class to create JSON strings from objects 
 *  and to create objects from JSON strings
 *
*/
public class JSONService {
    
    /**
     *
     *  Creates a JSON string from an Array of HealthData objects
     *
     *  :param: healhtDataArray an array of HealthData objects
     *
     *  :returns: a string in the JSON format
     *
    */
    class func stringfyHealthDataArray(healthDataArray: [HealthData]) -> String
    {
        var jsonObject: [AnyObject] = []
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.MediumStyle
        
        for data in healthDataArray {
            let dataDictionary:AnyObject =  [   "name" : data.name,
                                                "unit" : data.unit,
                                                "value" : NSString(format: "%.5f", data.value),
                                                "startDate": dateFormatter.stringFromDate(data.startDate),
                                                "endDate": dateFormatter.stringFromDate(data.endDate)
                                            ]
            
            jsonObject.append(dataDictionary)
        }
        
        let jsonString = JSONStringify(jsonObject)
        return jsonString
    }
    
    /**
     *
     *  Creates an Array of HealthData objects from a JSON string
     *
     *  :param: jsonString a string in the JSON format
     *
     *  :returns: an array of HealthData objects
     *
    */
    class func convertStringToHealthDataArray(jsonString: String) -> [HealthData]
    {
        var healthDataArray = [HealthData]()
        
        let array = JSONParseArray(jsonString)
        for data:AnyObject in array
        {
            let name = data["name"] as! String
            let unit = data["unit"] as! String
            let value = (data["value"] as! NSString).doubleValue
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
            dateFormatter.timeStyle = NSDateFormatterStyle.MediumStyle
            
            let startDate = dateFormatter.dateFromString(data["startDate"] as! String)!
            let endDate = dateFormatter.dateFromString(data["endDate"] as! String)!
            
            let healthData = HealthData(name: name, value: value, unit: unit, startDate: startDate, endDate: endDate)
            
            healthDataArray.append(healthData)
        }
        return healthDataArray
    }
    
    /**
     *
     *  Creates a JSON formatted string from any compatible object.
     *
     *  :param: value           the object which will be converted to a JSON string.
     *                          It has to be a compatible JSON object
     *
     *  :param: prettyPrinted   a boolean indicating if the JSON string should be
     *                          formatted for printing. The default is false
     *
     *  :returns:   a string in the JSON format or the empty string if
     *              the value received is not a valid JSON object
    */
    private class func JSONStringify(value: AnyObject, prettyPrinted: Bool = false) -> String
    {
        var options = prettyPrinted ? NSJSONWritingOptions.PrettyPrinted : nil
        
        if NSJSONSerialization.isValidJSONObject(value)
        {
            if let data = NSJSONSerialization.dataWithJSONObject(value, options: options, error: nil)
            {
                if let string = NSString(data: data, encoding: NSUTF8StringEncoding)
                {
                    return string as String
                }
            }
        }
        return ""
    }
    
    /**
     *  Creates a generic array from a JSON string
     *
     *  :param: jsonString the string which will be parsed to create the array
     *
     *  :returns: an AnyObject array
    */
    private class func JSONParseArray(jsonString: String) -> [AnyObject]
    {
        if let data = jsonString.dataUsingEncoding(NSUTF8StringEncoding)
        {
            if let array = NSJSONSerialization.JSONObjectWithData(  data, options: NSJSONReadingOptions(0),
                                                                    error: nil)  as? [AnyObject]
            {
                return array
            }
        }
        return [AnyObject]()
    }
}