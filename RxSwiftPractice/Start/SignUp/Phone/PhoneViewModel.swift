//
//  PhoneViewModel.swift
//  RxSwiftPractice
//
//  Created by NERO on 8/5/24.
//

import Foundation
import RxSwift
import RxCocoa

class PhoneViewModel {
    let validText = Observable.just("연락처는 8자 이상")
    
    struct Input {
        let phoneText: ControlProperty<String?> //phoneTextField.rx.text
        let nextButtonTap : ControlEvent<Void>  //nextButton.rx.tap
    }
    struct Output {
        let initialPhoneText: Observable<String>
        let numericOnly: Observable<ControlProperty<String>.Element>
        let isValidPhone: Observable<Bool>
        let nextButtonTap: ControlEvent<Void>
    }
}

extension PhoneViewModel {
    func transform(_ input: Input) -> Output {
        let initialPhoneText = Observable.just("010")
        
        let phoneText = input.phoneText.orEmpty
        let numericOnly = phoneText.map { $0.filter { $0.isNumber } }
        let isValidPhone = phoneText.map { $0.count >= 8 }
        
        return Output(initialPhoneText: initialPhoneText,
                      numericOnly: numericOnly, isValidPhone: isValidPhone,
                      nextButtonTap: input.nextButtonTap)
    }
}
