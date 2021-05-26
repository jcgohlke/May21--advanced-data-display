
import UIKit

class StoreItemContainerViewController: UIViewController, UISearchResultsUpdating {
    
    @IBOutlet var tableContainerView: UIView!
    @IBOutlet var collectionContainerView: UIView!
    weak var collectionViewController: StoreItemCollectionViewController?
    
    let searchController = UISearchController()
    let storeItemController = StoreItemController()

    var tableViewDataSource: StoreItemTableViewDiffableDataSource!
    var collectionViewDataSource: UICollectionViewDiffableDataSource<String, StoreItem>!
    var snapshot = NSDiffableDataSourceSnapshot<String, StoreItem>()
    
    var selectedSearchScope: SearchScope {
        let selectedIndex = searchController.searchBar.selectedScopeButtonIndex
        let searchScope = SearchScope.allCases[selectedIndex]
        
        return searchScope
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.automaticallyShowsSearchResultsController = true
        searchController.searchBar.showsScopeBar = true
        searchController.searchBar.scopeButtonTitles = SearchScope.allCases.map { $0.title }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let tableViewController = segue.destination as? StoreItemListTableViewController {
            tableViewDataSource = StoreItemTableViewDiffableDataSource(tableView: tableViewController.tableView, storeItemController: storeItemController)
        }
        
        if let collectionViewController = segue.destination as? StoreItemCollectionViewController {
            collectionViewDataSource = StoreItemCollectionViewDiffableDataSource(collectionView: collectionViewController.collectionView, storeItemController: storeItemController)
            collectionViewController.configureCollectionViewLayout(for: selectedSearchScope)
            
            self.collectionViewController = collectionViewController
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(fetchMatchingItems), object: nil)
        perform(#selector(fetchMatchingItems), with: nil, afterDelay: 0.3)
    }
                
    @IBAction func switchContainerView(_ sender: UISegmentedControl) {
        tableContainerView.isHidden.toggle()
        collectionContainerView.isHidden.toggle()
    }
    
    @objc func fetchMatchingItems() {
        // clear data sources
        snapshot.deleteAllItems()
        tableViewDataSource.apply(snapshot, animatingDifferences: true, completion: nil)
        collectionViewDataSource.apply(snapshot, animatingDifferences: true, completion: nil)
        
        let searchTerm = searchController.searchBar.text ?? ""
        guard searchTerm.isEmpty == false else {
            return
        }
        
        let searchScopes: [SearchScope]
        if selectedSearchScope == .all {
            searchScopes = [.movies, .music, .apps, .books]
        } else {
            searchScopes = [selectedSearchScope]
        }
        
        for searchScope in searchScopes {
            // set up query dictionary
            let query = [
                "term": searchTerm,
                "media": searchScope.mediaType,
                "lang": "en_us",
                "limit": "50"
            ]
            
            storeItemController.fetchItems(matching: query) { (result) in
                DispatchQueue.main.async {
                    guard searchTerm == self.searchController.searchBar.text else {
                        return
                    }
                    
                    switch result {
                    case .success(let items):
                        self.handleFetchedItems(items)
                    case .failure(let error):
                        // otherwise, print an error to the console
                        print(error)
                    }
                }
            }
        }
    }
    
    func handleFetchedItems(_ items: [StoreItem]) {
        let currentSnapshotItems = snapshot.itemIdentifiers
        let updatedSnapshot = createSectionedSnapshot(from: currentSnapshotItems + items)
        snapshot = updatedSnapshot
        tableViewDataSource.apply(snapshot, animatingDifferences: true, completion: nil)
        collectionViewDataSource.apply(snapshot, animatingDifferences: true, completion: nil)
        
        collectionViewController?.configureCollectionViewLayout(for: selectedSearchScope)
    }
    
    func createSectionedSnapshot(from items: [StoreItem]) -> NSDiffableDataSourceSnapshot<String, StoreItem> {
        
        let movies = items.filter { $0.kind == "feature-movie" }
        let music = items.filter { $0.kind == "song" || $0.kind == "album" }
        let apps = items.filter { $0.kind == "software" }
        let books = items.filter { $0.kind == "ebook" }
        
        
        let grouped: [(SearchScope, [StoreItem])] = [
            (.movies, movies),
            (.music, music),
            (.apps, apps),
            (.books, books)
        ]
        
        var snapshot = NSDiffableDataSourceSnapshot<String, StoreItem>()
        grouped.forEach { (scope, items) in
            if items.count > 0 {
                snapshot.appendSections([scope.title])
                snapshot.appendItems(items, toSection: scope.title)
            }
        }
        
        return snapshot
    }
    
}
