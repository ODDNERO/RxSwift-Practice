//
//  SignUpViewController.swift
//  RxSwiftPractice
//
//  Created by NERO on 8/1/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class SignUpViewController: UIViewController {
    enum ValidationError: Error {
        case invalidEmail
    }
    
    let disposeBag = DisposeBag()
    let emailData = PublishSubject<String>()
    let basicColor = Observable.just(UIColor.systemGreen)

    let emailTextField = SignTextField(placeholderText: "이메일을 입력해 주세요")
    let validationButton = UIButton()
    let nextButton = PointButton(title: "다음")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureView()
        bind()
    }
}

extension SignUpViewController {
    func bind() {
        let isValid = emailTextField.rx.text.orEmpty
            .map { $0.count >= 4 }
        
        isValid
            .bind(to: nextButton.rx.isEnabled, validationButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        isValid
            .bind(with: self) { owner, value in
                owner.validationButton.isHidden = value ? false : true
                owner.nextButton.backgroundColor = value ? .systemGreen : .lightGray
            }
            .disposed(by: disposeBag)
        
        emailData
            .bind(to: emailTextField.rx.text)
            .disposed(by: disposeBag)
        
        basicColor
            .bind(to: emailTextField.rx.textColor, emailTextField.rx.tintColor)
            .disposed(by: disposeBag)
        
        basicColor
            .map { $0.cgColor }
            .bind(to: emailTextField.layer.rx.borderColor)
            .disposed(by: disposeBag)
        
        validationButton.rx.tap
            .bind(with: self) { owner, _ in
//                owner.emailData.onNext(" ")
//                owner.validationButton.setTitle("확인 완료", for: .normal)
            }
            .disposed(by: disposeBag)
        
        nextButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.navigationController?.pushViewController(PasswordViewController(), animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    func configureView() {
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
