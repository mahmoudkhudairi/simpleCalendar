//
//  CustomeCell.swift
//  simpleCalendar
//
//  Created by mahmoud khudairi on 5/13/17.
//  Copyright © 2017 mahmoud khudairi. All rights reserved.
//

import UIKit
import JTAppleCalendar
class CustomeCell: JTAppleCell {

  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var selectedView: UIView!
  
  @IBOutlet weak var todayView: UIView!
  
  override func prepareForReuse() {
    dateLabel.backgroundColor = UIColor.clear
    todayView.backgroundColor = UIColor.clear
    todayView.isHidden = true
  }
}
