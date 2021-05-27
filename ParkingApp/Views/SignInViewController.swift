//
//  ViewController.swift
//  ParkingApp
//
//  Created by Graphic on 2021-05-12.
//

import UIKit
import FirebaseFirestore

class SignInViewController: UIViewController {
    
    // Varialbles
    let defaults = UserDefaults.standard
    var currentUser: String = ""
    var currentPlate: String = ""
    
    // reference to the firestore database
    let db = Firestore.firestore()

    // MARK: OUTLETS
    @IBOutlet weak var imageLogo: UIImageView!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var rememberMe: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageLogo?.image = UIImage(named:"logo")
    }

    @IBOutlet weak var loginButton: UIButton!
    
    func showFailedPasswordAlert() {
        let alert = UIAlertController(title: "Invalid Password", message: "Please enter password correctly", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    func showFailedEmailAlert() {
        let alert = UIAlertController(title: "Invalid Email", message: "Please enter email correctly", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    func showNotFoundAlert() {
        let alert = UIAlertController(title: "Alert", message: "User Not Found. Sign Up to create account", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    func showSuccessAlert() {
        let alert = UIAlertController(title: "Login Successful", message: "You have logged in successfully", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    @IBAction func signIn(_ sender: Any) {
        guard let unwrappedEmail = email.text, let unwrappedPassword = password.text else {
                return
        }
        db.collection("users")
            .getDocuments(){ [self]
            (queryResults, error) in
            if let err = error {
                print("Error getting documents from Users collection")
                print(err)
                return
            }
            else {
                // we were successful in getting the documents
                if (queryResults!.count == 0) {
                    //print("No users found")
                    //showNotFoundAlert()
                }
                else {
                    var userFound = false
                    // we found some results, so let's output it to the screen
                    for result in queryResults!.documents {
                        print(result.documentID)
                        // output the contents of that documents
                        let row = result.data()
                        if (row["email"] as? String) == unwrappedEmail{
                            userFound = true
                            if(row["password"] as? String) == unwrappedPassword{
                                print("User Found")
                                self.currentUser = String(result.documentID)
                                self.defaults.set(currentUser, forKey: "user")
                                UserDefaults.standard.set(result.documentID, forKey: "ID")

                                self.goToAddParking()
                                self.showSuccessAlert()
                                break
                            }
                            else {
                                print("Incorrect Email/Password")
                                self.showFailedPasswordAlert()
                                break
                            }
                        
                        }
                    }
                    if !userFound {
                        self.showFailedEmailAlert()
                    }
                
                }
            }
        }
    }
    
    @objc
    func signout(){
        let alert = UIAlertController(title: "Caution", message: "Are you sure want to sign out of your account?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Sign Out", style: .destructive, handler: {_ in
            self.navigationController?.popToRootViewController(animated: true)}))
        self.present(alert, animated: true)
    }
    
    func goToAddParking() {
      guard let listParking = storyboard?.instantiateViewController(identifier: "tab")  else {
                print("Cannot find Parking List!")
                return
        }
        listParking.navigationItem.hidesBackButton = true
        listParking.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "SignOut", style: .plain, target: self, action: #selector(self.signout))
        show(listParking, sender: self)
    }
    
}
    
    


