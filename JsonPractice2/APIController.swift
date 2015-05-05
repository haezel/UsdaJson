//
//  APIController.swift
//  JsonPractice2
//
//  Created by Kathryn Manning on 5/5/15.
//  Copyright (c) 2015 kathrynmanning. All rights reserved.
//

import Foundation

protocol APIControllerProtocol {
    func didReceiveAPIResults(resuts: NSArray)
}

class APIController {
    
    var delegate: APIControllerProtocol?

    func searchUsdaFor(searchTerm: String)
    {
        // The iTunes API wants multiple terms separated by + symbols, so replace spaces with + signs
        let searchTerm = searchTerm.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil)
        
        let accessKey = "BRkMyiC3plPdNtemuDzi5dERdA4HPBNe1E9SGMdA"
        
        
        // Now escape anything else that isn't URL-friendly
        if let escapedSearchTerm = searchTerm.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding) {
            let urlPath = "http://api.nal.usda.gov/usda/ndb/search/?format=json&q=\(escapedSearchTerm)&sort=n&offset=0&api_key=\(accessKey)"
            let url = NSURL(string: urlPath)
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithURL(url!, completionHandler: {data, response, error -> Void in
                println("Task completed")
                if(error != nil) {
                    // If there is an error in the web request, print it to the console
                    println(error.localizedDescription)
                }
                var err: NSError?
                if let jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as? NSDictionary {
                    if(err != nil) {
                        // If there is an error parsing JSON, print it to the console
                        println("JSON Error \(err!.localizedDescription)")
                    }else{
                        println(jsonResult)
                    }
                    if let results: NSDictionary = jsonResult["list"] as? NSDictionary {
                        
                        if let items: NSArray = results["item"] as? NSArray{
                            //println(items)
                            
                            self.delegate?.didReceiveAPIResults(items)
                        }
                        
                        
                    }
                }
            })
            
            // The task is just an object with all these properties set
            // In order to actually make the web request, we need to "resume"
            task.resume()
        }
    }
    
}