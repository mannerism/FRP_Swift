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
	let disposeBag = DisposeBag()

	override func viewDidLoad() {
		//background
		view.backgroundColor = .red
//		subscription1()
//		subscription2()
		behaviorRelay()
	}
	
	func subscription1() {
		let test = Observable.of("Hey There!")
		let subscription = test.subscribe { (event) in
			print(event)
		}
		subscription.disposed(by: disposeBag)
	}
	
	func subscription2() {
		let sequence = Observable.from(["H", "E", "Y"])
		let subscription2 = sequence.subscribe { (event) in
			switch event {
			case .next(let value):
				print("onNext Event: \(value)")
			case .error(let error):
				print(error)
			case .completed:
				print("onCompleted")
			}
		}
		subscription2.disposed(by: disposeBag)
	}
	
	func behaviorRelay() {
///	1. Create a ‘behaviorRelay’ object of type ‘<String>’ with its default instance by providing a default value for it
		let behaviorRelay = BehaviorRelay<String>(value: "")
/// 2. Then, create a ‘subscription1’ object by subscribing to the relay object
		let subscription1 = behaviorRelay.subscribe(onNext: { string in
			print("subscription1: ", string)
		})
/// 3. Attach the DisposeBag object to subscription1, so that the observer gets deallocated along with the objects holding it.
		subscription1.disposed(by: disposeBag)
/// 4. Using the ‘accept’ method, we emit the values to all observers of the ‘behaviorRelay’ observable. Hence, we are emitting 2 strings from here. Notice how ‘subscription1’ receives these emitted elements from the ‘Result’ section at the bottom.
/// subscription1 receives these 2 events, subscription2 won't
		behaviorRelay.accept("Hey")
		behaviorRelay.accept("There")
/// 5. Just like Step 2, create another object ‘subscription2’ that subscribes to the same observable. Notice how the last emitted element is received by this subscriber.
/// subscription2 will not get "Hey" because it susbcribed later but "there" will be received as it was the last event
		let subscription2 = behaviorRelay.subscribe(onNext: { string in
			print("subscription2: ", string)
		})
/// 6. Attach DisposeBag object for cleanup as usual.
		subscription2.disposed(by: disposeBag)
/// 7. Now, we have 2 subscribers for the same ‘behaviorRelay’ object. Notice how changes to the Observable are emitted to both the subscribers.
		behaviorRelay.accept("Both Subscriptions receive this message")
	}
}
