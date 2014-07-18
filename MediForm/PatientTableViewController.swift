//
//  ViewController.swift
//  MediForm
//
//  Created by Jordan Rose on 7/15/14.
//  Copyright (c) 2014 Kemtah. All rights reserved.
//

import UIKit

class PatientTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    init(coder aDecoder: NSCoder!)
    {
        super.init(coder: aDecoder)
    }
    @IBOutlet var patientTableView : UITableView
    
    init(style: UITableViewStyle) {
        super.init(style: style)
        // Custom initialization
    }
    
    var patients: Patient[] = []
    
    var cdh: CoreDataHelper {
    if !_cdh {
        
        _cdh = CoreDataHelper()
        }
        return _cdh!
    }
    var _cdh: CoreDataHelper? = nil
    
    var fetchedResultController: NSFetchedResultsController = NSFetchedResultsController()
    
    func getFetchedResultController() -> NSFetchedResultsController {
        fetchedResultController = NSFetchedResultsController(fetchRequest: patientFetchRequest(), managedObjectContext: self.cdh.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultController
    }
    
    func patientFetchRequest() -> NSFetchRequest {
        let fetchRequest = NSFetchRequest(entityName: "Patient")
        let sortDescriptor = NSSortDescriptor(key: "lastName", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        return fetchRequest
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // #pragma mark - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView?) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return fetchedResultController.sections.count
    }
    
    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return fetchedResultController.sections[section].numberOfObjects
    }
    
    override func viewWillAppear(animated: Bool) {
        //fetch families
        println(" ======== Fetch ======== ")
        
        fetchedResultController = getFetchedResultController()
        fetchedResultController.delegate = self
        fetchedResultController.performFetch(nil)
        
        tableView.reloadData()
    }
    
    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell? {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("PatientListCell", forIndexPath: indexPath) as UITableViewCell
        let patient = fetchedResultController.objectAtIndexPath(indexPath) as Patient
        cell.text = patient.firstName + " " + patient.lastName
        return cell

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        if segue.identifier == "PatientSelect"{
            let indexPath = sender as NSIndexPath
            let patient: Patient = fetchedResultController.objectAtIndexPath(indexPath) as Patient
            
            let vc = segue.destinationViewController as PatientViewController
            vc.patient = patient
        }
    }
    
    override func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        let managedObject:NSManagedObject = fetchedResultController.objectAtIndexPath(indexPath) as NSManagedObject
        self.performSegueWithIdentifier("PatientSelect", sender: indexPath)
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController!) {
        tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView!, canEditRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            let managedObject:NSManagedObject = fetchedResultController.objectAtIndexPath(indexPath) as NSManagedObject
            let managedObjectContext:NSManagedObjectContext = cdh.managedObjectContext
            managedObjectContext.deleteObject(managedObject)
            managedObjectContext.save(nil)
        }
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView?, canEditRowAtIndexPath indexPath: NSIndexPath?) -> Bool {
    // Return NO if you do not want the specified item to be editable.
    return true
    }
    */
    
    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView?, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath?) {
    if editingStyle == .Delete {
    // Delete the row from the data source
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    }
    */
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView?, moveRowAtIndexPath fromIndexPath: NSIndexPath?, toIndexPath: NSIndexPath?) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView?, canMoveRowAtIndexPath indexPath: NSIndexPath?) -> Bool {
    // Return NO if you do not want the item to be re-orderable.
    return true
    }
    */
    
    /*
    // #pragma mark - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    }
    */


}

