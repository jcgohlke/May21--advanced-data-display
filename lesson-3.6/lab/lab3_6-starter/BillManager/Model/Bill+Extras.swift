//
//  Bill+Extras.swift
//  BillManager
//

import Foundation

extension Bill {
        
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()
    
    var hasReminder: Bool {
        return (remindDate != nil)
    }
    
    var isPaid: Bool {
        return (paidDate != nil)
    }
    
    var formattedDueDate: String {
        let dateString: String
        
        if let dueDate = self.dueDate {
            dateString = Bill.dateFormatter.string(from: dueDate)
        } else {
            dateString = ""
        }
        
        return dateString
    }
    
}
