//
//  BoxOfficeView.swift
//  RxSwiftPractice
//
//  Created by NERO on 8/7/24.
//

import UIKit
import SnapKit
import Then

final class BoxOfficeView: UIView {
    let movieSearchBar = UISearchBar().then {
        $0.backgroundColor = .systemGray6
    }
    let movieCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout()).then {
        $0.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
        $0.backgroundColor = .systemGray6
    }
    let movieTableView = UITableView().then {
        $0.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.identifier)
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
        $0.showsVerticalScrollIndicator = false
        $0.rowHeight = 100
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BoxOfficeView {
    static func layout() -> UICollectionViewFlowLayout {
        UICollectionViewFlowLayout().then {
            $0.itemSize = CGSize(width: 120, height: 40)
            $0.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            $0.scrollDirection = .horizontal
        }
    }
    
    private func configureView() {
        self.backgroundColor = .white
        
        [movieCollectionView, movieTableView].forEach { self.addSubview($0) }
        
        movieCollectionView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide)
            $0.horizontalEdges.equalTo(self.safeAreaLayoutGuide)
            $0.height.equalTo(50)
        }
        
        movieTableView.snp.makeConstraints {
            $0.top.equalTo(movieCollectionView.snp.bottom)
            $0.horizontalEdges.equalTo(self.safeAreaLayoutGuide)
            $0.bottom.equalTo(self.safeAreaLayoutGuide)
        }
    }
}
