////
////  EditViewController.swift
////  ParkingApp
////
////  Created by Muzammil  on 2021-05-25.
////
//
import UIKit
import FirebaseFirestore

class EditViewController: UIViewController {
//
    let db=Firestore.firestore()
//
//
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfLName: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfNewPassword: UITextField!
    @IBOutlet weak var tfConfirmNewPassword: UITextField!
    @IBOutlet weak var tfContact: UITextField!
    @IBOutlet weak var tfCarPlateNumber: UITextField!
//
//
    @IBOutlet weak var errorText: UILabel!

    var password:String = ""
    var userId = ""

    func fetchUser(documentId: String){
      let docRef = db.collection("users").document(documentId)
      docRef.getDocument { document, error in
        if let error = error as NSError? {
            self.errorText.text = "Error getting document: \(error.localizedDescription)"
        }
        else {
          if let document = document {
            do {
                let row = document.data()
                self.tfName.text = row?["First Name"] as? String
                self.tfLName.text = row?["Last Name"] as? String
                self.tfEmail.text = row?["email"] as? String
                self.tfContact.text = row?["Contact Number"] as? String
                self.tfCarPlateNumber.text = row?["Car Plate Number"] as? String
                self.tfNewPassword.text = row?["password"] as? String
                self.tfConfirmNewPassword.text = row?["Confirm Password"] as? String

            }
            catch {
              print(error)
            }
          }
        }
      }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        userId = UserDefaults.standard.string(forKey: "ID")!
        fetchUser(documentId: userId)

        // Do any additional setup after loading the view.
    }


    @IBAction func deleteAccountPressed(_ sender: Any) {

        db.collection("users").document(userId).delete() { (error) in
            if let err = error {
                self.errorText.text = "Error when updating document"
                print(err)
                return
            }
            else {
                //self.errorText.text = "Details deleted successfully"
                self.goToLoginPage()
                self.showDeleteSuccessAlert()
                
            }
        }


    }


    @IBAction func updateAccountPressed(_ sender: Any) {

        let carPlateNo=tfCarPlateNumber.text!
        let email=tfEmail.text!
        let contactNo=tfContact.text!
        let name=tfName.text!
        let lastName=tfLName.text!
        let newPassword=tfNewPassword.text!
        let confirmNewPassword=tfConfirmNewPassword.text!

        //         optional, but helpful
        if (carPlateNo.isEmpty || email.isEmpty || name.isEmpty || lastName.isEmpty || newPassword.isEmpty || confirmNewPassword.isEmpty) {
            let alert = UIAlertController(title: "Alert", message: "Please enter required fields", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
            return
        }
        
        // Email validation
        if ( !email.contains("@") || !email.contains(".")) {
             print(#function, "please enter a valid email.")
             self.showEmailAlert()
        }

        
        //confirm if passwords are matched
        if ( newPassword != confirmNewPassword ) {
            print("You must enter same password")
            self.showPasswordAlert()
            return
        }
 
        if (  carPlateNo.count < 2 || carPlateNo.count  > 8 ){
             print("Please enter valid Car Plate Number")
             self.showCarPlateAlert()
        }
        
        
        //         2. add it to firebase
        let user = [
            "First Name":name,
            "Last Name":lastName,
            "email":email,
            "password":newPassword,
            "Confirm Password":confirmNewPassword,
            "Contact Number":contactNo,
            "Car Plate Number":carPlateNo

        ]

        db.collection("users").document(userId).updateData(user) { (error) in
            if let err = error {
                //self.errorText.text = "Error when updating document"
                self.showFailedAlert()
                print(err)
                return
            }
            else {
                //self.errorText.text = "Details updated successfully"
                self.goToLoginPage()
                self.showSuccessAlert()
            }
        }

    }
    
    func showFailedAlert() {
        let alert = UIAlertController(title: "Updation Unsuccessful", message: "Cannot Update", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    func showSuccessAlert() {
        let alert = UIAlertController(title: "Update Successful", message: "You have updated in successfully", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    func showDeleteSuccessAlert() {
        let alert = UIAlertController(title: "Deletion Successful", message: "You have Deleted successfully", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
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
    
    func goToLoginPage(){
        guard let loginPage = self.storyboard?.instantiateViewController(identifier: "login_page") as? SignInViewController else {
                    print("Cannot find Login  Page!")
                    return
                }
                self.show(loginPage, sender: self)
    }
}
//
//
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//    }
//    */
//
//}
