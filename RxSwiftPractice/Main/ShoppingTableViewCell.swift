//
//  ShoppingTableViewCell.swift
//  RxSwiftPractice
//
//  Created by NERO on 8/3/24.
//

import UIKit
import RxSwift
import SnapKit
import Then

final class ShoppingTableViewCell: UITableViewCell {
    static let identifier = "ShoppingTableViewCell"
    var disposeBag = DisposeBag()
    
    let completeButton = UIButton().then {
        $0.tintColor = .black
        $0.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
        $0.contentMode = .scaleAspectFill
    }
    private let contentLabel = UILabel().then {
        $0.textColor = .black
        $0.textAlignment = .left
        $0.font = .systemFont(ofSize: 14)
    }
    let bookmarkButton = UIButton().then {
        $0.tintColor = .black
        $0.setImage(UIImage(systemName: "star"), for: .normal)
        $0.contentMode = .scaleAspectFill
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
}

extension ShoppingTableViewCell {
    func setupContentText(_ data: Shopping) {
        contentLabel.text = data.content
    }
    
    func setupButton(_ data: Shopping) {
        let completeImageName = data.isCompleted ? "checkmark.square.fill" : "checkmark.square"
        let bookmarkImageName = data.isBookmarked ? "star.fill" : "star"
        completeButton.setImage(UIImage(systemName: completeImageName), for: .normal)
        bookmarkButton.setImage(UIImage(systemName: bookmarkImageName), for: .normal)
    }
    
    private func configureView() {
        self.selectionStyle = .none
        contentView.backgroundColor = .systemGray6
        contentView.layer.cornerRadius = 10
        
        [completeButton, contentLabel, bookmarkButton].forEach { contentView.addSubview($0) }
        
        completeButton.snp.makeConstraints {
            $0.centerY.equalTo(contentView)
            $0.leading.equalTo(contentView).inset(20)
            $0.size.equalTo(30)
        }
        contentLabel.snp.makeConstraints {
            $0.centerY.equalTo(contentView)
            $0.leading.equalTo(completeButton.snp.trailing).offset(20)
            $0.trailing.equalTo(bookmarkButton.snp.leading).inset(-15)
        }
        bookmarkButton.snp.makeConstraints {
            $0.centerY.equalTo(contentView)
            $0.trailing.equalTo(contentView).inset(20)
            $0.size.equalTo(30)
        }
    }
}
