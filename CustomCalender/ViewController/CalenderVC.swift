import UIKit
import SwiftyJSON

class CalenderVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource{
    
    var monthDays:[CalenderDate] = []
    var selectedDate:Date?
    
    var monthIndex:Int?
    var yearIndex:Int?
    var dayIndex:Int = 0
    var selectedIndex = 0

    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var englishBtn: UIButton!
    @IBOutlet weak var arabicBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 16)
        collectionView.slideFromLeft()
        englishBtn.slideFromBottom(duration: 1.1, completionDelegate: nil)
        arabicBtn.slideFromBottom(duration: 1.2, completionDelegate: nil)
        
        monthLabel.alpha = 0
        UIView.animate(withDuration: 1.9) {
            self.monthLabel.alpha = 1
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reverseCalender()
    }
    
    func reverseCalender(){
//        if LanguageManager.shared.currentLanguage == .ar{
//            collectionView.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
//        }
    }
    
    func setup(){
        navigationItem.title = "Custom Calender".locale
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionViewCellRegister()
        setupDefaultDate()
    }
    
    func scrollForToday(){
        collectionView.layoutIfNeeded()
        collectionView.scrollToItem(at: IndexPath(row: dayIndex - 1, section: 0), at: .left, animated: true)
    }
    
    
    func setupDefaultDate(){
        let date = Date()
        let defaultDate = date.toMonthlyYearFormatedString
        monthLabel.text = "\(defaultDate)"
        
        let mIndex = Calendar.current.component(.month, from: date)
        let yIndex = Calendar.current.component(.year, from: date)
        let dIndex = Calendar.current.component(.day, from: date)
        monthIndex = mIndex
        yearIndex = yIndex
        dayIndex = dIndex
        selectedIndex = dIndex - 1
        monthDays = getNumberOfDays(Year: yearIndex ?? 1, month: monthIndex ?? 1, selectedDay: dIndex)
        collectionView.reloadData()
        scrollForToday()
    }
    
    
    //MARK: Open Calender
    @IBAction func openCalenderAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "DatePickerVC") as! DatePickerVC
        vc.modalPresentationStyle = .overCurrentContext
        vc.delegate = self
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func changeToEnglishAction(_ sender: Any) {
        if LanguageManager.shared.currentLanguage == .ar {
//            LanguageManager.shared.setLanguage(language: .en)
        }
    }
    
    @IBAction func changeToArabicAction(_ sender: Any) {
        if LanguageManager.shared.currentLanguage == .en {
//            LanguageManager.shared.setLanguage(language: .ar)
        }
    }
    
    
    //MARK: CollectionView Handling
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return monthDays.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        calenderCellConfig(indexPath)
    }
    
    func calenderCellConfig(_ indexPath:IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalenderCell", for: indexPath) as! CalenderCell
        
        //MARK: Handle Language
        
        let dIndex = monthDays[indexPath.row].day ?? 0
        let dName = monthDays[indexPath.row].dayName ?? ""
        //MARK: Handle if today
        cell.isToday = dIndex == dayIndex && monthDays[indexPath.row].date?.timestamp.toStringCurrentTimeZone == Date().toStringCurrentTimeZone
        
        //MARK: Configure Calender cell
        cell.config(
            dayIndex: dIndex,
            dayName: dName,
            isSelectedCell: indexPath.row == selectedIndex
        )
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
//        reminders = ReminderUtil.getTimeLineByDate(date: monthDays[indexPath.row].date?.timestamp ?? Date())
        self.collectionView.reloadData()
    }
    
}


extension CalenderVC{
    //MARK: Cell Registeration
    func collectionViewCellRegister(){
        collectionView.register(UINib(nibName: "CalenderCell", bundle: nil), forCellWithReuseIdentifier: "CalenderCell")
    }
}

extension CalenderVC : DatePickerDelegate {
    
    func date(_ date: Date?)
    {
        if date != nil {
            if let newDate = date?.toString.date {
                monthLabel.text = "\(newDate.toMonthlyYearFormatedString)"
                selectedDate = date
                
                let mIndex = Calendar.current.component(.month, from: date!)
                let yIndex = Calendar.current.component(.year, from: date!)
                let dIndex = Calendar.current.component(.day, from: date!)
                
                monthIndex = mIndex
                yearIndex = yIndex
                dayIndex = dIndex
                
                monthDays = getNumberOfDays(Year: yearIndex ?? 1, month: monthIndex ?? 1 , selectedDay:dIndex)
                selectedIndex = dIndex - 1
//                self.collectionView.reloadSections([0])
                self.collectionView.reloadData()
//                reminders = ReminderUtil.getTimeLineByDate(date: monthDays[selectedIndex].date?.timestamp ?? Date())
            }
        }
        
    }
    
    func getNumberOfDays(Year:Int , month:Int , selectedDay:Int) -> [CalenderDate] {
        var dateComponents = DateComponents()
        dateComponents.year = Year
        dateComponents.month = month
        
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "UTC") ?? TimeZone.current
        let datez = calendar.date(from: dateComponents)
        // change .month into .year to see the days available in the year
        let interval = calendar.dateInterval(of: .month, for: datez!)!
        
        let days = calendar.dateComponents([.day], from: interval.start, to: interval.end).day!
        var calenderDates:[CalenderDate] = []
        for item in 1...days {
            let day = "\(item)"
            let newMonth = "\(month)"
            let date = "\(Year)-\(newMonth.count == 1 ? "0"+newMonth : newMonth)-\(day.count == 1 ? "0"+day : day) 00:00:00"

            let data : [String : Any] = [
                "day":item,
                "dayName":date.timestamp.shortDayString ,
                "date": date.timestamp.toTimestampString ,
                "isSelected":item == selectedDay,
            ]
            let calenderDate = CalenderDate(JSON(data))
            calenderDates.append(calenderDate)
        }
        return calenderDates
    }
}


extension CalenderVC : UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 64, height: 77)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
    }
}
