//
//  ShowDetailSeasonTableViewCell.swift
//  TVMaze
//
//  Created by Gabriel Monteiro Camargo da Silva on 02/03/24.
//

import UIKit
import SnapKit

class ShowDetailSeasonTableViewCell: UITableViewCell {
    lazy var seasonNumberLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .lightGray
        return label
    }()
    
    lazy var arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.right")?.withTintColor(.lightGray, renderingMode: .alwaysOriginal)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var selectedView: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        return view
    }()
    
    lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        return view
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
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
        selectedBackgroundView = selectedView
        
        backgroundColor = .defaultBackgroundColor
        
        stackView.addArrangedSubview(seasonNumberLabel)
        stackView.addArrangedSubview(arrowImageView)
        
        contentView.addSubview(separatorView)
        contentView.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top)
            make.leading.equalTo(contentView.snp.leading).offset(16)
            make.trailing.equalTo(contentView.snp.trailing).offset(-16)
            make.bottom.equalTo(contentView.snp.bottom)
        }
        
        separatorView.snp.makeConstraints { make in
            make.bottom.equalTo(stackView.snp.bottom)
            make.leading.equalTo(stackView.snp.leading)
            make.trailing.equalTo(stackView.snp.trailing)
            make.height.equalTo(1)
        }
    }
    
    func configure(_ model: ShowSeasonsModel) {
        seasonNumberLabel.text = "\(model.number)"
    }
}
