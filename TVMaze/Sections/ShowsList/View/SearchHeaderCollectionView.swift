//
//  SearchHeaderCollectionView.swift
//  TVMaze
//
//  Created by Gabriel Monteiro Camargo da Silva on 03/03/24.
//

import UIKit

class SearchHeaderCollectionView: UICollectionReusableView {
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.showsCancelButton = true
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()

     override init(frame: CGRect) {
        super.init(frame: frame)
         setupLayout()
     }

     required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
     }
    
    func setupLayout() {
        backgroundColor = .defaultBackgroundColor
        searchBar.barTintColor = .defaultBackgroundColor
        searchBar.tintColor = .black
        
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.lightGray
        ]
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes(attributes, for: .normal)
        
        let textField = searchBar.value(forKey: "searchField") as? UITextField ?? UITextField()
        textField.textColor = .black
        textField.backgroundColor = .lightGray
        
        addSubview(searchBar)
        
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(snp.top).offset(8)
            make.leading.equalTo(snp.leading)
            make.trailing.equalTo(snp.trailing)
            make.bottom.equalTo(snp.bottom)
        }
    }
    
    @discardableResult
    override func resignFirstResponder() -> Bool {
        searchBar.resignFirstResponder()
    }
}
