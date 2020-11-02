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
		emailTextField
			///‘rx’: We access the RxSwift ‘rx’ property that gives us the extension object of the text field
			.rx
			///‘text’: We access ‘text’ on top of ‘rx’, which gives us the Reactive property of the text
			.text
			///‘orEmpty’: We need to call this since it converts the optional reactive ‘String?’ property to ‘String’, basically unwrapping it
			.orEmpty
			///‘bind(to:)’: As we saw earlier, passing any object to this method binds it to the property, so here we bind the emailTextField’s text property to the viewModel’s ‘email’ observable.
			.bind(to: viewModel.email)
			///‘disposed’: Finally, we attach the disposeBag object for cleaning it up.
			.disposed(by: disposeBag)
		
		passwordTextField
			.rx
			.text
			.orEmpty
			.bind(to: viewModel.password)
			.disposed(by: disposeBag)
		
		///‘map’: From our Functional Programming blog <<link to blog>>, we used ‘map’ to transform objects from one type to another. Here, we use it on viewModel’s ‘isValid’ Boolean Observable to transform it into a boolean. Basically, ’map’ transforms Observable to Bool type, which is then bound to the loginButton’s ‘isEnabled’ property which is then responsible for enabling or disabling the button.
		viewModel.isValid.map{ $0 }
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
