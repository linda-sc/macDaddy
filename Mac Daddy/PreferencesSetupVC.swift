//
//  PreferencesSetupVC.swift
//  Mac Daddy
//
//  Created by Linda Chen on 6/6/17.
//  Copyright © 2017 Synestha. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class PreferencesSetupVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var nextButton:UIButton!
    @IBOutlet weak var profilePicture:UIImageView!
    @IBOutlet weak var nameLabel:UILabel!
    @IBOutlet weak var macSelector:UISegmentedControl!
    @IBOutlet weak var background:UIImageView!
    
    var databaseRef = Database.database().reference()
    let user = Auth.auth().currentUser
    var grade = "Freshman"
    var isDaddy = true

    
    @IBOutlet weak var picker:UIPickerView!
    var pickerData: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.nameLabel.text = DataHandler.name
       //self.profilePicture.image = DataHandler.picture
        
        //Retrieve the name data from Firebase to show the name underneath the profile picture.
        self.databaseRef.child("users").child((user?.uid)!).observeSingleEvent(of: .value) { (snapshot: DataSnapshot) in
            let snapshotValue = snapshot.value as? NSDictionary
            self.nameLabel.text = snapshotValue?["Name"] as? String
         //   self.profilePicture.image = snapshotValue?["Profile Picture"] as? String
        }
        
        // Connect data:
        self.picker.delegate = self
        self.picker.dataSource = self
        
        // Input data into the Array:
        pickerData = ["Freshman", "Sophomore", "Junior", "Senior"]
    }
    
    //Make the status bar white.
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // The number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    // Catpure the picker view selection
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // This method is triggered whenever the user makes a change to the picker selection.
        // The parameter named row and component represents what was selected.
        self.grade = pickerData[row]
        
    }
    
    //Change text color to white, set the text to the grades.
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        if row == 0{
            return NSAttributedString(string: "Freshman", attributes: [NSForegroundColorAttributeName : UIColor.white])
            
        } else if row == 1{
            return NSAttributedString(string: "Sophomore", attributes: [NSForegroundColorAttributeName : UIColor.white])
            
        }else if row == 2{
            return NSAttributedString(string: "Junior", attributes: [NSForegroundColorAttributeName : UIColor.white])
            
        }else{
            return NSAttributedString(string: "Senior", attributes: [NSForegroundColorAttributeName : UIColor.white])
            
        }
    }
    
    @IBAction func macSelectorChanged(_ sender: UISegmentedControl) {
        //Flip the boolean
        isDaddy = !isDaddy
        //Check the boolean and set the button and labels
        if isDaddy
        {
            DataHandler.macStatus = "Daddy"
            DataHandler.saveDefaults()
            background.image = UIImage(named: "MacDaddy Background_Purple")
            self.macSelector.selectedSegmentIndex = 0
        }
        else
        {
            DataHandler.macStatus = "Baby"
            background.image = UIImage(named: "MacDaddy Background")
            self.macSelector.selectedSegmentIndex = 1
        }
    }

    
    @IBAction func nextButtonTapped(_sender:UIButton){
        DataHandler.grade = grade
        DataHandler.saveDefaults()
        let values = ["Grade": grade, "Mac Status": DataHandler.macStatus]
        let user = Auth.auth().currentUser
        let ref = Database.database().reference(fromURL: "https://mac-daddy-df79e.firebaseio.com/")
        let usersReference = ref.child("users").child((user?.uid)!)
        
        usersReference.updateChildValues(values)
        print ("Grade successfully saved")
        //After they reach this point, they are eligible to be matched.
        DataHandler.updateUserData(uid: (user?.uid)!, values: ["PrimaryA" : "y", "SecondaryA" : "y"])
        
        self.performSegue(withIdentifier: "goToSetup4", sender: self)
    }
}
