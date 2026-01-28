//
//  EpisodesListTableViewCell.swift
//  iOSSeriesChallenge
//
//  Created by Gabriel do Prado Moreira on 01/07/23.
//

import UIKit

final class EpisodesListTableViewCell: UITableViewCell {
    
    // MARK: - Static Properties
    
    static let identifier = "EpisodesListCell"
    
    // MARK: - Constants
    
    private enum Constants {
        static let cornerRadius: CGFloat = 10
        static let iconHeight: CGFloat = 72
        static let iconWidth: CGFloat = 128
        static let verticalPadding: CGFloat = 10
        static let horizontalPadding: CGFloat = 20
        static let fontSize: CGFloat = 14
    }
    
    // MARK: - UI Components
    
    private lazy var iconView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = Constants.cornerRadius
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var episodeNameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: Constants.fontSize)
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 0
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconView.image = UIImage(named: "imagePlaceholder")
        episodeNameLabel.text = nil
    }
    
    // MARK: - Configuration
    
    private func configureViews() {
        contentView.addSubview(iconView)
        contentView.addSubview(episodeNameLabel)
        contentView.backgroundColor = UIColor(named: "DarkBlue")
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            iconView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.verticalPadding),
            iconView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.verticalPadding),
            iconView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            iconView.heightAnchor.constraint(equalToConstant: Constants.iconHeight),
            iconView.widthAnchor.constraint(equalToConstant: Constants.iconWidth),
            
            episodeNameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            episodeNameLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: Constants.horizontalPadding),
            episodeNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.horizontalPadding)
        ])
    }
    
    // MARK: - Public Methods
    
    func setupCell(icon: UIImage, episodeName: String) {
        DispatchQueue.main.async { [weak self] in
            self?.iconView.image = icon
            self?.episodeNameLabel.text = episodeName
        }
    }
}
