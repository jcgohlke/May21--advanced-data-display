//
//  Database.swift
//  BillManager
//

import Foundation
import UIKit

class Database {
    
    static let billUpdatedNotification = NSNotification.Name("com.apple.BillManager.billUpdated")

    static let shared = Database()
        
    private func loadBills() -> [UUID:Bill]? {
        var bills = [UUID:Bill]()
        
        do {
            let storageDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let storageURL = storageDirectory.appendingPathComponent("bills").appendingPathExtension("json")
            let fileData = try Data(contentsOf: storageURL)
            let billsArray = try JSONDecoder().decode([Bill].self, from: fileData)
            bills = billsArray.reduce(into: bills) { partial, bill in
                partial[bill.id] = bill
            }
        } catch {
            return nil
        }
        
        return bills
    }
    
    private func saveBills(_ bills: [UUID:Bill]) {
        do {
            let storageDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let storageURL = storageDirectory.appendingPathComponent("bills").appendingPathExtension("json")
            let fileData = try JSONEncoder().encode(Array(bills.values))
            try fileData.write(to: storageURL)
        } catch {
            fatalError("There was a problem saving bills. Error: \(error)")
        }
    }
    
    private var _billsOptional: [UUID:Bill]?
    private var _billsLookup: [UUID:Bill] {
        get {
            if _billsOptional == nil {
                _billsOptional = loadBills() ?? [:]
            }
            
            return _billsOptional!
        }
        set {
            _billsOptional = newValue
        }
    }
    
    var bills: [Bill] {
        get {
            return Array(_billsLookup.values.sorted(by: <))
        }
    }
    
    func addBill() -> Bill {
        let bill = Bill()
        _billsLookup[bill.id] = bill
        return bill
    }
    
    func updateAndSave(_ bill: Bill) {
        _billsLookup[bill.id] = bill
        save()
        NotificationCenter.default.post(name: Self.billUpdatedNotification, object: nil)
    }
        
    func save() {
        saveBills(_billsLookup)
    }
    
    func delete(bill: Bill) {
        _billsLookup[bill.id] = nil
    }
    
    func getBill(withID id: UUID) -> Bill? {
        return _billsLookup[id]
    }
    
}

extension Bill: Comparable {
    static func < (lhs: Bill, rhs: Bill) -> Bool {
        func compareAmounts(_ l: Bill, _ r: Bill) -> Bool {
            switch (l.amount, r.amount) {
            case (let l?, let r?):
                return l > r
            case (nil, .some(_)):
                return false
            case (.some(_), nil):
                return true
            case (nil, nil):
                return lhs.id.uuidString < rhs.id.uuidString
            }
        }
        
        switch (lhs.dueDate, rhs.dueDate) {
        case (let l?, let r?):
            let result = Calendar.current.compare(l, to: r, toGranularity: .day)
            if result == .orderedSame {
                return compareAmounts(lhs, rhs)
            } else {
                return result == .orderedAscending
            }
        case (nil, .some(_)):
            return false
        case (.some(_), nil):
            return true
        case (nil, nil):
            return compareAmounts(lhs, rhs)
        }
    }
}
