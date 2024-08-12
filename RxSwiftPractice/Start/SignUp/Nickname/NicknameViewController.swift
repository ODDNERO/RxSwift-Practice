//
//  NicknameViewController.swift
//  RxSwiftPractice
//
//  Created by NERO on 8/12/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class NicknameViewController: UIViewController {
    private let viewModel = NicknameViewModel()
    private let disposeBag = DisposeBag()
    
    private let nicknameTextField = SignTextField(placeholderText: "닉네임을 입력해 주세요")
    private let statusMessageTextField = SignTextField(placeholderText: "상태메시지를 입력해 주세요")
    private let nextButton = PointButton(title: "다음")
    private let jokeButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        bind()
    }
}

extension NicknameViewController {
    private func bind() {
        let input = NicknameViewModel.Input(jokeButtonTap: jokeButton.rx.tap)
        let output = viewModel.transform(input: input)
        
        nicknameTextField.rx.text.orEmpty
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .bind(with: self) { owner, text in
                let value = text.count >= 1 //원래는 뷰모델로 이동해야 함
                let navigationTitle = value ? "안녕하세요, \(text) 님! 🙌🏻" : "👤"
                owner.navigationItem.rx.title.onNext(navigationTitle)
                owner.nextButton.isEnabled = value
                owner.nextButton.backgroundColor = value ? .systemGreen : .lightGray
            }.disposed(by: disposeBag)
        
        output.joke //뷰모델에서 asDriver 해 둠
            .map { $0.joke }
            .drive(statusMessageTextField.rx.text)
            .disposed(by: disposeBag)
        
//        output.joke
//            .map { "농담: \($0.id)" }
//            .drive(navigationItem.rx.title)
//            .disposed(by: disposeBag)
        
        nextButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.navigationController?.pushViewController(BirthdayViewController(), animated: true)
            }.disposed(by: disposeBag)
    }
}

extension NicknameViewController {
    func configureView() {
        view.backgroundColor = .white
        jokeButton.setTitle("😜 상태메시지에 Joke 넣기", for: .normal)
        jokeButton.setTitleColor(.systemCyan, for: .normal)
        
        [nicknameTextField, statusMessageTextField, nextButton, jokeButton].forEach { view.addSubview($0) }
        
        nicknameTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        statusMessageTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(nicknameTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(statusMessageTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        jokeButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(nextButton.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
}
