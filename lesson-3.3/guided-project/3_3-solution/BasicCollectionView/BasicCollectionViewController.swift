//
//  BasicCollectionViewController.swift
//  BasicCollectionView
//
//  Created by Joben Gohlke on 4/1/21.
//

import UIKit

private let reuseIdentifier = "Cell"

class BasicCollectionViewController: UICollectionViewController {
  
  private let searchController = UISearchController()
  
  private var itemsByInitialLetter = [Character: [String]]()
  private var initialLetters = [Character]()
  private let states: [String] = [
    "Alabama", "Alaska", "Arizona", "Arkansas", "California", "Colorado", "Connecticut", "Delaware",
    "Florida","Georgia", "Hawaii", "Idaho", "Illinois", "Indiana", "Iowa", "Kansas", "Kentucky",
    "Louisiana", "Maine", "Maryland", "Massachusetts", "Michigan", "Minnesota", "Mississippi",
    "Missouri", "Montana", "Nebraska", "Nevada", "New Hampshire", "New Jersey", "New Mexico",
    "New York", "North Carolina", "North Dakota", "Ohio", "Oklahoma", "Oregon", "Pennsylvania",
    "Rhode Island", "South Carolina", "South Dakota", "Tennessee", "Texas", "Utah", "Vermont",
    "Virginia", "Washington", "West Virginia", "Wisconsin", "Wyoming"
  ]
  private lazy var filteredItems: [String] = states
  
  private var dataSource: UICollectionViewDiffableDataSource<Character, String>!
  
  static let sectionHeaderElementKind = "section-header-element-kind"
  
  var filteredItemsSnapshot: NSDiffableDataSourceSnapshot<Character, String> {
    var snapshot = NSDiffableDataSourceSnapshot<Character, String>()
    
    for section in initialLetters {
      snapshot.appendSections([section])
      snapshot.appendItems(itemsByInitialLetter[section]!)
    }
    
    return snapshot
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    collectionView.setCollectionViewLayout(generateLayout(), animated: false)
    collectionView.register(
      BasicHeaderView.self,
      forSupplementaryViewOfKind: BasicCollectionViewController.sectionHeaderElementKind,
      withReuseIdentifier: "Header"
    )
    navigationItem.title = "U.S. States"
    
    itemsByInitialLetter = states.reduce([:]) { existing, element in
      return existing.merging([element.first!:[element]]) { old, new in
        return old + new
      }
    }
    initialLetters = itemsByInitialLetter.keys.sorted()
    
    navigationItem.searchController = searchController
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.searchResultsUpdater = self
    
    createDataSource()
  }
  
  private func generateLayout() -> UICollectionViewLayout {
    let spacing: CGFloat = 10
    
    // Item definition
    let itemSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1.0),
      heightDimension: .fractionalHeight(1.0)
    )
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    
    // Group definition
    let groupSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1.0),
      heightDimension: .absolute(70.0)
    )
    let group = NSCollectionLayoutGroup.horizontal(
      layoutSize: groupSize,
      subitem: item,
      count: 1
    )
    group.contentInsets = NSDirectionalEdgeInsets(
      top: spacing,
      leading: 0,
      bottom: 0,
      trailing: 0
    )
    
    // Section and layout definition
    let section = NSCollectionLayoutSection(group: group)
    section.contentInsets = NSDirectionalEdgeInsets(
      top: spacing,
      leading: spacing,
      bottom: spacing,
      trailing: spacing
    )

    let headerSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1.0),
      heightDimension: .estimated(44)
    )
    let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
      layoutSize: headerSize,
      elementKind: BasicCollectionViewController.sectionHeaderElementKind,
      alignment: .top)
    section.boundarySupplementaryItems = [sectionHeader]
    
    let layout = UICollectionViewCompositionalLayout(section: section)
    
    return layout
  }
  
  private func createDataSource() {
    dataSource = UICollectionViewDiffableDataSource<Character, String>(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! BasicCollectionViewCell
      
      cell.label.text = item
      return cell
    })
    
    dataSource.supplementaryViewProvider = { collectionView, kind, indexPath -> UICollectionReusableView? in
      let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath) as! BasicHeaderView
      header.label.text = String(self.initialLetters[indexPath.section])
      return header
    }
    
    dataSource.apply(filteredItemsSnapshot)
  }
  
  // MARK: UICollectionViewDataSource
  
//  override func numberOfSections(in collectionView: UICollectionView) -> Int {
//    return initialLetters.count
//  }
//
//  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//    return itemsByInitialLetter[initialLetters[section]]?.count ?? 0
//  }
//
//  override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//    let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath) as! BasicHeaderView
//
//    header.label.text = String(self.initialLetters[indexPath.section])
//
//    return header
//  }
//
//  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! BasicCollectionViewCell
//
//    cell.label.text = itemsByInitialLetter[initialLetters[indexPath.section]]?[indexPath.item]
//
//    return cell
//  }
}

extension BasicCollectionViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    if let searchString = searchController.searchBar.text,
       searchString.isEmpty == false {
      filteredItems = states.filter { item -> Bool in
        item.localizedCaseInsensitiveContains(searchString)
      }
    } else {
      filteredItems = states
    }
    
    itemsByInitialLetter = filteredItems.reduce([:]) { existing, element in
      return existing.merging([element.first!:[element]]) { old, new in
        return old + new
      }
    }
    initialLetters = itemsByInitialLetter.keys.sorted()
    
//    collectionView.reloadData()
    dataSource.apply(filteredItemsSnapshot, animatingDifferences: true)
  }
}
