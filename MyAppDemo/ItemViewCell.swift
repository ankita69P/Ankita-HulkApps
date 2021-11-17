//
//  ItemViewCell.swift
//  MyAppDemo
//
//  Created by Nishit on 17/11/21.
//

import UIKit

class ItemViewCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    
    @IBOutlet weak var btnAdd: UIButton!
    
    @IBOutlet weak var imgIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension ItemViewCell {
    func loadData(itemData: ResData) {
        self.lblTitle.text = itemData.title
        self.lblAddress.text = itemData.address
        self.lblDescription.text = itemData.subTitleInfo
        self.imgIcon.load(url: URL(string: "https://cdn.cocoacasts.com/cc00ceb0c6bff0d536f25454d50223875d5c79f1/above-the-clouds.jpg")!)
        
        self.btnAdd.layer.cornerRadius = 7.0
        self.btnAdd.clipsToBounds = true
        //        print(("URL \(self.data[indexPath.row].iconImage!)"))
        //        https://www.onlinekaka.com/upload/1539340979-SDRE.jpg
    }
}
