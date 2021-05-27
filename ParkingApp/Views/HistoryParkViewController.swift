//
//  HistoryParkViewController.swift
//  ParkingApp
//
//  Created by Graphic on 2021-05-20.
//

import UIKit
import FirebaseFirestore

class HistoryParkViewController: UIViewController {
    // Outlets
    @IBOutlet weak var tableParkingView: UITableView!
    
    // Variables
    let db = Firestore.firestore()
    let defaults = UserDefaults.standard
    
    let parkingController = ParkingController()
    var listParking = [Park]()
    
    var rowSelected: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableParkingView.delegate = self
        self.tableParkingView.dataSource = self
        self.tableParkingView.rowHeight = 150
        
        self.fetchParking()  // WOM Select .where(user)
        
    }
    
    func fetchParking() {
        let currentUser = defaults.value(forKey: "user") as! String
        db.collection("parking")
            .whereField("user", isEqualTo: currentUser)
            .order(by: "dateTime", descending: true)
            .getDocuments {
            (queryResults, error) in
            if let err = error {
                print(#function,"Error occurred when fetching documents from Firestore \(err)")
                return
            }
            else {
                if (queryResults!.documents.count == 0) {
                    print(#function,"No Parking found")
                    self.showAlert(title: "History", message: "No History Parking available")
                }
                else {
                    for result in queryResults!.documents {
                        do {
                            let parkingFirestore = try result.data(as: Park.self)
                            self.listParking.append(parkingFirestore!)
                        } catch {
                            print(error)
                        }
                    }
                    print(#function,"Number of tasks in array: \(self.listParking.count)")
                    self.tableParkingView.reloadData()
                }
            }
        }
    } //  end fetch
    
    func showAlert(title : String, message : String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }

} // end class

extension HistoryParkViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listParking.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableParkingView.dequeueReusableCell(withIdentifier: "parkCell") as? HistoryParkTableViewCell

        if cell != nil {
            cell?.lblCarPlate.text = "Car Plate Number : \(String(listParking[indexPath.row].carPlate))"
            cell?.lblAddress.text = "\(listParking[indexPath.row].parkingLocation)"
            cell?.lblHours.text = "Park \(String(listParking[indexPath.row].numberHours)) hours"
            
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM d y, HH:mm E"
            cell?.lblDate.text = "\(formatter.string(from: listParking[indexPath.row].dateTime))"
        }
        
        return cell!
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailPark" {
            if let indexPath = tableParkingView.indexPathForSelectedRow {
                let destinationVC = segue.destination as! DetailParkViewController
                destinationVC.selectedParking = listParking[indexPath.row]
            }
        }
    }
}
