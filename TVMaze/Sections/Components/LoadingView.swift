//
//  FeedbackView.swift
//  TVMaze
//
//  Created by Gabriel Monteiro Camargo da Silva on 04/03/24.
//

import UIKit

enum FeedbackType {
    case text(text: String)
    case loading
}

class FeedbackView: UIView {
    lazy var feedbackLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.startAnimating()
        return activityIndicator
    }()
    
    lazy var vStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
    
    func setupLayout() {
        backgroundColor = .background
        
        addSubview(vStackView)
        vStackView.snp.makeConstraints { make in
            make.centerY.equalTo(snp.centerY)
            make.centerX.equalTo(snp.centerX)
        }
    }
    
    func configure(_ feedbackType: FeedbackType) {
        vStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        switch feedbackType {
        case .loading:
            activityIndicator.color = .lightGray
            activityIndicator.startAnimating()
            vStackView.addArrangedSubview(activityIndicator)
        case .text(let text):
            feedbackLabel.text = text
            vStackView.addArrangedSubview(feedbackLabel)
        }
    }
    
    func show(in view: UIView) {
        guard !isDescendant(of: view) else { return }
        translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(self)
        snp.makeConstraints { make in
            make.top.equalTo(view.snp.top)
            make.right.equalTo(view.snp.right)
            make.left.equalTo(view.snp.left)
            make.bottom.equalTo(view.snp.bottom)
        }
    }
    
    func remove(withDelay delay: CGFloat? = nil) {
        guard superview != nil else { return }
        if let delay, delay > 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
                self?.removeFromSuperview()
            }
        } else {
            removeFromSuperview()
        }
        
    }
}
