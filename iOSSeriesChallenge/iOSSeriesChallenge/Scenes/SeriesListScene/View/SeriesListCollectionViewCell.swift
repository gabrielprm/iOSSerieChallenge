//
//  SeriesListCollectionViewCell.swift
//  iOSSeriesChallenge
//
//  Created by Gabriel do Prado Moreira on 29/06/23.
//

import UIKit

final class SeriesListCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Static Properties
    
    static let identifier = "SeriesListCollectionViewCell"
    
    // MARK: - Constants
    
    private enum Constants {
        static let cornerRadius: CGFloat = 10
        static let titleFontSize: CGFloat = 14
        static let bottomSpacing: CGFloat = 50
        static let titleTopPadding: CGFloat = 10
        static let titleTrailingPadding: CGFloat = 5
    }
    
    // MARK: - UI Components
    
    private lazy var seriesBackgroundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "imagePlaceholder")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = Constants.cornerRadius
        return imageView
    }()
    
    private lazy var seriesTitle: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: Constants.titleFontSize)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        seriesBackgroundImage.image = UIImage(named: "imagePlaceholder")
        seriesTitle.text = nil
    }
    
    // MARK: - Configuration
    
    private func configureViews() {
        contentView.addSubview(seriesBackgroundImage)
        contentView.addSubview(seriesTitle)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            seriesBackgroundImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            seriesBackgroundImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            seriesBackgroundImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.bottomSpacing),
            seriesBackgroundImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            seriesTitle.topAnchor.constraint(equalTo: seriesBackgroundImage.bottomAnchor, constant: Constants.titleTopPadding),
            seriesTitle.leadingAnchor.constraint(equalTo: seriesBackgroundImage.leadingAnchor),
            seriesTitle.trailingAnchor.constraint(equalTo: seriesBackgroundImage.trailingAnchor, constant: -Constants.titleTrailingPadding)
        ])
    }
    
    // MARK: - Public Methods
    
    func setupCell(title: String?, image: UIImage?) {
        DispatchQueue.main.async { [weak self] in
            self?.seriesTitle.text = title
            self?.seriesBackgroundImage.image = image
        }
    }
}
