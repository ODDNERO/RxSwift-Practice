//
//  PhoneViewController.swift
//  RxSwiftPractice
//
//  Created by NERO on 8/1/24.
//
 
import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class PhoneViewController: UIViewController {
    private let viewModel = PhoneViewModel()
    private let disposeBag = DisposeBag()
    
    private let phoneTextField = SignTextField(placeholderText: "연락처를 입력해 주세요")
    private let nextButton = PointButton(title: "다음")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        bind()
    }
}

extension PhoneViewController {
    private func bind() {
        let input = PhoneViewModel.Input(phoneText: phoneTextField.rx.text,
                                         nextButtonTap: nextButton.rx.tap)
        let output = viewModel.transform(input)
        
        output.initialPhoneText
            .bind(to: phoneTextField.rx.text)
            .disposed(by: disposeBag)
        
        output.numericOnly
            .bind(to: phoneTextField.rx.text)
            .disposed(by: disposeBag)

        output.isValidPhone
            .bind(with: self) { owner, value in
                owner.nextButton.isEnabled = value
                owner.nextButton.backgroundColor = value ? .systemGreen : .lightGray
            }.disposed(by: disposeBag)
        
        output.nextButtonTap
            .bind(with: self) { owner, _ in
                owner.navigationController?.pushViewController(BirthdayViewController(), animated: true)
            }.disposed(by: disposeBag)
    }
    
    private func configureView() {
        view.backgroundColor = .white
        phoneTextField.keyboardType = .namePhonePad
        
        [phoneTextField, nextButton].forEach { view.addSubview($0) }
         
        phoneTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(phoneTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
}
