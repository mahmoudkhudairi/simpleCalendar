//
//  ViewController.swift
//  simpleCalendar
//
//  Created by mahmoud khudairi on 5/13/17.
//  Copyright © 2017 mahmoud khudairi. All rights reserved.
//

import UIKit
import JTAppleCalendar
class ViewController: UIViewController {
  @IBOutlet weak var toDateLabel: UILabel!
  @IBOutlet weak var yearLabel: UILabel!
  @IBOutlet weak var monthLabel: UILabel!
  @IBOutlet weak var calendarView: JTAppleCalendarView!
  
  let formatter = DateFormatter()
  var testCalendar = Calendar.current
  let dateFormatter : DateFormatter = {
    let formatter = DateFormatter()
    formatter.timeZone = Calendar.current.timeZone
    let locale = Locale(identifier: "en_US_POSIX")
    formatter.locale = locale
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter
  }()
   let displayDateFormatter : DateFormatter = {
    let formatter = DateFormatter()
    formatter.locale = Locale.current
    formatter.dateStyle = DateFormatter.Style.medium
    formatter.timeStyle = DateFormatter.Style.none
    return formatter
  }()
  var firstDate : Date?
		
  let currentDate = Date()
  let dayColor = UIColor.red
  let outsideMonthColor = UIColor.lightGray
  let monthColor = UIColor.black
  let selectedMonthColor = UIColor.white
  override func viewDidLoad() {
    super.viewDidLoad()
    setupCalendarView()
    calendarView.scrollToDate(Date())
  }
  func setupCalendarView(){
    //setup calendar spacing
    calendarView.minimumLineSpacing = 0
    calendarView.minimumInteritemSpacing = 0
    calendarView.allowsMultipleSelection = true
    //setup labels
    calendarView.visibleDates { (visibleDates) in
      self.handleCellCalendar(from: visibleDates)
    }
  }
  func handleCellCalendar(from visibleDates: DateSegmentInfo) {
    let date = visibleDates.monthDates.first!.date
    formatter.dateFormat = "yyyy"
    self.yearLabel.text = formatter.string(from: date)
    formatter.dateFormat = "MMMM"
    self.monthLabel.text = formatter.string(from: date)
  }
  func handleCellTextColor(view:JTAppleCell?, cellState: CellState, isToday : Bool){
    guard let validCell = view as? CustomeCell else {return}
    
    validCell.selectedView.isHidden = !cellState.isSelected
    
    if isToday {
      validCell.todayView.isHidden = false
      validCell.todayView.backgroundColor = dayColor
      return
    }
    if cellState.isSelected{
      validCell.dateLabel.textColor = selectedMonthColor
    } else {
      if cellState.dateBelongsTo == .thisMonth{
        validCell.dateLabel.textColor = monthColor
      }else{
        validCell.dateLabel.textColor = outsideMonthColor
      }
    }
  }
 
}
extension ViewController: JTAppleCalendarViewDataSource{
  func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
     let startDate = dateFormatter.date(from: "2010 01 01")
      let endDate = dateFormatter.date(from: "2025 01 01")
    
    let parameters = ConfigurationParameters(startDate: startDate!,
                                             endDate: endDate!,
                                             numberOfRows: 5,
                                             generateInDates:  .forAllMonths,
                                             generateOutDates: .tillEndOfRow,
                                             firstDayOfWeek:   .sunday )
    
    
    return parameters
    
  }
}

extension ViewController: JTAppleCalendarViewDelegate{
  //display cell
  func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
    
    let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CustomeCell", for: indexPath) as! CustomeCell
    cell.dateLabel.text = cellState.text
   
    if dateFormatter.string(from: date) == dateFormatter.string(from: currentDate) {
      //today
      
      handleCellTextColor(view: cell, cellState: cellState,isToday: true)
    }else {
      handleCellTextColor(view: cell, cellState: cellState, isToday: false)
    }
 
    return cell
  }
  
  func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
  handleCellTextColor(view: cell, cellState: cellState, isToday: false)

    if firstDate != nil {
      
      if date < firstDate! {
        calendarView.deselectAllDates()
        
        
        calendarView.selectDates(from: date, to: date,  triggerSelectionDelegate: false, keepSelectionIfMultiSelectionAllowed: true)
        firstDate = date
      } else {
        //2
          calendarView.deselectAllDates()
        
      
        calendarView.selectDates(from: firstDate!, to: date,  triggerSelectionDelegate: false, keepSelectionIfMultiSelectionAllowed: true)
        firstDate = nil
        
      }
    } else {
      //1
      calendarView.deselectAllDates()
      calendarView.selectDates(from: date, to: date,  triggerSelectionDelegate: false, keepSelectionIfMultiSelectionAllowed: true)
      firstDate = date
      
    }
    
    // Set title with selected dates
    
    let selectedDates = calendarView.selectedDates
    
    if firstDate == nil {
      self.toDateLabel.text = "From \(displayDateFormatter.string(from: selectedDates.first!)) - To \(displayDateFormatter.string(from: selectedDates.last!))"
    } else {
      self.toDateLabel.text = "\(displayDateFormatter.string(from: selectedDates.first!))"
    }
  }
  
  func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
 
    handleCellTextColor(view: cell, cellState: cellState, isToday: false)
    
  }

  func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
    
    handleCellCalendar(from: visibleDates)
    
    
  }
}
