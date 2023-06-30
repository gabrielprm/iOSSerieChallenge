//
//  TwoColumnFlowLayout.swift
//  iOSSeriesChallenge
//
//  Created by Gabriel do Prado Moreira on 29/06/23.
//

import UIKit

class TwoColumnFlowLayout: UICollectionViewFlowLayout {
    let numberOfColumns = 2
    
    override func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView else { return }
        
        let availableWidth = collectionView.bounds.inset(by: collectionView.layoutMargins).width
        let itemWidth = availableWidth / CGFloat(numberOfColumns)
        let itemSize = CGSize(width: itemWidth-15, height: 300)
        
        self.itemSize = itemSize
        self.minimumInteritemSpacing = 5
        self.minimumLineSpacing = 10
        self.sectionInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        self.collectionView?.backgroundColor = .darkGray
    }
}
