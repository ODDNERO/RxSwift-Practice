//
//  PasswordViewController.swift
//  RxSwiftPractice
//
//  Created by NERO on 8/1/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class PasswordViewController: UIViewController {
    private let viewModel = PasswordViewModel()
    private let disposeBag = DisposeBag()
    
    private let passwordTextField = SignTextField(placeholderText: "비밀번호를 입력해 주세요")
    private let nextButton = PointButton(title: "다음")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        configureView()
    }
}

extension PasswordViewController {
    private func bind() {
        let input = PasswordViewModel.Input(passwordText: passwordTextField.rx.text,
                                            nextButtonTap: nextButton.rx.tap)
        let output = viewModel.transform(input)

        output.nextButtonText
            .bind(to: nextButton.rx.title())
            .disposed(by: disposeBag)

        output.isValidPassword
            .bind(with: self) { owner, value in
                owner.nextButton.isEnabled = value
                owner.nextButton.backgroundColor = value ? .systemGreen : .lightGray
            }.disposed(by: disposeBag)

        output.nextButtonTap
            .bind(with: self) { owner, _ in
                owner.navigationController?.pushViewController(PhoneViewController(), animated: true)
            }.disposed(by: disposeBag)
    }
    
    private func configureView() {
        view.backgroundColor = .white
        
        [passwordTextField, nextButton].forEach { view.addSubview($0) }
        
        passwordTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(passwordTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
}
