//
//  TwoColumnFlowLayout.swift
//  iOSSeriesChallenge
//
//  Created by Gabriel do Prado Moreira on 29/06/23.
//

import UIKit

final class TwoColumnFlowLayout: UICollectionViewFlowLayout {
    
    // MARK: - Constants
    
    private enum Constants {
        static let numberOfColumns: CGFloat = 2
        static let itemWidth: CGFloat = 15
        static let itemHeight: CGFloat = 300
        static let interitemSpacing: CGFloat = 5
        static let lineSpacing: CGFloat = 10
        static let horizontalInset: CGFloat = 15
    }
    
    // MARK: - Lifecycle
    
    override func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView else { return }
        
        let availableWidth = collectionView.bounds.inset(by: collectionView.layoutMargins).width
        let itemWidth = (availableWidth / Constants.numberOfColumns) - Constants.itemWidth
        
        self.itemSize = CGSize(width: itemWidth, height: Constants.itemHeight)
        self.minimumInteritemSpacing = Constants.interitemSpacing
        self.minimumLineSpacing = Constants.lineSpacing
        self.sectionInset = UIEdgeInsets(
            top: 0,
            left: Constants.horizontalInset,
            bottom: 0,
            right: Constants.horizontalInset
        )
        self.collectionView?.backgroundColor = UIColor(named: "DarkBlue")
    }
}
