//
//  SignUpViewController.swift
//  ParkingApp
//
//  Created by Muzammil  on 2021-05-18.
//

import Foundation
import UIKit
import FirebaseFirestore

class SignUpViewController: UIViewController {
    
    // Varialbles
    let defaults = UserDefaults.standard
    var currentPlate: String = ""
    
    // reference to the firestore database
    let db = Firestore.firestore()
    
    
    // MARK: OUTLETS
    @IBOutlet weak var signupLogo: UIImageView!
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfLName: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var tfCNumber: UITextField!
    @IBOutlet weak var tfplateNumber: UITextField!
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var tfConfirmPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        signupLogo?.image = UIImage(named:"logo")
        
//        password?.isSecureTextEntry = true
    }
    
    
    @IBAction func signUp(_ sender: Any) {
                     let contactNumber = tfCNumber.text
        // 1. get the mandatoory inputs from the textbox
               guard let firstName = tfName.text,
                     let lastName = tfLName.text,
                     let email = tfEmail.text,
                     let password = tfPassword.text,
                     let confirmPassword = tfConfirmPassword.text,
                     //let contactNumber = tfCNumber.text,
                     let plateNumber = tfplateNumber.text
               else {
                     return
               }
        
               // optional, but helpful
               if ( firstName.isEmpty || lastName.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty || plateNumber.isEmpty ) {
                   print("You must enter the required fields")
                   self.showFailedAlert()
                   return
               }
        
               // Email validation
               if ( !email.contains("@") || !email.contains(".")) {
                    print(#function, "please enter a valid email.")
                self.showEmailAlert()
               }

               
               //confirm if passwords are matched
               if ( password != confirmPassword ) {
                   print("You must enter same password")
                   self.showPasswordAlert()
                   return
               }
        
               if (  plateNumber.count < 2 || plateNumber.count  > 8 ){
                    print("Please enter valid Car Plate Number")
                self.showCarPlateAlert()
               }
                
        
               // 2. add it to firebase
               let user = [
                   "First Name":firstName,
                   "Last Name":lastName,
                   "email":email,
                   "password":password,
                   "Confirm Password":confirmPassword,
                   "Contact Number":contactNumber,
                   "Car Plate Number":plateNumber
                
               ]
                db.collection("users").getDocuments {
                    (queryResults, error) in
                    if let err = error {
                        print("Error getting documents from Users collection")
                        print(err)
                        return
                    }
                    else {
                        // we were successful in getting the documents
                        if (queryResults!.count == 0) {
                            print("No users found")
                        }
                        else {
                            // we found some results, so let's output it to the screen
                            for result in queryResults!.documents {
                                print(result.documentID)
                                // output the contents of that documents
                                let row = result.data()
                                if (row["email"] as? String) == email {
                                    print("User Found")
                                    
                                    self.userExistAlert()
                                    break
                                }
                                else {
                                    print("User doesn't exist")
                                    self.db.collection("users").addDocument(data: user as [String : Any]) { (error) in
                                        if let err = error {
                                            print("Error when saving document")
                                            print(err)
                                            return
                                        }
                                        else {
                                            print("document saved successfully")
                                            self.currentPlate = String(plateNumber)
                                            self.defaults.set(self.currentPlate, forKey: "plate")
                                            
                                            self.showSuccessAlert()
                                         
                                            self.tfName.text = ""
                                            self.tfLName.text = ""
                                            self.tfEmail.text = ""
                                            self.tfPassword.text = ""
                                            self.tfConfirmPassword.text = ""
                                            self.tfCNumber.text = ""
                                            self.tfplateNumber.text = ""
                                         
                                        }
                                    }
                                    
                                }
                                break
                            }
                        }
                        
                    }
                }

        }
   
    func showFailedAlert() {
        let alert = UIAlertController(title: "Alert", message: "Please enter the required fields", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    func showSuccessAlert() {
        let alert = UIAlertController(title: "Sign Up Successful", message: "Your account  has been created successfully", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in
            
            self.navigationController?.popViewController(animated: true)
                                   }))
        self.present(alert, animated: true)
    }
    
    func showPasswordAlert() {
        let alert = UIAlertController(title: "Passwords did not match", message: "Please enter correctly", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    func showEmailAlert() {
            let alert = UIAlertController(title: "Sign Up Unsuccessful", message: "Please enter a valid email address.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "default action"), style: .default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
            return
    }
    
    func showCarPlateAlert() {
            let alert = UIAlertController(title: "Sign Up Unsuccessful", message: "Please enter a valid car plate number of length >= 2 and <= 8.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "default action"), style: .default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
            print(#function, "please enter a valid car plate number")
            return
    }
    
    func userExistAlert() {
            let alert = UIAlertController(title: "Sign Up Unsuccessful", message: "Account already exists. Please enter a valid email address.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "default action"), style: .default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
            return
    }
    

}
