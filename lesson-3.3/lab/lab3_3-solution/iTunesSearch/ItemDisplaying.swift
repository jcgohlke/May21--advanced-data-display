
import UIKit

protocol ItemDisplaying {
    var itemImageView: UIImageView! { get set }
    var titleLabel: UILabel! { get set }
    var detailLabel: UILabel! { get set }
}

extension ItemDisplaying {
    func configure(for item: StoreItem, storeItemController: StoreItemController) {
        titleLabel.text = item.name
        detailLabel.text = item.artist
        itemImageView?.image = UIImage(systemName: "photo")

        storeItemController.fetchImage(from: item.artworkURL) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let image):
                    self.itemImageView.image = image
                case .failure(let error):
                    self.itemImageView.image = UIImage(systemName: "photo")
                    print("Error fetching image: \(error)")
                }
            }
        }
    }
}
