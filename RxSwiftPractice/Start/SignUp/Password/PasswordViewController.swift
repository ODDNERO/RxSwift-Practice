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
    
//    private let validText = Observable.just("8자리 이상 입력해 주세요") //뷰모델로 이동
    private let disposeBag = DisposeBag()
    
    private let passwordTextField = SignTextField(placeholderText: "비밀번호를 입력해 주세요")
//    private let descriptionLabel = UILabel() //버튼에 표시하는 것으로 변경
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
        
//        validText
//            .bind(to: descriptionLabel.rx.text)
//            .disposed(by: disposeBag)
        output.nextButtonText
            .bind(to: nextButton.rx.title())
            .disposed(by: disposeBag)
        
        /* MARK: 뷰모델로 이동
        let isValid = passwordTextField.rx.text.orEmpty
            .map { $0.count >= 8 }
        */
         
//        isValid
//            .bind(to: nextButton.rx.isEnabled, descriptionLabel.rx.isHidden)
//            .disposed(by: disposeBag)
        
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
        
//        [passwordTextField, descriptionLabel, nextButton].forEach { view.addSubview($0) }
        [passwordTextField, nextButton].forEach { view.addSubview($0) }
        
        passwordTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
//        descriptionLabel.snp.makeConstraints { make in
//            make.height.equalTo(50)
//            make.top.equalTo(passwordTextField.snp.bottom).offset(10)
//            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
//        }
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(passwordTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
}
