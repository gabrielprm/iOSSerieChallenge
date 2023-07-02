//
//  EpisodesListTableViewCell.swift
//  iOSSeriesChallenge
//
//  Created by Gabriel do Prado Moreira on 01/07/23.
//

import UIKit

class EpisodesListTableViewCell: UITableViewCell {
    static let identifier = "EpisodesListCell"
    
    lazy var iconView: UIImageView = {
        var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    lazy var episodeNameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 14)
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 0
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureViews() {
        contentView.addSubview(iconView)
        contentView.addSubview(episodeNameLabel)
        contentView.backgroundColor = .darkGray
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            iconView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            iconView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            iconView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            iconView.heightAnchor.constraint(equalToConstant: 72),
            iconView.widthAnchor.constraint(equalToConstant: 128),
            
            episodeNameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            episodeNameLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 20),
            episodeNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
    }
    
    func setupCell(icon: UIImage, episodeName: String) {
        DispatchQueue.main.async {
            self.iconView.image = icon
            self.episodeNameLabel.text = episodeName
        }
    }
}
