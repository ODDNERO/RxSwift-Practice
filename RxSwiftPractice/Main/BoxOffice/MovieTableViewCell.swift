//
//  MovieTableViewCell.swift
//  RxSwiftPractice
//
//  Created by NERO on 8/7/24.
//

import UIKit
import RxSwift
import SnapKit
import Then

final class MovieTableViewCell: UITableViewCell {
    static let identifier = "MovieTableViewCell"
    var disposeBag = DisposeBag()

    let movieImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.backgroundColor = .systemGray6
        imageView.layer.cornerRadius = 8
        return imageView
    }()
    let movieNameLabel = UILabel().then {
        $0.textColor = .black
        $0.textAlignment = .left
        $0.font = .systemFont(ofSize: 16, weight: .bold)
    }
    let downloadButton: UIButton = {
        let button = UIButton()
        button.setTitle("받기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 13, weight: .regular)
        button.isUserInteractionEnabled = true
        button.backgroundColor = .systemGray2
        button.layer.cornerRadius = 15
        return button
    }()
    
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

extension MovieTableViewCell {
    private func configureView() {
        self.selectionStyle = .none
        
        [movieImageView, movieNameLabel, downloadButton].forEach { contentView.addSubview($0) }

        movieImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(20)
            $0.size.equalTo(60)
        }
        movieNameLabel.snp.makeConstraints {
            $0.centerY.equalTo(movieImageView)
            $0.leading.equalTo(movieImageView.snp.trailing).offset(8)
            $0.trailing.equalTo(downloadButton.snp.leading).offset(-8)
        }
        downloadButton.snp.makeConstraints {
            $0.centerY.equalTo(movieImageView)
            $0.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(30)
            $0.width.equalTo(90)
        }
    }
}
