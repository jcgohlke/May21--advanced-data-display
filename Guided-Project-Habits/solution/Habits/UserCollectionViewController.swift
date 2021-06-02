//
// UserCollectionViewController.swift
// Habits
//


import UIKit

private let reuseIdentifier = "Cell"

class UserCollectionViewController: UICollectionViewController {
    
    typealias DataSourceType = UICollectionViewDiffableDataSource<ViewModel.Section, ViewModel.Item>

    enum ViewModel {
        typealias Section = Int

        struct Item: Hashable {
            let user: User
            let isFollowed: Bool
        }
    }

    struct Model {
        var usersByID = [String:User]()
        var followedUsers: [User] {
            return Array(usersByID.filter { Settings.shared.followedUserIDs.contains($0.key) }.values)
        }
    }

    var dataSource: DataSourceType!
    var model = Model()

    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource = createDataSource()
        collectionView.dataSource = dataSource
        collectionView.collectionViewLayout = createLayout()

        update()
    }
    
    func createDataSource() -> DataSourceType {
        let dataSource = DataSourceType(collectionView: collectionView) { (collectionView, indexPath, item) in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "User", for: indexPath) as! PrimarySecondaryTextCollectionViewCell

            cell.primaryTextLabel.text = item.user.name
            cell.contentView.backgroundColor = item.user.color?.uiColor ?? UIColor.systemGray4
            cell.layer.cornerRadius = 8

            return cell
        }

        return dataSource
    }

    func createLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalHeight(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.45))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        group.interItemSpacing = .fixed(20)

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 20
        section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)

        return UICollectionViewCompositionalLayout(section: section)
    }

    func update() {
        UserRequest().send { result in
            switch result {
            case .success(let users):
                self.model.usersByID = users
            case .failure:
                self.model.usersByID = [:]
            }

            DispatchQueue.main.async {
                self.updateCollectionView()
            }
        }
    }

    func updateCollectionView() {
        let users = model.usersByID.values.sorted().reduce(into: [ViewModel.Item]()) { partial, user in
            partial.append(ViewModel.Item(user: user, isFollowed: model.followedUsers.contains(user)))
        }

        let itemsBySection = [0: users]

        dataSource.applySnapshotUsing(sectionIDs: [0], itemsBySection: itemsBySection)
    }

    @IBSegueAction func showUserDetail(_ coder: NSCoder, sender: UICollectionViewCell?) -> UserDetailViewController? {
        guard let cell = sender,
            let indexPath = collectionView.indexPath(for: cell),
            let item = dataSource.itemIdentifier(for: indexPath) else {
            return nil
        }

        return UserDetailViewController(coder: coder, user: item.user)
    }
    
    override func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let config = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { (elements) -> UIMenu? in
            guard let item = self.dataSource.itemIdentifier(for: indexPath) else { return nil }

            let favoriteToggle = UIAction(title: item.isFollowed ? "Unfollow" : "Follow") { (action) in
                Settings.shared.toggleFollowed(user: item.user)
                self.updateCollectionView()
            }

            return UIMenu(title: "", image: nil, identifier: nil, options: [], children: [favoriteToggle])
        }

        return config
    }

}
