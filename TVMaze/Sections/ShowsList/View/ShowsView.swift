//
//  ShowsView.swift
//  TVMaze
//
//  Created by Gabriel Monteiro Camargo da Silva on 01/03/24.
//

import UIKit
import SnapKit

class ShowsView: UIView {
    lazy var collectionView: ShowsCollectionView = {
        var collectionView = ShowsCollectionView()
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    @Published var selectedShow: ShowModel?
    @Published var currentRow: Int?
    @Published var searchText: String?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        setupBindings()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupLayout() {
        backgroundColor = .defaultBackgroundColor
        addSubview(collectionView)
        
        collectionView.snp.makeConstraints { [weak self] make in
            guard let self else { return }
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            make.left.equalTo(self.snp.left).inset(CollectionViewConstants.horizontal.cgFloat)
            make.right.equalTo(self.snp.right).inset(CollectionViewConstants.horizontal.cgFloat)
            make.bottom.equalTo(self.snp.bottom)
        }
    }
    
    func setupBindings() {
        collectionView.$selectedShow.assign(to: &$selectedShow)
        collectionView.$currentRow.assign(to: &$currentRow)
        collectionView.$searchText.assign(to: &$searchText)
    }
    
    func configure(contents: Published<[ShowModel]>.Publisher) {
        collectionView.setupContentsBinding(shows: contents)
    }
    
    func setCollectionViewUserInteractionEnabled() {
        collectionView.isUserInteractionEnabled = true
    }
}
