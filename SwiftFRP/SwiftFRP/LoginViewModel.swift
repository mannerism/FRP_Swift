//
//  LoginViewModel.swift
//  SwiftFRP
//
//  Created by Yu Juno on 2020/11/02.
//

import RxCocoa
import RxSwift

/// 1. Declaring a struct ‘LoginViewModel’
struct LoginViewModel {
/// 2. Declaring BehaviorRelay object ‘email’ which will hold the values entered by the user into the email text field.
	let email = BehaviorRelay<String>(value: "")
/// 3. Declaring BehaviorRelay object password which will hold the values entered by the user into the password text field.
	let password = BehaviorRelay<String>(value: "")
/// 4. ‘isValid’ observer of type Boolean will hold the result of the validation operation performed on email & password text fields.
	let isValid: Observable<Bool>
	
	init() {
/// 5. We use the ‘combineLatest’ operator that we have learnt above. We pass in the email & password field observers to this operator.
		isValid = Observable.combineLatest(self.email.asObservable(), self.password.asObservable()) { (email, password) in
/// 6. Inside the ‘combineLatest’ block we perform our validation operations. So, all our rules/ logic go here and it returns a boolean value indicating if the values entered are valid. It also assigns it to the ‘isValid’ object.
			return email.isValidEmail() && password.isValidPassword()
			
		}
	}
}
