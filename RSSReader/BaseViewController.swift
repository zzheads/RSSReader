//
//  BaseViewController.swift
//  RSSReader
//
//  Created by Алексей Папин on 16/02/2019.
//  Copyright © 2019 Artec. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        let leftButton = UIBarButtonItem(title: "Back", style: UIBarButtonItem.Style.done, target: self, action: #selector(backButtonPressed))
        leftButton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.bold14], for: .normal)
        leftButton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.bold14], for: .highlighted)
        self.navigationItem.setLeftBarButton(leftButton, animated: true)
    }
    
    @objc func backButtonPressed(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
}
