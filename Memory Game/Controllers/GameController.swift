//
//  GameController.swift
//  Memory Game
//
//  Created by Didami on 26/06/23.
//

import UIKit

class GameController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    let timerLabel = CardLabel()
    let pairsLabel = CardLabel()
    lazy var bottomContainer: UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = .secondColor
        
        container.addSubview(timerLabel)
        container.addSubview(pairsLabel)
        
        timerLabel.leftAnchor.constraint(equalTo: container.leftAnchor, constant: Constants.safeSpacing).isActive = true
        timerLabel.rightAnchor.constraint(equalTo: container.centerXAnchor, constant: -Constants.safeSpacing/2).isActive = true
        timerLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: Constants.safeSpacing).isActive = true
        timerLabel.bottomAnchor.constraint(equalTo: container.safeAreaLayoutGuide.bottomAnchor, constant: -Constants.safeSpacing).isActive = true
        
        pairsLabel.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -Constants.safeSpacing).isActive = true
        pairsLabel.leftAnchor.constraint(equalTo: container.centerXAnchor, constant: Constants.safeSpacing/2).isActive = true
        pairsLabel.topAnchor.constraint(equalTo: timerLabel.topAnchor).isActive = true
        pairsLabel.bottomAnchor.constraint(equalTo: timerLabel.bottomAnchor).isActive = true
        
        return container
    }()
    
    let spacing: CGFloat = 8
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .clear
        cv.isScrollEnabled = false
        
        cv.delegate = self
        cv.dataSource = self
        cv.register(MemoryCell.self, forCellWithReuseIdentifier: MemoryCell.identifier)
        
        return cv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        startGame(at: .easy)
    }
    
    private func setupViews() {
        view.backgroundColor = .mainColor
        
        // add subviews
        view.addSubview(bottomContainer)
        view.addSubview(collectionView)
        
        // x, y, w, h
        bottomContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        bottomContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        bottomContainer.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        bottomContainer.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.standardSpacing).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: bottomContainer.topAnchor, constant: -Constants.standardSpacing).isActive = true
        collectionView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -Constants.doubleSpacing).isActive = true
    }
    
    var difficulty = Difficulty.easy
    var memoryCards = [MemoryCard]()
    var lastFlippedCard: MemoryCard?
    var lastFlippedIndexPath: IndexPath?
    
    var matchedPairs = 0
    
    var timer: Timer?
    var secondsRemaining = 60
    
    private func startGame(at difficulty: Difficulty) {
        self.difficulty = difficulty
        matchedPairs = 0
        secondsRemaining = difficulty == .easy ? 20 : difficulty == .medium ? 60 : 120
        memoryCards.removeAll()
        for imgName in cardImages.shuffled().prefix(difficulty.cardsCount()/2) {
            memoryCards.append(MemoryCard(imageName: imgName, isFlipped: false))
        }
        
        memoryCards.append(contentsOf: memoryCards)
        memoryCards.shuffle()
        
        collectionView.reloadData()
        timerLabel.label.text = "01:00"
        pairsLabel.label.text = "PAIRS: \(matchedPairs)/\(difficulty.cardsCount()/2)"
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc private func updateTimer() {
        if secondsRemaining > 0 {
            secondsRemaining -= 1
            updateTimerLabel()
        } else {
            timer?.invalidate()
            let alert = UIAlertController(title: "Oh oh", message: "You lost :(", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "New game", style: .cancel, handler: { _ in
                self.startGame(at: .easy)
            }))
            present(alert, animated: true)
        }
    }
    
    private func updateTimerLabel() {
        let minutes = secondsRemaining / 60
        let seconds = secondsRemaining % 60
        timerLabel.label.text = String(format: "%02d:%02d", minutes, seconds)
    }
    
    // MARK: - Delegate methods
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return difficulty.cardsCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return difficulty.cellSize(collectionSize: collectionView.frame.size, spacing: spacing)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MemoryCell.identifier, for: indexPath) as? MemoryCell else { return UICollectionViewCell() }
        cell.memoryCard = memoryCards[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let card = memoryCards[indexPath.item]
        if card.isFlipped == true || lastFlippedIndexPath == indexPath {
            return
        }
        
        if let cell = collectionView.cellForItem(at: indexPath) as? MemoryCell {
            cell.memoryCard?.isFlipped = true
            
            if let lastCard = lastFlippedCard, let lastIndex = lastFlippedIndexPath, let lastCell = collectionView.cellForItem(at: lastIndex) as? MemoryCell {
                
                if lastCard.imageName != card.imageName {
                    collectionView.isUserInteractionEnabled = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        cell.memoryCard?.isFlipped = false
                        lastCell.memoryCard?.isFlipped = false
                        collectionView.isUserInteractionEnabled = true
                    }
                } else {
                    memoryCards[lastIndex.item].isFlipped = true
                    memoryCards[indexPath.item].isFlipped = true
                    
                    matchedPairs += 1
                    pairsLabel.label.text = "PAIRS: \(matchedPairs)/\(difficulty.cardsCount()/2)"
                }
                
                lastFlippedCard = nil
                lastFlippedIndexPath = nil
                
            } else {
                lastFlippedCard = card
                lastFlippedIndexPath = indexPath
            }
            
            if memoryCards.allSatisfy({ $0.isFlipped }) {
                let alert = UIAlertController(title: "WOW", message: "YOU WON", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "got it", style: .cancel, handler: { _ in
                    let newDifficulty: Difficulty = self.difficulty == .easy ? .medium : .hard
                    self.startGame(at: newDifficulty)
                }))
                present(alert, animated: true)
            }
        }
    }
}
