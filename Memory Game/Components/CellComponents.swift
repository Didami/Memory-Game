//
//  CellComponents.swift
//  Memory Game
//
//  Created by Didami on 26/06/23.
//

import UIKit

class MemoryCell: UICollectionViewCell {
    
    static let identifier = "memoryCellId"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
