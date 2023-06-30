//
//  MovieListViewController.swift
//  iOSSeriesChallenge
//
//  Created by Gabriel do Prado Moreira on 29/06/23.
//

import UIKit

extension MovieListViewController.Layout {
    enum Spacing {
        static let collectionViewLeadingTrailing: CGFloat = 10
    }
}

class MovieListViewController: UIViewController,  UICollectionViewDataSource, UICollectionViewDelegate {
    
    fileprivate enum Layout { }
    
    let items = ["Item 1", "Item 2", "Item 3", "Item 4", "Item 5", "Item 6", "Item 7", "Item 8", "Item 9", "Item 10"]
    
    let layout = TwoColumnFlowLayout()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.register(MovieListCollectionViewCell.self, forCellWithReuseIdentifier: "MovieListCollectionViewCell")
        collectionView.backgroundColor = .white
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        title = "Movie List"
        
        configureViews()
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func configureViews() {
        view.addSubview(collectionView)
    }
    
    func setupContraints() {
        
    }

    // MARK: - UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieListCollectionViewCell", for: indexPath) as! MovieListCollectionViewCell
        cell.setupCell(title: items[indexPath.item], image: UIImage(named: "imagePlaceholder2"))
        

        return cell
    }
}
