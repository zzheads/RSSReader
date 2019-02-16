//
//  LogoutView.swift
//  RSSReader
//
//  Created by Алексей Папин on 16/02/2019.
//  Copyright © 2019 Artec. All rights reserved.
//

import UIKit

final class LogoutView: UIView {
    @IBOutlet weak var lbLogged: UILabel!
    @IBOutlet weak var btLogout: UIButton!

    static let nibName = "\(LogoutView.self)"
    
    static var nibInstance: LogoutView {
        let view = Bundle.main.loadNibNamed(nibName, owner: self, options: nil)?.first as! LogoutView
        return view
    }

}
