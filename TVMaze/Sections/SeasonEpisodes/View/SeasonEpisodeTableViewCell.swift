//
//  SeasonEpisodeTableViewCell.swift
//  TVMaze
//
//  Created by Gabriel Monteiro Camargo da Silva on 03/03/24.
//

import UIKit
import SnapKit

class SeasonEpisodeTableViewCell: UITableViewCell {
    lazy var posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16)
        label.textColor = .lightGray
        return label
    }()
    
    lazy var seasonEpisodeInfoView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .defaultBackgroundColor
        return view
    }()
    
    lazy var seasonEpisodeInfoLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var summaryLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16)
        label.textColor = .lightGray
        return label
    }()
    
    lazy var vStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 8
        return stackView
    }()
    
    lazy var arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.down")?.withTintColor(.lightGray, renderingMode: .alwaysOriginal)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    var imageHeightConstraint: Constraint?
    var nilImageHeightConstraint: Constraint?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        vStackView.subviews.forEach { $0.removeFromSuperview() }
        seasonEpisodeInfoView.subviews.forEach { $0.removeFromSuperview() }
        contentView.subviews.forEach { $0.removeFromSuperview() }
        setupLayout()
    }
    
    func setupLayout() {
        contentView.backgroundColor = .defaultBackgroundColor
        
        vStackView.addArrangedSubview(posterImageView)
        vStackView.addArrangedSubview(nameLabel)
        vStackView.addArrangedSubview(summaryLabel)
        
        seasonEpisodeInfoView.addSubview(seasonEpisodeInfoLabel)
        seasonEpisodeInfoView.addSubview(arrowImageView)

        contentView.addSubview(seasonEpisodeInfoView)

    }
    
    func applyConstraints(isExpanded: Bool) {
        seasonEpisodeInfoView.snp.makeConstraints { make in
            make.height.equalTo(48)
            make.top.equalTo(contentView.snp.top)
            make.leading.equalTo(contentView.snp.leading)
            make.trailing.equalTo(contentView.snp.trailing)
        }
        
        arrowImageView.snp.makeConstraints { make in
            make.centerY.equalTo(seasonEpisodeInfoView.snp.centerY)
            make .trailing.equalTo(seasonEpisodeInfoView.snp.trailing)
        }
        
        seasonEpisodeInfoLabel.snp.makeConstraints { make in
            make.centerY.equalTo(seasonEpisodeInfoView.snp.centerY)
            make.leading.equalTo(seasonEpisodeInfoView.snp.leading)
        }
        if isExpanded {
            contentView.addSubview(vStackView)
            arrowImageView.image = UIImage(systemName: "chevron.up")?.withTintColor(.lightGray, renderingMode: .alwaysOriginal)
            
            posterImageView.snp.makeConstraints { make in
                make.centerX.equalTo(vStackView.snp.centerX)
                imageHeightConstraint = make.height.equalTo(140).constraint
                nilImageHeightConstraint = make.height.equalTo(0).constraint
            }
            
            imageHeightConstraint?.activate()
            nilImageHeightConstraint?.deactivate()
            
            vStackView.snp.makeConstraints { make in
                make.top.equalTo(seasonEpisodeInfoView.snp.bottom).offset(8)
                make.leading.equalTo(seasonEpisodeInfoView.snp.leading).offset(16)
                make.trailing.equalTo(seasonEpisodeInfoView.snp.trailing).offset(-16)
                make.bottom.equalTo(contentView.snp.bottom)
            }
        } else {
            arrowImageView.image = UIImage(systemName: "chevron.down")?.withTintColor(.lightGray, renderingMode: .alwaysOriginal)
            seasonEpisodeInfoView.snp.makeConstraints { make in
                make.bottom.equalTo(contentView.snp.bottom)
            }
        }
    }
    
    func setup(episode: SeasonEpisodesModel) {
        applyConstraints(isExpanded: episode.isExpanded)
        if let season = episode.season, let episode = episode.number {
            seasonEpisodeInfoLabel.text = "Season \(season) - Episode \(episode)"
        } else if let season = episode.season {
            seasonEpisodeInfoLabel.text = "Season \(season)"
        } else if let number = episode.number {
            seasonEpisodeInfoLabel.text = "Episode \(number)"
        }
        
        if let image = episode.image, let imageUrl = URL(string: image.medium) {
            posterImageView.loadImageAndResize(from: imageUrl, newSize: posterImageView.frame.size)
        } else {
            imageHeightConstraint?.deactivate()
            nilImageHeightConstraint?.activate()
        }
        
        nameLabel.text = "Name\n\(episode.name)"
        nameLabel.highlight(searchedText: "Name", font: .systemFont(ofSize: 16, weight: .semibold))
        
        if let summary = episode.summary?.replacingHTML() {
            summaryLabel.text = "Summary\n\(summary)"
            summaryLabel.highlight(searchedText: "Summary", font: .systemFont(ofSize: 16, weight: .semibold))
        }
    }
}
