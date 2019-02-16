//
//  RegisterViewController.swift
//  RSSReader
//
//  Created by Алексей Папин on 15/02/2019.
//  Copyright © 2019 Artec. All rights reserved.
//

import UIKit
import ReSwift

class RegisterViewController: BaseViewController {
    @IBOutlet weak var tfUsername: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var btRegister: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btRegister.addTarget(self, action: #selector(registerDidPressed), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem?.title = "Cancel"
    }
    
    @objc func registerDidPressed(_ sender: UIButton) {
        guard let username = tfUsername.text, let password = tfPassword.text else {
            return
        }
        store.dispatch(RegisterActions.register(username, password))
        self.navigationController?.popViewController(animated: true)
    }
}

