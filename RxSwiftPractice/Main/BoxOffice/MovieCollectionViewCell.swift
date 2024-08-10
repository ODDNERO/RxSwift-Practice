//
//  MovieCollectionViewCell.swift
//  RxSwiftPractice
//
//  Created by NERO on 8/7/24.
//

import UIKit
import RxSwift
import SnapKit
import Then

final class MovieCollectionViewCell: UICollectionViewCell {
    static let identifier = "MovieCollectionViewCell"
    var disposeBag = DisposeBag()
    
    let movieNameLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 13)
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

extension MovieCollectionViewCell {
    private func configureView() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 8
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.black.cgColor
        
        contentView.addSubview(movieNameLabel)
        movieNameLabel.snp.makeConstraints { $0.edges.equalTo(contentView) }
    }
}
