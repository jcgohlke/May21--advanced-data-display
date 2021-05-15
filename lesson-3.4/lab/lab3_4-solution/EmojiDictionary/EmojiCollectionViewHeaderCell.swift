// EmojiDictionary

import UIKit

class EmojiCollectionViewHeader: UICollectionReusableView {
    let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        let effect = UIVisualEffectView(effect: UIBlurEffect(style: .prominent))
        
        effect.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(effect)
        
        NSLayoutConstraint.activate([
            effect.topAnchor.constraint(equalTo: self.topAnchor),
            effect.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            effect.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            effect.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
        
        effect.contentView.addSubview(titleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = .preferredFont(forTextStyle: .headline)
        
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: titleLabel.superview!.centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: titleLabel.superview!.centerXAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
