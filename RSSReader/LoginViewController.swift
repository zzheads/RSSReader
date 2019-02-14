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

class LoginViewController: UIViewController, StoreSubscriber {
    @IBOutlet weak var tfUsername: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var btLogin: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.btLogin.addTarget(self, action: #selector(loginDidPressed), for: .touchUpInside)
    }
    
    @objc func loginDidPressed(_ sender: UIButton) {
        let username = tfUsername.text
        let password = tfPassword.text
        store.dispatch(LoginActions.login(username, password))
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
        if state.login.isLogged {
            self.performSegue(withIdentifier: Route.toTable.rawValue, sender: self)
        }
    }    
}
