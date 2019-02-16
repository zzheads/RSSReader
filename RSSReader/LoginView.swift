//
//  LoginView.swift
//  RSSReader
//
//  Created by Алексей Папин on 16/02/2019.
//  Copyright © 2019 Artec. All rights reserved.
//

import UIKit

final class LoginView: UIView {
    @IBOutlet weak var tfUsername: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var btLogin: UIButton!
    @IBOutlet weak var btRegister: UIButton!
    
    static let nibName = "\(LoginView.self)"

    static var nibInstance: LoginView {
        let view = Bundle.main.loadNibNamed(nibName, owner: self, options: nil)?.first as! LoginView
        return view
    }
}
