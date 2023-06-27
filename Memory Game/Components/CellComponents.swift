//
//  CellComponents.swift
//  Memory Game
//
//  Created by Didami on 26/06/23.
//

import UIKit

class MemoryCell: UICollectionViewCell {
    
    static let identifier = "memoryCellId"
    
    var memoryCard: MemoryCard? {
        didSet {
            if let memoryCard = memoryCard {
                UIView.transition(with: imageView, duration: 0.25, options: .transitionCrossDissolve) {
                    self.imageView.image = memoryCard.isFlipped ? UIImage(named: memoryCard.imageName) : nil
                }
            }
        }
    }
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.backgroundColor = .secondColor
        iv.layer.masksToBounds = true
        iv.layer.cornerRadius = 12
        iv.contentMode = .scaleAspectFill
        iv.image = nil
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    private func setupViews() {
        backgroundColor = .clear
        
        addSubview(imageView)
        
        imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        imageView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        imageView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
