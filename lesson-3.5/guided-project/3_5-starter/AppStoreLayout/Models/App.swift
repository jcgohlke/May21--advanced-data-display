
import UIKit

struct App: Hashable {
    
    static let priceFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        
        return formatter
    }()
    
    let promotedHeadline: String?
    
    let title: String
    let subtitle: String
    let price: Double?
    var formattedPrice: String {
        if let price = price {
            return App.priceFormatter.string(from: NSNumber(value: price)) ?? String(price)
        } else {
            return "GET"
        }
    }
    
    let color = UIColor.random
}

