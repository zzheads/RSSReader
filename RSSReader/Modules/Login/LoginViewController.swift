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
    @IBOutlet weak var containerView: UIView!
    
    let loginView = LoginView.nibInstance
    let logoutView = LogoutView.nibInstance
    
    private func setLogged(isLogged: Bool) {
        self.loginView.isHidden = isLogged
        self.logoutView.isHidden = !isLogged
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.containerView.addSubview(self.loginView)
        self.containerView.addSubview(self.logoutView)
        self.loginView.center = self.containerView.center
        self.logoutView.center = self.containerView.center
        self.loginView.btLogin.addTarget(self, action: #selector(loginDidPressed), for: .touchUpInside)
        self.logoutView.btLogout.addTarget(self, action: #selector(logoutDidPressed), for: .touchUpInside)
        self.loginView.btRegister.addTarget(self, action: #selector(registerDidPressed), for: .touchUpInside)
    }
    
    @objc func loginDidPressed(_ sender: UIButton) {
        guard let username = self.loginView.tfUsername.text, let password = self.loginView.tfPassword.text else {
            return
        }
        store.dispatch(LoginActions.login(User(username: username, password: password, bookmarks: [])))
    }
    
    @objc func logoutDidPressed(_ sender: UIButton) {
        store.dispatch(LoginActions.logout)
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
        self.setLogged(isLogged: state.login.isLogged)
        guard let result = state.login.result else {
            return
        }
        switch result {
        case let .success(user)     : self.logoutView.lbLogged.text = "Logged: \(user.username)"
        case let .failure(error)    :
            let ok = UIAlertAction(title: "OK", style: .default)
            let alert = UIAlertController(title: "Login error:", message: error, preferredStyle: .alert)
            alert.addAction(ok)
            self.present(alert, animated: true) { store.dispatch(LoginActions.logout) }
        }
    }
}
