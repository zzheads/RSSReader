//
//  LoginViewController.swift
//  RSSReader
//
//  Created by Алексей Папин on 14/02/2019.
//  Copyright © 2019 Artec. All rights reserved.
//

import UIKit
import PromiseKit
import ReSwift

class LoginViewController: BaseViewController, StoreSubscriber {
    @IBOutlet weak var tfUsername: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var btLogin: UIButton!
    @IBOutlet weak var btRegister: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = nil
        self.btLogin.addTarget(self, action: #selector(loginDidPressed), for: .touchUpInside)
        self.btRegister.addTarget(self, action: #selector(registerDidPressed), for: .touchUpInside)
    }
    
    @objc func loginDidPressed(_ sender: UIButton) {
        guard let username = tfUsername.text, let password = tfPassword.text else {
            return
        }
        store.dispatch(LoginActions.login(User(username: username, password: password)))
    }
    
    @objc func registerDidPressed(_ sender: UIButton) {
        performSegue(withIdentifier: Route.toRegister.rawValue, sender: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        store.subscribe(self)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        store.unsubscribe(self)
    }

    func newState(state: AppState) {
        guard let result = state.login.result else {
            return
        }
        switch result {
        case .success(_)            : self.performSegue(withIdentifier: Route.toTable.rawValue, sender: self)
        case let .failure(error)    :
            let ok = UIAlertAction(title: "OK", style: .default)
            let alert = UIAlertController(title: "Login error:", message: error, preferredStyle: .alert)
            alert.addAction(ok)
            self.present(alert, animated: true) { store.dispatch(LoginActions.logout) }
        }
    }
}
