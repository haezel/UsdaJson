//
//  ViewController.swift
//  JsonPractice2
//
//  Created by Kathryn Manning on 4/30/15.
//  Copyright (c) 2015 kathrynmanning. All rights reserved.
//

import UIKit

class SearchResultsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, APIControllerProtocol{
    
    let api = APIController()

    @IBOutlet var appsTableView: UITableView!
    var tableData = []
    let kCellIdentifier: String = "SearchResultCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        api.delegate = self
        api.searchUsdaFor("Cake")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as! UITableViewCell

        
        if let rowData: NSDictionary = self.tableData[indexPath.row] as? NSDictionary,
                                name = rowData["name"] as? String,
                               group = rowData["group"] as? String,
                               ndbno = rowData["ndbno"] as? String,
                              offset = rowData["offset"] as? Int
        {
            cell.detailTextLabel?.text = ndbno
            cell.textLabel?.text = name
        } else {
            println("Row item did not contain all elements.")
        }

      
        return cell
    }
    
    func didReceiveAPIResults(items: NSArray) {
        dispatch_async(dispatch_get_main_queue(), {
            self.tableData = items
            self.appsTableView!.reloadData()
        })
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("clicked: \(indexPath.row)")
        //get the row data for selected row
        if let rowData: NSDictionary = self.tableData[indexPath.row] as? NSDictionary,
                  //get the name of the food item on this row
                  name = rowData["name"] as? String,
                 //get the rdbno of the food item on this row
                 ndbno = rowData["ndbno"] as? String,
                offset = rowData["offset"] as? Int
        {
            let alert = UIAlertController(title: name, message: "db# \(ndbno), offset: \(offset)", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        } else { println("Row data is incorrect.")}
        
        
    }
    
    

}

