
import Foundation

enum Item: Hashable {
    case app(App)
    case category(StoreCategory)
    
    var app: App? {
        if case .app(let app) = self {
            return app
        } else {
            return nil
        }
    }
    
    var category: StoreCategory? {
        if case .category(let category) = self {
            return category
        } else {
            return nil
        }
    }
    
    static let promotedApps: [Item] = [
        .app(App(promotedHeadline: "Now Trending", title: "Game Title", subtitle: "Game Description", price: 3.99)),
        .app(App(promotedHeadline: "Limited Time", title: "Game Title", subtitle: "Game Description", price: nil)),
        .app(App(promotedHeadline: "New Update", title: "Game Title", subtitle: "Game Description", price: nil)),
        .app(App(promotedHeadline: "Just Released", title: "Game Title", subtitle: "Game Description", price: nil))
    ]
    
    static let popularApps: [Item] = [
        .app(App(promotedHeadline: nil, title: "Game Title", subtitle: "Game Description", price: nil)),
        .app(App(promotedHeadline: nil, title: "Game Title", subtitle: "Game Description", price: 2.99)),
        .app(App(promotedHeadline: nil, title: "Game Title", subtitle: "Game Description", price: nil)),
        .app(App(promotedHeadline: nil, title: "Game Title", subtitle: "Game Description", price: 9.99)),
        .app(App(promotedHeadline: nil, title: "Game Title", subtitle: "Game Description", price: nil)),
        .app(App(promotedHeadline: nil, title: "Game Title", subtitle: "Game Description", price: nil)),
        .app(App(promotedHeadline: nil, title: "Game Title", subtitle: "Game Description", price: 6.99)),
        .app(App(promotedHeadline: nil, title: "Game Title", subtitle: "Game Description", price: nil)),
    ]
    
    static let essentialApps: [Item] = [
        .app(App(promotedHeadline: nil, title: "Game Title", subtitle: "Game Description", price: 0.99)),
        .app(App(promotedHeadline: nil, title: "Game Title", subtitle: "Game Description", price: nil)),
        .app(App(promotedHeadline: nil, title: "Game Title", subtitle: "Game Description", price: 3.99)),
        .app(App(promotedHeadline: nil, title: "Game Title", subtitle: "Game Description", price: 0.99)),
        .app(App(promotedHeadline: nil, title: "Game Title", subtitle: "Game Description", price: 4.99)),
        .app(App(promotedHeadline: nil, title: "Game Title", subtitle: "Game Description", price: 0.99)),
        .app(App(promotedHeadline: nil, title: "Game Title", subtitle: "Game Description", price: 0.99)),
    ]

    static let categories: [Item] = [
        .category(StoreCategory(name: "AR Games")),
        .category(StoreCategory(name: "Indie")),
        .category(StoreCategory(name: "Strategy")),
        .category(StoreCategory(name: "Racing")),
        .category(StoreCategory(name: "Puzzle")),
        .category(StoreCategory(name: "Board")),
        .category(StoreCategory(name: "Family")),
    ]
}
