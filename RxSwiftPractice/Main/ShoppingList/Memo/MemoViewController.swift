//
//  MemoViewController.swift
//  RxSwiftPractice
//
//  Created by NERO on 8/3/24.
//

import UIKit
import SnapKit
import Then

final class MemoViewController: UIViewController {
    private let data: Shopping
    
    private lazy var titleLabel = UILabel().then {
        $0.text = data.content
        $0.textColor = .black
        $0.textAlignment = .center
        $0.font = .systemFont(ofSize: 18, weight: .heavy)
    }
    private lazy var memoLabel = UILabel().then {
        $0.text = data.memo
        $0.textColor = .black
        $0.textAlignment = .center
        $0.font = .systemFont(ofSize: 16, weight: .medium)
        $0.backgroundColor = .systemGray6
        $0.layer.cornerRadius = 15
        $0.clipsToBounds = true
    }

    init(data: Shopping) {
        self.data = data
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
}

extension MemoViewController {
    private func configureView() {
        view.backgroundColor = .white
        navigationItem.title = "📝"
        
        [titleLabel, memoLabel].forEach { view.addSubview($0) }
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(10)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(40)
            $0.height.equalTo(40)
        }
        memoLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(15)
            $0.height.greaterThanOrEqualTo(100)
        }
    }
}
