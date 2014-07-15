//
//  PatientViewController.swift
//  MediForm
//
//  Created by Jordan Rose on 7/15/14.
//  Copyright (c) 2014 Kemtah. All rights reserved.
//

import UIKit

class PatientViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var cdh: CoreDataHelper {
    if !_cdh {
        
        _cdh = CoreDataHelper()
        }
        return _cdh!
    }
    var _cdh: CoreDataHelper? = nil
    
    @IBOutlet var firstNameText : UITextField
    @IBOutlet var lastNameText : UITextField
    @IBOutlet var addressText : UITextField
    @IBOutlet var cityText : UITextField
    @IBOutlet var stateText : UITextField
    @IBOutlet var zipText : UITextField
    
    @IBAction func save(sender : AnyObject) {
        var error: NSError? = nil
        var newPatient: Patient = NSEntityDescription.insertNewObjectForEntityForName("Patient", inManagedObjectContext: self.cdh.managedObjectContext) as Patient
            newPatient.firstName = firstNameText.text
            newPatient.lastName = lastNameText.text
            newPatient.address = addressText.text
            newPatient.city = cityText.text
            newPatient.zipCode = zipText.text.toInt()
        
        if newPatient.managedObjectContext.save(&error){
            println("SAVED")
            self.dismissViewControllerAnimated(true, completion: nil)
            return
        }
        
        println("Error saving context: \(error?.localizedDescription)\n\(error?.userInfo)")
        abort()
    }
}