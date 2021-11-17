//
//  DetailsViewController.swift
//  MyAppDemo
//
//  Created by Nishit on 17/11/21.
//

import UIKit
import CoreData

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var tblItemDetails: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: User Define Functions
extension DetailsViewController {
    func retriveData(resItem: ResData) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ResDetails")
//        do {
//            let result = try managedContext.fetch(fetchRequest)
//            for data in result as! [NSManagedObject] {
//                print(data.value(forKey: title ?? "") as! String)
//            }
//        } catch {
//            print("Failed...")
//        }
    }
}
