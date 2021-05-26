
import UIKit

class StoreItemCollectionViewDiffableDataSource: UICollectionViewDiffableDataSource<String, StoreItem> {
    init(collectionView: UICollectionView, storeItemController: StoreItemController) {
        super.init(collectionView: collectionView) { collectionView, indexPath, item -> UICollectionViewCell? in
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Item", for: indexPath) as! ItemCollectionViewCell
            cell.configure(for: item, storeItemController: storeItemController)
            
            return cell
        }
        
        supplementaryViewProvider = { collectionView, kind, indexPath -> UICollectionReusableView? in
            
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: "Header", withReuseIdentifier: StoreItemCollectionViewSectionHeader.reuseIdentifier, for: indexPath) as! StoreItemCollectionViewSectionHeader
            
            let title = self.snapshot().sectionIdentifiers[indexPath.section]
            headerView.setTitle(title)
            
            return headerView
        }
    }
}

