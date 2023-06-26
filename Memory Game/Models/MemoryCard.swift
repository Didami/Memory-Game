//
//  MemoryCard.swift
//  Memory Game
//
//  Created by Didami on 26/06/23.
//

import UIKit

struct MemoryCard {
    var imageName: String
    var isFlipped: Bool
}

enum Difficulty {
    case easy
    case medium
    case hard
    
    func cardsCount() -> Int {
        switch self {
        case .easy:
            return 6
        case .medium:
            return 18
        case .hard:
            return 24
        }
    }
    
    func cellSize(collectionSize: CGSize, spacing: CGFloat) -> CGSize {
        switch self {
        case .easy:
            return CGSize(width: (collectionSize.width - spacing) / 2, height: (collectionSize.height - spacing * 2) / 3)
        case .medium:
            return CGSize(width: (collectionSize.width - spacing * 2) / 3, height: (collectionSize.height - spacing * 5) / 6)
        case .hard:
            return CGSize(width: (collectionSize.width - spacing * 3) / 4, height: (collectionSize.height - spacing * 5) / 6)
        }
    }
}
