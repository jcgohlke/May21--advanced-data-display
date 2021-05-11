
import UIKit

class StoreItemCollectionViewController: UICollectionViewController {
    
    @IBOutlet var flowLayout: UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let availableWidth = view.frame.width
        let itemWidth = (availableWidth - (8*4)) / 3
        let itemSize = CGSize(width: itemWidth, height: itemWidth * 2)
        let minimumInterItemSpacing: CGFloat = 8
        let minimumLineSpacing: CGFloat = 12

        flowLayout.itemSize = itemSize

        flowLayout.sectionInset.top = 8
        flowLayout.sectionInset.bottom = 8
        flowLayout.sectionInset.left = 8
        flowLayout.sectionInset.right = 8

        flowLayout.minimumInteritemSpacing = minimumInterItemSpacing
        flowLayout.minimumLineSpacing = minimumLineSpacing
    }
    
}
