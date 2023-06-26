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
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        
        cv.delegate = self
        cv.dataSource = self
        cv.register(MemoryCell.self, forCellWithReuseIdentifier: MemoryCell.identifier)
        cv.backgroundColor = .clear
        
        return cv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
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
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: bottomContainer.topAnchor).isActive = true
        collectionView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    }
    
    // MARK: - Delegate methods
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MemoryCell.identifier, for: indexPath) as? MemoryCell else { return UICollectionViewCell() }
        cell.backgroundColor = .secondColor
        return cell
    }
}
