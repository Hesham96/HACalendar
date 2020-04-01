import Foundation
import UIKit

extension String {
        
   
    func substring(_ from: Int) -> String {
        return String(self[..<self.index(self.startIndex, offsetBy: from)])
    }
    
    var length: Int {
        return self.count
    }
    
    
    var timestamp: Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(identifier: "UTC") ?? TimeZone.current
        
        return dateFormatter.date(from: self) ?? Date()
    }
    var date: Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(identifier: "UTC") ?? TimeZone.current
        return dateFormatter.date(from: self) ?? Date()
    }
    
}
