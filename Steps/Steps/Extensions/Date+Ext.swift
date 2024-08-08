//
//  Date+Ext.swift
//  Steps
//
//  Created by christian on 8/8/24.
//

import Foundation

extension Date {
    var weekdayInt: Int {
        Calendar.current.component(.weekday, from: self)
    }
}
