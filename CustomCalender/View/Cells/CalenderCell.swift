
import UIKit


class CalenderCell: UICollectionViewCell {
    
    
    @IBOutlet weak var bkgroundView: UIView!
    @IBOutlet weak var dayIndexLabel: UILabel!
    @IBOutlet weak var dayNameLabel: UILabel!
    
    var isSelectedCell:Bool = false
    var isToday:Bool = false
    
    
    func config(dayIndex:Int,dayName:String , isSelectedCell:Bool){

        isSelectedDayHandle(isSelectedCell)
        isTodayHandle(isToday)
        
        dayIndexLabel.text = "\(dayIndex)"
        dayNameLabel.text = dayName.uppercased()
        if LanguageManager.shared.currentLanguage == .ar{
              self.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
          }else{
            self.transform = .identity
          }
    }
    
    
    func isSelectedDayHandle(_ isSelected:Bool){
        if isSelected && !(isToday){
            self.bkgroundView.layer.borderWidth = 1
            self.bkgroundView.layer.borderColor = UIColor.customGreen.cgColor
        }else{
            self.bkgroundView.layer.borderWidth = 0
        }
    }
    func isTodayHandle(_ isToday:Bool){
        let cellContentColor:UIColor = isToday ? .customGreen : .black
        
        self.bkgroundView.backgroundColor = isToday ? .customGreenAlpha : .white
        
        dayIndexLabel.textColor = cellContentColor
        dayNameLabel.textColor = cellContentColor
        
    }
}
