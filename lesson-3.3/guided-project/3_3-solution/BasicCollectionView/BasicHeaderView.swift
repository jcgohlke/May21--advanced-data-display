//
//  BasicHeaderView.swift
//  BasicCollectionView
//
//  Created by Joben Gohlke on 5/10/21.
//

import UIKit

class BasicHeaderView: UICollectionReusableView {
  var label = UILabel()
  
  override func layoutSubviews() {
    label.translatesAutoresizingMaskIntoConstraints = false
    addSubview(label)
    
    NSLayoutConstraint.activate([
      label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
      label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
      label.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
      label.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10)
    ])
  }
}
