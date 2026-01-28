//
//  SeriesDetailsViewController.swift
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

final class SeriesDetailsViewController: UIViewController {
    
    // MARK: - Constants
    
    private enum Constants {
        static let maxWordCount = 20
        static let imageHeight: CGFloat = 180
        static let imageWidth: CGFloat = 122
        static let topPadding: CGFloat = 20
        static let horizontalPadding: CGFloat = 20
        static let titleFontSize: CGFloat = 28
        static let genreFontSize: CGFloat = 14
        static let scheduleFontSize: CGFloat = 12
        static let summaryFontSize: CGFloat = 14
        static let cornerRadius: CGFloat = 10
    }
    
    // MARK: - Properties
    
    private let presenter: SeriesDetailsPresenting
    private var isSummaryExpanded = false
    private var seasons: [SerieSeason] = []
    private var episodes: [Episode] = []
    private var selectedSeason: Int = 0
    private var summary: String = ""
    
    // MARK: - UI Components
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .white
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()
    
    private let seriesImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = Constants.cornerRadius
        imageView.contentMode = .scaleAspectFill
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
    
    private lazy var seriesGenre: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: Constants.genreFontSize)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var episodeDate: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: Constants.scheduleFontSize)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var seriesSummary: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: Constants.summaryFontSize)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(labelTapped)))
        return label
    }()
    
    private lazy var seeMoreButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("See More", for: .normal)
        button.tintColor = UIColor(named: "Cream")
        button.addTarget(self, action: #selector(seeMoreButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var seeLessButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("See Less", for: .normal)
        button.tintColor = UIColor(named: "Cream")
        button.addTarget(self, action: #selector(seeLessButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        return button
    }()
    
    private lazy var seasonButton: UIButton = {
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
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(EpisodesListTableViewCell.self, forCellReuseIdentifier: EpisodesListTableViewCell.identifier)
        tableView.backgroundColor = UIColor(named: "DarkBlue")
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    // MARK: - Initialization
    
    init(presenter: SeriesDetailsPresenting) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        setupConstraints()
        presenter.fetchSeasons()
        presenter.fetchSerieDetails()
        view.backgroundColor = UIColor(named: "DarkBlue")
    }
    
    // MARK: - Private Methods
    
    private func configureViews() {
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
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            seriesImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            seriesImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.topPadding),
            seriesImage.heightAnchor.constraint(equalToConstant: Constants.imageHeight),
            seriesImage.widthAnchor.constraint(equalToConstant: Constants.imageWidth),
            
            seriesTitle.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Constants.horizontalPadding),
            seriesTitle.topAnchor.constraint(equalTo: seriesImage.bottomAnchor, constant: Constants.topPadding),
            seriesTitle.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            
            seriesSummary.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Constants.horizontalPadding),
            seriesSummary.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            seriesSummary.topAnchor.constraint(equalTo: seriesTitle.bottomAnchor, constant: 5),
            
            seeMoreButton.topAnchor.constraint(equalTo: seriesSummary.bottomAnchor, constant: 10),
            seeMoreButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.horizontalPadding),
            
            seeLessButton.topAnchor.constraint(equalTo: seriesSummary.bottomAnchor, constant: 10),
            seeLessButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.horizontalPadding),
            
            seriesGenre.topAnchor.constraint(equalTo: seeMoreButton.bottomAnchor, constant: 10),
            seriesGenre.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.horizontalPadding),
            
            episodeDate.topAnchor.constraint(equalTo: seriesGenre.bottomAnchor, constant: 10),
            episodeDate.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.horizontalPadding),
            
            seasonButton.topAnchor.constraint(equalTo: episodeDate.bottomAnchor, constant: Constants.topPadding),
            seasonButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Constants.horizontalPadding),
        
            tableView.topAnchor.constraint(equalTo: seasonButton.bottomAnchor, constant: Constants.topPadding),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Constants.horizontalPadding),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    @objc private func labelTapped() {
        if isSummaryExpanded {
            seeLessButtonTapped()
        } else {
            seeMoreButtonTapped()
        }
    }
    
    @objc private func seeMoreButtonTapped() {
        isSummaryExpanded = true
        updateContentLabel(with: summary)
        seeMoreButton.isHidden = true
        seeLessButton.isHidden = false
    }
    
    @objc private func seeLessButtonTapped() {
        isSummaryExpanded = false
        updateContentLabel(with: summary)
        seeMoreButton.isHidden = false
        seeLessButton.isHidden = true
    }
    
    @objc private func didTapChangeSeason() {
        presenter.presentSeasonsSelectionView(seasons: seasons, delegate: self)
    }
    
    private func updateContentLabel(with text: String) {
        guard !text.isEmpty else {
            seriesSummary.isHidden = true
            seeMoreButton.isHidden = true
            seeLessButton.isHidden = true
            return
        }
        
        let wordCount = text.components(separatedBy: .whitespacesAndNewlines).count
        let clippedText = isSummaryExpanded ? text : clipText(text, to: Constants.maxWordCount)
        
        let attributedString = NSMutableAttributedString(string: clippedText)
        attributedString.addAttribute(.foregroundColor, value: UIColor.white, range: NSRange(location: 0, length: clippedText.count))
        attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: Constants.summaryFontSize), range: NSRange(location: 0, length: clippedText.count))
        
        if !isSummaryExpanded && wordCount > Constants.maxWordCount {
            attributedString.append(NSAttributedString(string: "... "))
            if let buttonTitle = seeMoreButton.attributedTitle(for: .normal) {
                attributedString.append(buttonTitle)
            }
        }
        
        seriesSummary.attributedText = attributedString
    }
    
    private func clipText(_ text: String, to wordCount: Int) -> String {
        let words = text.components(separatedBy: .whitespacesAndNewlines)
        let clippedWords = Array(words.prefix(wordCount))
        return clippedWords.joined(separator: " ")
    }
    
    private func updateButtonTitle(season: Int) {
        DispatchQueue.main.async { [weak self] in
            self?.seasonButton.setTitle("Season \(season)", for: .normal)
        }
    }
}

