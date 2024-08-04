//
//  SignInViewController.swift
//  RxSwiftPractice
//
//  Created by NERO on 8/1/24.
//

import UIKit
import SnapKit

class SignInViewController: UIViewController {
    let emailTextField = SignTextField(placeholderText: "이메일을 입력해 주세요")
    let passwordTextField = SignTextField(placeholderText: "비밀번호를 입력해 주세요")
    let signInButton = PointButton(title: "로그인")
    let signUpButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureView()
        signInButton.addTarget(self, action: #selector(signInButtonClicked), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(signUpButtonClicked), for: .touchUpInside)
    }
    
    @objc func signInButtonClicked() {
        navigationController?.pushViewController(ShoppingViewController(), animated: true)
    }
    @objc func signUpButtonClicked() {
        navigationController?.pushViewController(SignUpViewController(), animated: true)
    }
}

extension SignInViewController {
    func configureView() {
        view.backgroundColor = .white
        signUpButton.setTitle("회원이 아니십니까?", for: .normal)
        signUpButton.setTitleColor(.black, for: .normal)
        
        [emailTextField, passwordTextField, signInButton, signUpButton].forEach { view.addSubview($0) }
        
        emailTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        passwordTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(emailTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        signInButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(passwordTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        signUpButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(signInButton.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
}
