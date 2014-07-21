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
        
        statePicker.delegate = self
        firstNameText.delegate = self
        lastNameText.delegate = self
        addressText.delegate = self
        cityText.delegate = self
        zipText.delegate = self
        
        if patient != nil {
            firstNameText.text = patient!.firstName
            lastNameText.text = patient!.lastName
            addressText.text = patient!.address
            cityText.text = patient!.city
            let stateSpot = find(allStateVals, patient!.state)
            if stateSpot {
                statePicker.selectRow(stateSpot!, inComponent: 0, animated: true)
            }
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
    var validZip : Bool = false
    
    var allStates: [String] = ["Alabama", "Alaska", "Arizona", "Arkansas", "California", "Colorado", "Connecticut", "Delaware", "District of Columbia", "Florida", "Georgia", "Hawaii", "Idaho", "Illinois", "Indiana", "Iowa", "Kansas", "Kentucky", "Louisiana", "Maine", "Maryland", "Massachusetts", "Michigan", "Minnesota", "Mississippi", "Missouri", "Montana", "Nebraska", "Nevada", "New Hampshire", "New Jersey", "New Mexico", "New York", "North Carolina", "North Dakota", "Ohio", "Oklahoma", "Oregon", "Pennsylvania", "Rhode Island", "South Carolina", "South Dakota", "Tennessee", "Texas", "Utah", "Vermont", "Virginia", "Washington", "West Virginia", "Wisconsin", "Wyoming"]
    var allStateVals: [String] = ["AL", "AK", "AZ", "AR", "CA", "CO", "CT", "DE", "DC", "FL", "GA", "HI", "ID", "IL", "IN", "IA", "KS", "KY", "LA", "ME", "MD", "MA", "MI", "MN", "MS", "MO", "MT", "NE", "NV", "NH", "NJ", "NM", "NY", "NC", "ND", "OH", "OK", "OR", "PA", "RI", "SC", "SD", "TN", "TX", "UT", "VT", "VA", "WA", "WV", "WI", "WY"]
    var selState = "AL"
    
    
    @IBOutlet var saveButton : UIButton!
    @IBOutlet var firstNameText : UITextField!
    @IBOutlet var lastNameText : UITextField!
    @IBOutlet var addressText : UITextField!
    @IBOutlet var cityText : UITextField!
    @IBOutlet var zipText : UITextField!
    @IBOutlet var statePicker : UIPickerView!
    
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
        var butText = saveButton.titleLabel.text
        
        validateAll()
        
        if validFirst && validLast && validAddress && validCity && validZip {
            
            var error: NSError? = nil
            
            var newPatient: Patient = NSEntityDescription.insertNewObjectForEntityForName("Patient", inManagedObjectContext: self.cdh.managedObjectContext) as Patient
            if butText == "Save Edits" {
            //save edits
                newPatient = patient!
            }
            newPatient.firstName = firstNameText.text
            newPatient.lastName = lastNameText.text
            newPatient.address = addressText.text
            newPatient.city = cityText.text
            newPatient.state = selState
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
    
    func validateAll(){
        validateTextField(firstNameText)
        validateTextField(lastNameText)
        validateTextField(addressText)
        validateTextField(cityText)
        validateTextField(zipText)
    }
    
    func validateTextField(textField : UITextField) {
        switch textField {
        case firstNameText:
            if textField.text.utf16Count < 1 {
                textField.backgroundColor = UIColor.redColor()
                validFirst = false
            }
            else {
                textField.backgroundColor = UIColor.whiteColor()
                validFirst = true
            }
        case lastNameText:
            if textField.text.utf16Count < 1 {
                textField.backgroundColor = UIColor.redColor()
                validLast = false
            }
            else {
                textField.backgroundColor = UIColor.whiteColor()
                validLast = true
            }
        case addressText:
            if textField.text.utf16Count < 1 {
                textField.backgroundColor = UIColor.redColor()
                validAddress = false
            }
            else {
                textField.backgroundColor = UIColor.whiteColor()
                validAddress = true
            }
        case cityText:
            if textField.text.utf16Count < 1 {
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

extension PatientViewController: UIPickerViewDataSource {
    // two required methods
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView!) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView!, numberOfRowsInComponent component: Int) -> Int {
        return 51
    }
}

extension PatientViewController: UIPickerViewDelegate {
    // several optional methods:
    
    // func pickerView(pickerView: UIPickerView!, widthForComponent component: Int) -> CGFloat
    
    // func pickerView(pickerView: UIPickerView!, rowHeightForComponent component: Int) -> CGFloat
    
    func pickerView(pickerView: UIPickerView!, titleForRow row: Int, forComponent component: Int) -> String! {
        return allStates[row]
    }
    
    // func pickerView(pickerView: UIPickerView!, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString!
    
    func pickerView(pickerView: UIPickerView!, viewForRow row: Int, forComponent component: Int, reusingView view: UIView!) -> UIView! {
        let label = UILabel()
        label.text = "     " + allStates[row]
        label.font = UIFont.systemFontOfSize(12)
        return label
    }
    
    func pickerView(pickerView: UIPickerView!, didSelectRow row: Int, inComponent component: Int) {
        selState = allStateVals[row]
    }
}