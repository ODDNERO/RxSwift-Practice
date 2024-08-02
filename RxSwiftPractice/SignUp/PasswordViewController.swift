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

class PasswordViewController: UIViewController {
    let passwordData = PublishSubject<String>()
    let validText = Observable.just("8자리 이상 입력해 주세요")
    let disposeBag = DisposeBag()
    
    let passwordTextField = SignTextField(placeholderText: "비밀번호를 입력해 주세요")
    let descriptionLabel = UILabel()
    let nextButton = PointButton(title: "다음")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        configureView()
    }
}

extension PasswordViewController {
    func bind() {
        validText
            .bind(to: descriptionLabel.rx.text)
            .disposed(by: disposeBag)
        
        let isValid = passwordTextField.rx.text.orEmpty
            .map { $0.count >= 8 }
        
        isValid
            .bind(to: nextButton.rx.isEnabled, descriptionLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        isValid
            .bind(with: self) { owner, value in
                owner.nextButton.backgroundColor = value ? .systemGreen : .lightGray
            }
            .disposed(by: disposeBag)
        
        passwordData
            .bind(to: passwordTextField.rx.text)
            .disposed(by: disposeBag)

        nextButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.navigationController?.pushViewController(BirthdayViewController(), animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    func configureView() {
        view.backgroundColor = .white
        
        [passwordTextField, descriptionLabel, nextButton].forEach { view.addSubview($0) }
        
        passwordTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        descriptionLabel.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(passwordTextField.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(descriptionLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
}
