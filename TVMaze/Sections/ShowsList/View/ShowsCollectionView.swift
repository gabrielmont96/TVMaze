//
//  ShowsCollectionView.swift
//  TVMaze
//
//  Created by Gabriel Monteiro Camargo da Silva on 01/03/24.
//

import UIKit
import Combine

class ShowsCollectionView: UICollectionView {
    lazy var shows: [ShowModel] = [] {
        didSet {
            reloadData()
            setContentOffset(.zero, animated: true)
        }
    }
    
    var headerView: SearchHeaderCollectionView?
    
    @Published var selectedShow: ShowModel?
    @Published var currentRow: Int?
    @Published var searchText: String?
    var cancellableBag = Set<AnyCancellable>()
    
    init() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = 25
        flowLayout.sectionHeadersPinToVisibleBounds = true
        super.init(frame: .zero, collectionViewLayout: flowLayout)
        delegate = self
        dataSource = self
        backgroundColor = .background
        showsVerticalScrollIndicator = false
        register()
    }

    required init?(coder: NSCoder) {
        nil
    }
    
    func register() {
        register(SearchHeaderCollectionView.self,
                 forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                 withReuseIdentifier: SearchHeaderCollectionView.identifier)
        register(ShowCollectionViewCell.self, forCellWithReuseIdentifier: ShowCollectionViewCell.identifier)
    }
    
    func setupContentsBinding(shows: Published<[ShowModel]>.Publisher) {
        shows
            .receive(on: DispatchQueue.main)
            .sink { [weak self] contents in
                self?.shows = contents
            }.store(in: &cancellableBag)
    }
}

extension ShowsCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedShow = shows[indexPath.row]
        headerView?.resignFirstResponder()
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        currentRow = indexPath.row
    }
}

extension ShowsCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shows.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShowCollectionViewCell.identifier,
                                                         for: indexPath) as? ShowCollectionViewCell {
            cell.setup(shows[indexPath.row])
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                                       withReuseIdentifier: SearchHeaderCollectionView.identifier,
                                                                       for: indexPath) as? SearchHeaderCollectionView
            view?.searchBar.delegate = self
            headerView = view
            return view ?? UICollectionReusableView()
        default:
            break
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: 
                        UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 56)
    }
}

extension ShowsCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 16
        let width = (collectionView.frame.size.width - padding) / 2
        return CGSize(width: width, height: width * 1.45)
    }
}

extension ShowsCollectionView: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.isEmpty else { return }
        searchBar.resignFirstResponder()
        searchText = text
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchText = ""
        searchBar.resignFirstResponder()
    }
}
