//
//  ViewController.swift
//  MyAppDemo
//
//  Created by Nishit on 17/11/21.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet weak var tblItems: UITableView!
    
    var currentPage: Int = 1
    
    var myResponse : JSON? = nil
    var data : [ResData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblItems.register(UINib(nibName: "ItemViewCell", bundle: nil), forCellReuseIdentifier: "ItemViewCell")
        
        self.loadData(currentPage: self.currentPage)
    }
}

//MARK: UITableViewDelegate Methods
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemViewCell") as! ItemViewCell
        cell.loadData(itemData: self.data[indexPath.row])
        cell.btnAdd.addTarget(nil, action: #selector(self.onBtnFavClicked(_:)), for: .touchDragInside)
        if indexPath.row == self.data.count - 1 {
            self.loadMoreItems()
        }
        return cell
    }
}

// MARK: IBAction Methods
extension ViewController {
    @IBAction func onBtnFavClicked(_ sender: Any) {
        var superview = (sender as AnyObject).superview
        while let view = superview, !(view is UITableViewCell) {
            superview = view?.superview
        }
        guard let cell = superview as? UITableViewCell else {
            print("button is not contained in a table view cell")
            return
        }
        guard let indexPath = self.tblItems.indexPath(for: cell) else {
            print("failed to get index path for cell containing button")
            return
        }
        print("onBtnFavClicked() ::: is in row \(indexPath.row)")
        
        let alert = UIAlertController(title: "Confirmation", message: "Sure to store as a Favourite?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes",
                                      style: UIAlertAction.Style.default,
                                      handler: {action in
            self.storeData(resItem: self.data[indexPath.row])}))
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: API Call Functions
extension ViewController {
    func loadData(currentPage: Int) {
        let baseURL = "https://onlinekaka.com/serviceclient/index.php/callback/nearByMerchantV2?page=\(currentPage)&q=biryani&lat=26.846693664076216&lon=80.9461659193039&order_by=restaurant_name&api_version=v2&search_type=item"
        AF.request(baseURL, method: .get, encoding: JSONEncoding.default).responseJSON { response in
            switch response.result {
                case .failure(let error): print(error)
                case .success(let data):
                    self.myResponse = JSON(data)
                    let a = self.myResponse!["merchant_info"]["dishes"]
                    for i in 0..<a.count{
                        let single = ResData(dataListJson: a[i])
                        self.data.append(single)
                    }
                    DispatchQueue.main.async {
                        self.tblItems.reloadData()
                    }
            }
        }
    }
    
    func loadMoreItems() {
        self.loadData(currentPage: self.currentPage + 1)
    }
}

// MARK: User Define Functions
extension ViewController {
    func storeData(resItem: ResData) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let resEntity = NSEntityDescription.entity(forEntityName: "ResDetails", in: managedContext)!
        
        let resDetail = NSManagedObject(entity: resEntity, insertInto: managedContext)
        resDetail.setValue(resItem.id, forKey: "id")
        resDetail.setValue(resItem.title, forKey: "title")
        resDetail.setValue(resItem.address, forKey: "address")
        resDetail.setValue(resItem.iconImage, forKey: "image")
        resDetail.setValue(resItem.subTitleInfo, forKey: "subTitle")
        
        do {
            try managedContext.save()
            let detailsViewController = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DetailsViewController") as? DetailsViewController
            self.navigationController?.pushViewController(detailsViewController!, animated: true)
        }catch let error as NSError {
            print("Coudn't not save. \(error), \(error.userInfo)")
        }
    }
}

// MARK: UIImageView Extensions
extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
