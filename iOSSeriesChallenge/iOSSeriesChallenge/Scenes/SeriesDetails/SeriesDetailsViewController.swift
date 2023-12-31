//
//  MovieListViewController.swift
//  iOSSeriesChallenge
//
//  Created by Gabriel do Prado Moreira on 30/06/23.
//

import UIKit

protocol SeriesDetailsDisplaying: AnyObject {
    func setHeaderData(image: UIImage, title: String, summary: String, genre: String?)
    func presentAllSeasons(model: [SerieSeason])
    func presentAllEpisodesFromSeason(episodes: [Episode])
    func setSchedule(schedule: String?)
    func showLoader()
    func hideLoader()
}

class SeriesDetailsViewController: UIViewController {
    var presenter: SeriesDetailsPresenting
    let maxWordCount = 20
    var isSummaryExpanded = false
    
    var seasons: [SerieSeason] = []
    var episodes: [Episode] = []
    
    var selectedSeason: Int = 0
    var summary: String = ""
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .white
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()
    
    let seriesImage: UIImageView = {
        var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    lazy var seriesTitle: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 28)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var seriesGenre: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 14)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var episodeDate: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 12)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var seriesSummary: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(labelTapped)))
        return label
    }()
    
    lazy var seeMoreButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("See More", for: .normal)
        button.tintColor = UIColor(named: "Cream")
        button.addTarget(self, action: #selector(seeMoreButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var seeLessButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("See Less", for: .normal)
        button.tintColor = UIColor(named: "Cream")
        button.addTarget(self, action: #selector(seeLessButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        return button
    }()
    
    lazy var seasonButton: UIButton = {
        let button = UIButton(type: .system)
        let icon = UIImage(systemName: "chevron.down")
        button.tintColor = UIColor(named: "Cream")
        button.setImage(icon, for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 0)
        button.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        button.titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        button.imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        button.addTarget(self, action: #selector(didTapChangeSeason), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(EpisodesListTableViewCell.self, forCellReuseIdentifier: EpisodesListTableViewCell.identifier)
        tableView.backgroundColor = UIColor(named: "DarkBlue")
        return tableView
    }()
    
    init(presenter: SeriesDetailsPresenting) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        setupConstraints()
        presenter.fetchSeasons()
        presenter.fetchSerieDetails()
        tableView.dataSource = self
        tableView.delegate = self
        view.backgroundColor = UIColor(named: "DarkBlue")
    }
    
    func configureViews() {
        view.addSubview(seriesImage)
        view.addSubview(seriesTitle)
        view.addSubview(seriesSummary)
        view.addSubview(seeMoreButton)
        view.addSubview(seeLessButton)
        view.addSubview(seriesGenre)
        view.addSubview(episodeDate)
        view.addSubview(seasonButton)
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            seriesImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            seriesImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            seriesImage.heightAnchor.constraint(equalToConstant: 180),
            seriesImage.widthAnchor.constraint(equalToConstant: 122),
            
            seriesTitle.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            seriesTitle.topAnchor.constraint(equalTo: seriesImage.bottomAnchor, constant: 20),
            seriesTitle.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            
            seriesSummary.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            seriesSummary.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            seriesSummary.topAnchor.constraint(equalTo: seriesTitle.bottomAnchor, constant: 5),
            
            seeMoreButton.topAnchor.constraint(equalTo: seriesSummary.bottomAnchor, constant: 10),
            seeMoreButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            seeLessButton.topAnchor.constraint(equalTo: seriesSummary.bottomAnchor, constant: 10),
            seeLessButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            seriesGenre.topAnchor.constraint(equalTo: seeMoreButton.bottomAnchor, constant: 10),
            seriesGenre.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            episodeDate.topAnchor.constraint(equalTo: seriesGenre.bottomAnchor, constant: 10),
            episodeDate.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            seasonButton.topAnchor.constraint(equalTo: episodeDate.bottomAnchor, constant: 20),
            seasonButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
        
            tableView.topAnchor.constraint(equalTo: seasonButton.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    @objc func labelTapped() {
        if isSummaryExpanded {
            seeLessButtonTapped()
        } else {
            seeMoreButtonTapped()
        }
    }
    
    @objc func seeMoreButtonTapped() {
        isSummaryExpanded = true
        updateContentLabel(with: summary)
        seeMoreButton.isHidden = true
        seeLessButton.isHidden = false
    }
    
    @objc func seeLessButtonTapped() {
        isSummaryExpanded = false
        updateContentLabel(with: summary)
        seeMoreButton.isHidden = false
        seeLessButton.isHidden = true
    }
    
    @objc func didTapChangeSeason() {
        presenter.presentSeasonsSelectionView(seasons: seasons, delegate: self)
    }
    
    func updateContentLabel(with text: String) {
        if text.isEmpty {
            seriesSummary.isHidden = true
            seeMoreButton.isHidden = true
            seeLessButton.isHidden = true
            return
        }
        
        let wordCount = text.components(separatedBy: .whitespacesAndNewlines).count
        let clippedText = isSummaryExpanded ? text : clipText(text, to: maxWordCount)
        
        let attributedString = NSMutableAttributedString(string: clippedText)
        attributedString.addAttribute(.foregroundColor, value: UIColor.white, range: NSRange(location: 0, length: clippedText.count))
        attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 14), range: NSRange(location: 0, length: clippedText.count))
        
        if !isSummaryExpanded && wordCount > maxWordCount {
            attributedString.append(NSAttributedString(string: "... "))
            attributedString.append(seeMoreButton.attributedTitle(for: .normal) ?? NSAttributedString())
        }
        
        seriesSummary.attributedText = attributedString
    }
    
    func clipText(_ text: String, to wordCount: Int) -> String {
        let words = text.components(separatedBy: .whitespacesAndNewlines)
        let clippedWords = Array(words.prefix(wordCount))
        return clippedWords.joined(separator: " ")
    }
    
    func updateButtonTitle(season: Int) {
        DispatchQueue.main.async { [weak self] in
            self?.seasonButton.setTitle("Season \(season)", for: .normal)
        }
    }
}

