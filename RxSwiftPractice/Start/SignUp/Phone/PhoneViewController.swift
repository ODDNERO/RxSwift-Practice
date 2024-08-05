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

class PhoneViewController: UIViewController {
    let viewModel = PhoneViewModel()
    
//    let initialPhoneText = Observable.just("010") //뷰모델로 이동
    let disposeBag = DisposeBag()
    
    let phoneTextField = SignTextField(placeholderText: "연락처를 입력해 주세요")
    let nextButton = PointButton(title: "다음")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        bind()
    }
}

extension PhoneViewController {
    func bind() {
        let input = PhoneViewModel.Input(phoneText: phoneTextField.rx.text, 
                                         nextButtonTap: nextButton.rx.tap)
        let output = viewModel.transform(input)
        
        output.initialPhoneText
            .bind(to: phoneTextField.rx.text)
            .disposed(by: disposeBag)
        
        /* MARK: 뷰모델로 이동
        let numericOnly = phoneTextField.rx.text.orEmpty
            .map { $0.filter { $0.isNumber } }
        */
        
        output.numericOnly
            .bind(to: phoneTextField.rx.text)
            .disposed(by: disposeBag)

        /* MARK: 뷰모델로 이동
        let isValid = phoneTextField.rx.text.orEmpty
            .map { $0.count >= 10 }
         */
         
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
    
    func configureView() {
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
