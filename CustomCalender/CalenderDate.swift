import SwiftyJSON

class CalenderDate {
    var day:Int?
    var dayName:String?
    var date:String?
    var isSelected:Bool = false
    
    required init(_ json:JSON) {
        self.day = json["day"].int
        self.dayName = json["dayName"].string
        self.date = json["date"].string
        self.isSelected = json["isSelected"].bool ?? false
    }
}
