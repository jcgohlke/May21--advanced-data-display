//
//  BasicCollectionViewController.swift
//  BasicCollectionView
//
//  Created by Ben Gohlke on 5/3/21.
//

import UIKit

private let reuseIdentifier = "Cell"

private let sectionedStates: [[String]] = [
    ["Alabama", "Alaska", "Arizona", "Arkansas"],
    ["California", "Colorado", "Connecticut"],
    ["Delaware"],
    ["Florida"],
    ["Georgia"],
    ["Hawaii"],
    ["Idaho", "Illinois", "Indiana", "Iowa"],
    ["Kansas", "Kentucky"],
    ["Louisiana"],
    ["Maine", "Maryland", "Massachusetts", "Michigan", "Minnesota", "Mississippi", "Missouri", "Montana"],
    ["Nebraska", "Nevada", "New Hampshire", "New Jersey", "New Mexico", "New York", "North Carolina", "North Dakota"],
    ["Ohio", "Oklahoma", "Oregon"],
    ["Pennsylvania"],
    ["Rhode Island"],
    ["South Carolina", "South Dakota"],
    ["Tennessee", "Texas"],
    ["Utah"],
    ["Vermont", "Virginia"],
    ["Washington", "West Virginia", "Wisconsin", "Wyoming"]
]

private let states: [String] = [
  "Alabama", "Alaska", "Arizona", "Arkansas", "California", "Colorado", "Connecticut", "Delaware",
  "Florida","Georgia", "Hawaii", "Idaho", "Illinois", "Indiana", "Iowa", "Kansas", "Kentucky",
  "Louisiana", "Maine", "Maryland", "Massachusetts", "Michigan", "Minnesota", "Mississippi",
  "Missouri", "Montana", "Nebraska", "Nevada", "New Hampshire", "New Jersey", "New Mexico",
  "New York", "North Carolina", "North Dakota", "Ohio", "Oklahoma", "Oregon", "Pennsylvania",
  "Rhode Island", "South Carolina", "South Dakota", "Tennessee", "Texas", "Utah", "Vermont",
  "Virginia", "Washington", "West Virginia", "Wisconsin", "Wyoming"
]

class BasicCollectionViewController: UICollectionViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    collectionView.setCollectionViewLayout(generateLayout(), animated: false)
  }
  
  // MARK: Collection View Layout
  
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
      count: 1)
    group.contentInsets = NSDirectionalEdgeInsets(
      top: spacing,
      leading: 0,
      bottom: 0,
      trailing: 0
    )
    
    let section = NSCollectionLayoutSection(group: group)
    section.contentInsets = NSDirectionalEdgeInsets(
      top: spacing,
      leading: spacing,
      bottom: spacing,
      trailing: spacing
    )
    
    let layout = UICollectionViewCompositionalLayout(section: section)
    
    return layout
  }
  
  // MARK: UICollectionView Data Source
  
  override func numberOfSections(in collectionView: UICollectionView) -> Int {
    // #warning Incomplete implementation, return the number of sections
    return sectionedStates.count
  }
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of items
    return sectionedStates[section].count
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! BasicCollectionViewCell
    
    // Configure the cell
    cell.label.text = sectionedStates[indexPath.section][indexPath.item]
    
    return cell
  }
}
