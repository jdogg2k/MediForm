//
//  PatientViewController.swift
//  MediForm
//
//  Created by Jordan Rose on 7/15/14.
//  Copyright (c) 2014 Kemtah. All rights reserved.
//

import UIKit

class PatientViewController: UIViewController, UITextFieldDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        firstNameText.delegate = self
        lastNameText.delegate = self
        addressText.delegate = self
        cityText.delegate = self
        stateText.delegate = self
        zipText.delegate = self
        
        if patient != nil {
            firstNameText.text = patient!.firstName
            lastNameText.text = patient!.lastName
            addressText.text = patient!.address
            cityText.text = patient!.city
            stateText.text = patient!.state
            zipText.text = patient!.zipCode.stringValue
        }
        
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
    
    var patient : Patient? = nil
    var validFirst : Bool = false
    var validLast : Bool = false
    var validAddress : Bool = false
    var validCity : Bool = false
    var validState : Bool = false
    var validZip : Bool = false
    
    @IBOutlet var firstNameText : UITextField
    @IBOutlet var lastNameText : UITextField
    @IBOutlet var addressText : UITextField
    @IBOutlet var cityText : UITextField
    @IBOutlet var stateText : UITextField
    @IBOutlet var zipText : UITextField
    
    @IBAction func save(sender : AnyObject) {
        attemptSave()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        var nextTag = textField.tag + 1;
        let nextResponder : UIResponder? = textField.superview.viewWithTag(nextTag)
        
        validateTextField(textField)
        
        if nextResponder {
            // Found next responder, so set it.
            nextResponder!.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            attemptSave()
        }
        return true
    }
    
    func attemptSave() {
        if validFirst && validLast && validAddress && validCity && validZip {
            
            var error: NSError? = nil
            var newPatient: Patient = NSEntityDescription.insertNewObjectForEntityForName("Patient", inManagedObjectContext: self.cdh.managedObjectContext) as Patient
            newPatient.firstName = firstNameText.text
            newPatient.lastName = lastNameText.text
            newPatient.address = addressText.text
            newPatient.city = cityText.text
            newPatient.state = stateText.text
            newPatient.zipCode = zipText.text.toInt()
            
            
            if newPatient.managedObjectContext.save(&error){
                println("SAVED")
                
                self.navigationController.popToRootViewControllerAnimated(true) //return back to main controller
                
                return
            }
            
            println("Error saving context: \(error?.localizedDescription)\n\(error?.userInfo)")
            abort()
        } else {
            let alert = UIAlertView()
            alert.title = "Validation Error"
            alert.message = "Please fill in all required fields"
            alert.addButtonWithTitle("OK")
            alert.show()
            return
        }
        
    }
    
    func textFieldDidEndEditing(textField : UITextField) {
        validateTextField(textField)
    }
    
    func validateTextField(textField : UITextField) {
        switch textField {
        case firstNameText:
            if textField.text.utf16count < 1 {
                textField.backgroundColor = UIColor.redColor()
                validFirst = false
            }
            else {
                textField.backgroundColor = UIColor.whiteColor()
                validFirst = true
            }
        case lastNameText:
            if textField.text.utf16count < 1 {
                textField.backgroundColor = UIColor.redColor()
                validLast = false
            }
            else {
                textField.backgroundColor = UIColor.whiteColor()
                validLast = true
            }
        case addressText:
            if textField.text.utf16count < 1 {
                textField.backgroundColor = UIColor.redColor()
                validAddress = false
            }
            else {
                textField.backgroundColor = UIColor.whiteColor()
                validAddress = true
            }
        case cityText:
            if textField.text.utf16count < 1 {
                textField.backgroundColor = UIColor.redColor()
                validCity = false
            }
            else {
                textField.backgroundColor = UIColor.whiteColor()
                validCity = true
            }
        case zipText:
            if !validateZip(textField.text) {
                textField.backgroundColor = UIColor.redColor()
                validZip = false
            }
            else {
                textField.backgroundColor = UIColor.whiteColor()
                validZip = true
            }
        default:
            textField.enabled = true
        }
    }
    
    func validateZip(zip : NSString) -> Bool {
        var zipRegEx : NSString = "(^[0-9]{5}(-[0-9]{4})?$)"
        let resultPredicate = NSPredicate(format: "SELF MATCHES %@", zipRegEx)
        
        return resultPredicate.evaluateWithObject(zip)
    }
}