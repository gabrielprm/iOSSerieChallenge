//
//  MovieListCollectionViewCell.swift
//  iOSSeriesChallenge
//
//  Created by Gabriel do Prado Moreira on 29/06/23.
//

import UIKit

class MovieListCollectionViewCell: UICollectionViewCell {
    static let identifier = "MovieListCollectionViewCell"
    
    lazy var movieBackgroundImage: UIImageView = {
        var imageView = UIImageView()
        imageView.image = UIImage(named: "imagePlaceholder")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    lazy var movieTitle: UILabel = {
        let label = UILabel()
        label.text = "Placeholder"
        label.font = .boldSystemFont(ofSize: 14)
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
        contentView.addSubview(movieBackgroundImage)
        contentView.addSubview(movieTitle)
        
        setupContraints()
    }
    
    func setupContraints() {
        NSLayoutConstraint.activate([
            movieBackgroundImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            movieBackgroundImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            movieBackgroundImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -50),
            movieBackgroundImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            movieTitle.topAnchor.constraint(equalTo: movieBackgroundImage.bottomAnchor, constant: 10),
            movieTitle.leadingAnchor.constraint(equalTo: movieBackgroundImage.leadingAnchor),
        ])
    }
    
    func setupCell(title: String?, image: UIImage?) {
        guard
            let title = title,
            let image = image
        else { return }
                
        movieTitle.text = title
        movieBackgroundImage.image = image
    }
}
