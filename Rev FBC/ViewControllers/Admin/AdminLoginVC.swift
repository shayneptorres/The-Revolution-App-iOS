//
//  AdminLoginVC.swift
//  Rev FBC
//
//  Created by Shayne Torres on 8/23/17.
//  Copyright © 2017 sptorres. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SwiftyTimer
import KeychainAccess

class AdminLoginVM {
    
    let INVALID_EMAIL_MESSAGE = "Please enter a valid email address."
    let INVALID_PASS_MESSAGE = "Please enter a valid password."
    let AUTHENTICATING_MESSAGE = "Authenticating credentials..."
    let LOGIN_SUCCESS = "Login successful"
    let LOGIN_FAILURE = "We could not authenticate you. Please check your spelling and try again."
    
    enum UserInputValidity {
        case valid
        case invalid
        case invalidEmail
        case invalidPass
    }
    
    struct State {
        var statusMessageText : String
        var statusMessageColor : UIColor
        var statusMessageIsHidden : Bool
    }
    
    typealias Completion = (State) -> (Void)
    
    var callback : Completion!
    var email = Variable<String?>("")
    var password = Variable<String?>("")
    
    var state : State = State.init(statusMessageText: "", statusMessageColor: .black, statusMessageIsHidden: true) {
        didSet {
            callback(state)
        }
    }
    
    init(cb: @escaping Completion){
        self.callback = cb
        callback(state)
    }
    
    func loginButtonWasPressed(completion: @escaping (Void)->()){
        guard let e = email.value, let p = password.value else { return }
        
        self.state.statusMessageIsHidden = false
        
        if e == "" {
            self.state.statusMessageText = (self.INVALID_EMAIL_MESSAGE)
            self.state.statusMessageColor = .red
            return
        }
        
        if p == "" {
            self.state.statusMessageText = (self.INVALID_PASS_MESSAGE)
            self.state.statusMessageColor = .red
            return
        }
        
        self.state.statusMessageText = (self.AUTHENTICATING_MESSAGE)
        self.state.statusMessageColor = .black
        
        FirebaseService.instance.loginUser(email: e, password: p).then({ success in
            if success {
                
                /// For security, change to keychain
                
                AdminService.instance.saveUserCredentials(email: e, password: p)
                
                self.state.statusMessageText = (self.LOGIN_SUCCESS)
                self.state.statusMessageColor = .green
                Timer.after(1.5.seconds) {
                    DispatchQueue.main.async {
                        completion()
                    }
                }
            } else {
                self.state.statusMessageText = (self.LOGIN_FAILURE)
                self.state.statusMessageColor = .red
            }
            
        })
    }
    
    
}

class AdminLoginVC: UIViewController {
    
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var formContainer: UIView! {
        didSet {
            formContainer.applyShadow()
        }
    }
    
    @IBOutlet weak var statusMessage: UILabel!
    @IBOutlet weak var email: FormTextField!
    @IBOutlet weak var password: FormTextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var backBtn: UIBarButtonItem!
    
    
    
    var viewModel : AdminLoginVM!

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = AdminLoginVM(cb: { [unowned self] state in
            self.statusMessage.text = state.statusMessageText
            self.statusMessage.textColor = state.statusMessageColor
            self.statusMessage.isHidden = state.statusMessageIsHidden
        })
        
        email.rx.text.bind(to: viewModel.email).addDisposableTo(disposeBag)
        password.rx.text.bind(to: viewModel.password).addDisposableTo(disposeBag)
        
        loginBtn.rx.tap.subscribe(onNext: { [weak self] _ in
            self?.viewModel.loginButtonWasPressed(){
                self?.dismiss(animated: true, completion: nil)
            }
        }).addDisposableTo(disposeBag)
        
        backBtn.rx.tap.subscribe(onNext: { _ in
            self.dismiss(animated: true, completion: nil)
        }).addDisposableTo(disposeBag)
    }
    
    @IBAction func signUpBtnWasPressed(_ sender: UIButton) {
        let signUpAlert = UIAlertController(title: "Create admin account?", message: "To gain access to admin features you must be an admin for Faith Bible Church's High School Ministry 'The Revolution.' To gain admin access, please contact The high school pastor Morgan Maitland.", preferredStyle: .alert)
        
        let dismissAction = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
        signUpAlert.addAction(dismissAction)
        self.present(signUpAlert, animated: true, completion: nil)
    }
    
    
}