extension SeriesDetailsViewController: SeriesDetailsDisplaying {
    func setHeaderData(image: UIImage, title: String, summary: String, genre: String?) {
        self.summary = summary
        DispatchQueue.main.async { [weak self] in
            self?.seriesImage.image = image
            self?.seriesTitle.text = title
            self?.updateContentLabel(with: summary)
            if let genre = genre {
                self?.seriesGenre.text = genre
            }
        }
    }
    
    func presentAllSeasons(model: [SerieSeason]) {
        self.seasons = model
        self.selectedSeason = model[0].id
        updateButtonTitle(season: model[0].number)
        presenter.fetchEpisodes(seasonID: selectedSeason)
    }
    
    func presentAllEpisodesFromSeason(episodes: [Episode]) {
        self.episodes = episodes
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    func setSchedule(schedule: String?) {
        if let schedule = schedule {
            DispatchQueue.main.async { [weak self] in
                self?.episodeDate.text = schedule
            }
        }
    }
    
    func showLoader() {
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicator.startAnimating()
            self?.view.isUserInteractionEnabled = false
        }
    }
    
    func hideLoader() {
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicator.stopAnimating()
            self?.view.isUserInteractionEnabled = true        
        }
    }
}

extension SeriesDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        episodes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EpisodesListTableViewCell.identifier, for: indexPath) as! EpisodesListTableViewCell
        
        cell.setupCell(icon: UIImage(named: "imagePlaceholder")!, episodeName: episodes[indexPath.row].name)
        
        presenter.downloadImage(url: episodes[indexPath.row].image?.imageUrl ?? "") { [weak self] image in
            if let image = image {
                cell.setupCell(icon: image, episodeName: self?.episodes[indexPath.row].name ?? "")
            }
        }
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.presentEpisodeDetails(episode: episodes[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension SeriesDetailsViewController: SeasonSelectionDelegate {
    func selectSeason(season: SerieSeason) {
        selectedSeason = season.id
        updateButtonTitle(season: season.number)
        presenter.fetchEpisodes(seasonID: season.id)
    }
}
