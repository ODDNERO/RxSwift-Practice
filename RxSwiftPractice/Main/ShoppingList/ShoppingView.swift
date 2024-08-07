//
//  ShoppingView.swift
//  RxSwiftPractice
//
//  Created by NERO on 8/3/24.
//

import UIKit
import SnapKit
import Then

final class ShoppingView: UIView {
    private let addView = UIView().then {
        $0.backgroundColor = .systemGray6
        $0.layer.cornerRadius = 10
    }
    let addTextField = UITextField().then {
        $0.placeholder = " 🛒 쇼핑할 아이템을 추가해 보세요!"
        $0.tintColor = .black
        $0.backgroundColor = .clear
        $0.borderStyle = .none
    }
    let addButton = UIButton().then {
        $0.setTitle("추가", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 15)
        $0.titleLabel?.textAlignment = .center
        $0.backgroundColor = .systemGray5
        $0.layer.cornerRadius = 10
    }
    
    let shoppingCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout()).then {
        $0.register(ShoppingCollectionViewCell.self, forCellWithReuseIdentifier: ShoppingCollectionViewCell.identifier)
        $0.backgroundColor = .clear
        $0.showsHorizontalScrollIndicator = false
    }
    let shoppingTableView = UITableView().then {
        $0.register(ShoppingTableViewCell.self, forCellReuseIdentifier: ShoppingTableViewCell.identifier)
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
        $0.showsVerticalScrollIndicator = false
        $0.rowHeight = 55
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

extension ShoppingView {
    static func layout() -> UICollectionViewFlowLayout {
        UICollectionViewFlowLayout().then {
            $0.itemSize = CGSize(width: 65, height: 35)
            $0.sectionInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
            $0.scrollDirection = .horizontal
        }
    }
    
    private func configureView() {
        self.backgroundColor = .white
        
        [addView, shoppingCollectionView, shoppingTableView].forEach { self.addSubview($0) }
        [addTextField, addButton].forEach { addView.addSubview($0) }
        
        addView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).inset(10)
            $0.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(15)
            $0.height.equalTo(65)
        }
        addTextField.snp.makeConstraints {
            $0.leading.equalTo(addView).offset(20)
            $0.trailing.equalTo(addButton.snp.leading).inset(-15)
            $0.centerY.equalTo(addButton)
        }
        addButton.snp.makeConstraints {
            $0.top.trailing.bottom.equalTo(addView).inset(15)
            $0.width.equalTo(55)
        }
        
        shoppingCollectionView.snp.makeConstraints {
            $0.top.equalTo(addView.snp.bottom)
            $0.horizontalEdges.equalTo(self.safeAreaLayoutGuide)
            $0.height.equalTo(55)
        }
        shoppingTableView.snp.makeConstraints {
            $0.top.equalTo(shoppingCollectionView.snp.bottom)
            $0.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(15)
            $0.bottom.equalTo(self.safeAreaLayoutGuide)
        }
    }
}
