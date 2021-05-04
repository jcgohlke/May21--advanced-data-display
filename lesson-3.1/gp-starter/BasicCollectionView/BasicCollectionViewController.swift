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
  }
  
  // MARK: UICollectionView Data Source
  
  override func numberOfSections(in collectionView: UICollectionView) -> Int {
    // #warning Incomplete implementation, return the number of sections
    return 1
  }
  
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of items
    return 1
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    
    // Configure the cell
    
    return cell
  }
}