// MARK: - SeriesDetailsDisplaying

extension SeriesDetailsViewController: SeriesDetailsDisplaying {
    func setHeaderData(image: UIImage, title: String, summary: String, genre: String?) {
        self.summary = summary
        DispatchQueue.main.async { [weak self] in
            self?.seriesImage.image = image
            self?.seriesTitle.text = title
            self?.updateContentLabel(with: summary)
            self?.seriesGenre.text = genre
        }
    }
    
    func presentAllSeasons(model: [SerieSeason]) {
        guard !model.isEmpty else { return }
        
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
        guard let schedule = schedule else { return }
        DispatchQueue.main.async { [weak self] in
            self?.episodeDate.text = schedule
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

// MARK: - UITableViewDelegate & UITableViewDataSource

extension SeriesDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        episodes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: EpisodesListTableViewCell.identifier,
            for: indexPath
        ) as? EpisodesListTableViewCell else {
            return UITableViewCell()
        }
        
        let episode = episodes[indexPath.row]
        let placeholderImage = UIImage(named: "imagePlaceholder") ?? UIImage()
        
        cell.setupCell(icon: placeholderImage, episodeName: episode.name)
        
        presenter.downloadImage(url: episode.image?.imageUrl ?? "") { [weak self] image in
            guard let self = self,
                  let image = image,
                  indexPath.row < self.episodes.count else { return }
            cell.setupCell(icon: image, episodeName: self.episodes[indexPath.row].name)
        }
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.presentEpisodeDetails(episode: episodes[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - SeasonSelectionDelegate

extension SeriesDetailsViewController: SeasonSelectionDelegate {
    func selectSeason(season: SerieSeason) {
        selectedSeason = season.id
        updateButtonTitle(season: season.number)
        presenter.fetchEpisodes(seasonID: season.id)
    }
}
