//
//  EmailViewController.swift
//  RxSwiftPractice
//
//  Created by NERO on 8/1/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class EmailViewController: UIViewController {
    private let viewModel = EmailViewModel()

    private let stateColor = BehaviorRelay(value: UIColor.black)
    private let disposeBag = DisposeBag()

    private let emailTextField = SignTextField(placeholderText: "이메일을 입력해 주세요")
    private let validationButton = UIButton()
    private let nextButton = PointButton(title: "다음")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        bind()
    }
}

extension EmailViewController {
    func bind() {
        let input = EmailViewModel.Input(emailText: emailTextField.rx.text, 
                                         nextButtonTap: nextButton.rx.tap)
        let output = viewModel.transform(input)
        
        /* MARK: 뷰모델로 이동
        let isValid = emailTextField.rx.text.orEmpty
            .map { $0.count >= 4 }
        */

        output.isValidEmail
            .bind(with: self) { owner, value in
                let color: UIColor = value ? .systemGreen : .black
                owner.stateColor.accept(color)
                owner.validationButton.isHidden = !value
                owner.nextButton.isEnabled = value
                owner.nextButton.backgroundColor = value ? .systemGreen : .lightGray
            }.disposed(by: disposeBag)
        
        stateColor
            .bind(to: emailTextField.rx.textColor, emailTextField.rx.tintColor)
            .disposed(by: disposeBag)
        stateColor
            .map { $0.cgColor }
            .bind(to: emailTextField.layer.rx.borderColor)
            .disposed(by: disposeBag)
        
        output.nextButtonTap
            .bind(with: self) { owner, _ in
                owner.navigationController?.pushViewController(PasswordViewController(), animated: true)
            }.disposed(by: disposeBag)
    }
    
    func configureView() {
        view.backgroundColor = .white
        validationButton.setTitle("중복 확인", for: .normal)
        validationButton.setTitleColor(.black, for: .normal)
        validationButton.layer.borderWidth = 1
        validationButton.layer.borderColor = UIColor.black.cgColor
        validationButton.layer.cornerRadius = 10
        
        [emailTextField, validationButton, nextButton].forEach { view.addSubview($0) }
        
        validationButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.width.equalTo(100)
        }
        emailTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.trailing.equalTo(validationButton.snp.leading).offset(-8)
        }
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(emailTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
}
