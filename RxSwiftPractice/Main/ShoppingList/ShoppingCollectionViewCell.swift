//
//  ShoppingCollectionViewCell.swift
//  RxSwiftPractice
//
//  Created by NERO on 8/7/24.
//

import UIKit
import RxSwift
import SnapKit
import Then

final class ShoppingCollectionViewCell: UICollectionViewCell {
    static let identifier = "ShoppingCollectionViewCell"
    var disposeBag = DisposeBag()
    
    private let keywordLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 15)
        $0.textAlignment = .center
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ShoppingCollectionViewCell {
    func setupKeyword(_ data: String) {
        keywordLabel.text = data
    }
    
    private func configureView() {
        self.backgroundColor = .systemGray6
        self.layer.cornerRadius = 10
        
        contentView.addSubview(keywordLabel)
        keywordLabel.snp.makeConstraints { $0.edges.equalTo(contentView) }
    }
}

