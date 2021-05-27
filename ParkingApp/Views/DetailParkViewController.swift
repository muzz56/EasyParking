//
//  DetailParkViewController.swift
//  ParkingApp
//
//  Created by Graphic on 2021-05-22.
//

import UIKit

class DetailParkViewController: UIViewController {
    
    // Outlets
    @IBOutlet weak var lblCarPlate: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblHours: UILabel!
    @IBOutlet weak var lblBuildingCode: UILabel!
    @IBOutlet weak var lblSlot: UILabel!
    
    // Variables
    var selectedParking:Park?

      override func viewDidLoad() {
        super.viewDidLoad()

        guard let currentParking = selectedParking else {
            print(#function,"Parking is null")
            return
        }
        
        print("\(currentParking )")
        lblCarPlate.text = "Car Plate: \(String(currentParking.carPlate))"
        lblAddress.text = "Address: \n\(currentParking.parkingLocation)"
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d y, HH:mm E"
        lblDate.text = "Date: \(formatter.string(from: currentParking.dateTime))"
        lblHours.text = "Parking booked for \(String(currentParking.numberHours)) hours"
        lblBuildingCode.text = "Building Code: \(currentParking.buildindCode)"
        lblSlot.text = "Suite Number: \(currentParking.suitHost)"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mapPark"
        {
            let vc = segue.destination as! MapParkViewController
            vc.address = selectedParking!.parkingLocation
        }
        
    }

}
