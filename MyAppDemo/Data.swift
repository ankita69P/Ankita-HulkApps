//
//  Data.swift
//  MyAppDemo
//
//  Created by Nishit on 17/11/21.
//

import Foundation
import SwiftyJSON

class ResData {
    var id: Int?
    var title: String?
    var address: String?
    var iconImage: String?
    var subTitleInfo: String?
    
    init(id: Int?, title: String?, address: String?, iconImage: String?, subTitleInfo: String?){
        self.id = id
        self.title = title
        self.address = address
        self.iconImage = iconImage
        self.subTitleInfo = subTitleInfo
    }
    
    init(dataListJson: JSON) {
        self.id = dataListJson["merchant_id"].intValue
        self.title = dataListJson["restaurant_name"].stringValue
        self.address = dataListJson["offer_text_2"].stringValue
        self.iconImage = dataListJson["pic"].stringValue
        self.subTitleInfo = dataListJson["merchant_id"].stringValue
    }
}
