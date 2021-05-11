
import UIKit

class ViewController: UIViewController {
        
    // MARK: Section Definitions
    enum Section: Hashable {
        case promoted
        case standard(String)
        case categories
    }

    @IBOutlet var collectionView: UICollectionView!
    
    var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
    
    var sections = [Section]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: Collection View Setup
        collectionView.collectionViewLayout = createLayout()
                
        configureDataSource()
    }
    
    func createLayout() -> UICollectionViewLayout {
        fatalError("TODO: Create Layout")
    }
    
    func configureDataSource() {
        fatalError("TODO: Create Data Source")
    }
}

