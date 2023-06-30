//
//  MovieListCollectionViewCell.swift
//  iOSSeriesChallenge
//
//  Created by Gabriel do Prado Moreira on 29/06/23.
//

import UIKit

class SeriesListCollectionViewCell: UICollectionViewCell {
    static let identifier = "SeriesListCollectionViewCell"
    
    lazy var seriesBackgroundImage: UIImageView = {
        var imageView = UIImageView()
        imageView.image = UIImage(named: "imagePlaceholder")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    lazy var seriesTitle: UILabel = {
        let label = UILabel()
        label.text = "Placeholder"
        label.font = .boldSystemFont(ofSize: 14)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        configureViews()
    }
    
    func configureViews() {
        contentView.addSubview(seriesBackgroundImage)
        contentView.addSubview(seriesTitle)
        
        setupContraints()
    }
    
    func setupContraints() {
        NSLayoutConstraint.activate([
            seriesBackgroundImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            seriesBackgroundImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            seriesBackgroundImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -50),
            seriesBackgroundImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            seriesTitle.topAnchor.constraint(equalTo: seriesBackgroundImage.bottomAnchor, constant: 10),
            seriesTitle.leadingAnchor.constraint(equalTo: seriesBackgroundImage.leadingAnchor),
            seriesTitle.trailingAnchor.constraint(equalTo: seriesBackgroundImage.trailingAnchor, constant: -5)
        ])
    }
    
    func setupCell(title: String?, image: UIImage?) {
        guard
            let title = title,
            let image = image
        else { return }
                
        seriesTitle.text = title
        seriesBackgroundImage.image = image
    }
}
