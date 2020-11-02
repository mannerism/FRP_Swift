//
//  MainViewController().swift
//  SwiftFRP
//
//  Created by Yu Juno on 2020/10/31.
//

import UIKit
import RxSwift
import RxCocoa

class MainViewController: UIViewController {
	//UI
	lazy var loginButton: UIButton = {
		let bt = UIButton(type: .system)
		bt.setTitle("LOGIN", for: .normal)
		bt.backgroundColor = .orange
		bt.addTarget(self, action: #selector(handleLoginButton), for: .touchUpInside)
		return bt
	}()
	
	let emailTextField: UITextField = {
		let tf = UITextField()
		tf.placeholder = "Email"
		tf.layer.borderColor = UIColor.lightGray.cgColor
		tf.layer.cornerRadius = 5
		tf.layer.borderWidth = 1
		return tf
	}()
	
	let passwordTextField: UITextField = {
		let tf = UITextField()
		tf.placeholder = "Password"
		tf.layer.borderColor = UIColor.lightGray.cgColor
		tf.layer.cornerRadius = 5
		tf.layer.borderWidth = 1
		return tf
	}()
	
	//ViewModel
	let viewModel = LoginViewModel()
	let disposeBag = DisposeBag()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white
		addViews()
		setConstraints()
		let email = emailTextField.rx.text.orEmpty.asObservable()
		let password = passwordTextField.rx.text.orEmpty.asObservable()
		Observable.combineLatest(email, password) { (email, password) in
			return email.isValidEmail() && password.isValidPassword()
		}
		.bind(to: loginButton.rx.isEnabled)
		.disposed(by: disposeBag)
	}
	
	@objc func handleLoginButton() {
		let alert = UIAlertController(title: "Login", message: "Login Button Enabled/Tapped!", preferredStyle: .alert)
		let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
		alert.addAction(okAction)
		self.present(alert, animated: true, completion: nil)
	}
	
	func addViews() {
		view.addSubview(emailTextField)
		view.addSubview(passwordTextField)
		view.addSubview(loginButton)
	}
	
	func setConstraints() {
		emailTextFieldConstraints()
		passwordTextFieldConstraints()
		loginButtonConstraints()
	}
	
	func emailTextFieldConstraints() {
		emailTextField.translatesAutoresizingMaskIntoConstraints = false
		emailTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
		emailTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
		emailTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 200).isActive = true
		emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
	}
	
	func passwordTextFieldConstraints() {
		passwordTextField.translatesAutoresizingMaskIntoConstraints = false
		passwordTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
		passwordTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
		passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20).isActive = true
		passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
	}
	
	func loginButtonConstraints() {
		loginButton.translatesAutoresizingMaskIntoConstraints = false
		loginButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
		loginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
		loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 70).isActive = true
		loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
	}
}

extension String {
		/// Used to validate if the given string is valid email or not
		///
		/// - Returns: Boolean indicating if the string is valid email or not
		func isValidEmail() -> Bool {
				let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
				
				let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
				print("emailTest.evaluate(with: self): \(emailTest.evaluate(with: self))")
				return emailTest.evaluate(with: self)
		}
		
		/// Used to validate if the given string matches the password requirements
		///
		/// - Returns: Boolean indicating the comparison result
		func isValidPassword() -> Bool {
				print("self.count >= 6: \(self.count >= 6)")
				return self.count >= 6
		}
}
