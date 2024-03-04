//
//  ShowDetailTableViewCell.swift
//  TVMaze
//
//  Created by Gabriel Monteiro Camargo da Silva on 02/03/24.
//

import UIKit
import SnapKit

class ShowDetailTableViewCell: UITableViewCell {
    
    lazy var posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.setCornerRadius()
        return imageView
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .titleText
        label.textColor = .titleText
        return label
    }()
    
    lazy var seriesAirsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .bodyText
        label.textColor = .bodyText
        return label
    }()
    
    lazy var genresLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .bodyText
        label.textColor = .bodyText
        return label
    }()
    
    lazy var summaryLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .bodyText
        label.textColor = .bodyText
        return label
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setupLayout() {
        contentView.backgroundColor = .background
        
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(seriesAirsLabel)
        stackView.addArrangedSubview(genresLabel)
        stackView.addArrangedSubview(summaryLabel)
        
        contentView.addSubview(posterImageView)
        contentView.addSubview(stackView)
        
        posterImageView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top)
            make.centerX.equalTo(contentView.snp.centerX)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(posterImageView.snp.bottom).offset(16)
            make.leading.equalTo(contentView.snp.leading)
            make.trailing.equalTo(contentView.snp.trailing)
            make.bottom.equalTo(contentView.snp.bottom)
        }
    }
    
    func setup(_ model: ShowModel) {
        if let image = model.image, let imageUrl = URL(string: image.medium) {
            posterImageView.loadImageAndResize(from: imageUrl, newSize: posterImageView.frame.size)
        }
        
        nameLabel.text = model.name
        
        seriesAirsLabel.text = "Series airs\n\(model.schedule.days.joined(separator: ", ")) - \(model.schedule.time)"
        seriesAirsLabel.highlight(searchedText: "Series airs")
        
        if !model.genres.isEmpty {
            genresLabel.text = "Genres\n\(model.genres.joined(separator: ", "))"
            genresLabel.highlight(searchedText: "Genres")
        }
        
        if let summary = model.summary?.replacingHTML(), !summary.isEmpty {
            summaryLabel.text = "Summary\n\(summary)"
            summaryLabel.highlight(searchedText: "Summary")
        }
    }
}
