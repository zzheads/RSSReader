//
//  UIFont +.swift
//  RSSReader
//
//  Created by Алексей Папин on 13/02/2019.
//  Copyright © 2019 Artec. All rights reserved.
//

import UIKit

// Расширение шрифтов описывающее шрифты из брендбуке
public extension UIFont {
    
    //MARK: ExtraBold
    
    /// extraBold24
    public class var extraBold24: UIFont {
        return UIFont.extraBold(of: 24)
    }
    
    /// extraBold22
    public class var extraBold22: UIFont {
        return UIFont.extraBold(of: 22)
    }
    
    /// extraBold20
    public class var extraBold20: UIFont {
        return UIFont.extraBold(of: 20)
    }
    
    /// extraBold18
    public class var extraBold18: UIFont {
        return UIFont.extraBold(of: 18)
    }
    
    /// extraBold16
    public class var extraBold16: UIFont {
        return UIFont.extraBold(of: 16)
    }
    
    /// extraBold15
    public class var extraBold15: UIFont {
        return UIFont.extraBold(of: 15)
    }
    
    /// extraBold14
    public class var extraBold14: UIFont {
        return UIFont.extraBold(of: 14)
    }
    
    /// extraBold12
    public class var extraBold12: UIFont {
        return UIFont.extraBold(of: 12)
    }
    
    //MARK: Bold
    
    /// bold50
    public class var bold50: UIFont {
        return UIFont.bold(of: 50)
    }
    
    /// bold45
    public class var bold45: UIFont {
        return UIFont.bold(of: 45)
    }
    
    /// bold40
    public class var bold40: UIFont {
        return UIFont.bold(of: 40)
    }
    
    /// bold36
    public class var bold36: UIFont {
        return UIFont.bold(of: 36)
    }
    
    /// bold32
    public class var bold32: UIFont {
        return UIFont.bold(of: 32)
    }
    
    /// bold35
    public class var bold35: UIFont {
        return UIFont.bold(of: 35)
    }
    
    /// bold30
    public class var bold30: UIFont {
        return UIFont.bold(of: 30)
    }
    
    /// bold28
    public class var bold28: UIFont {
        return UIFont.bold(of: 28)
    }
    
    /// bold24
    public class var bold24: UIFont {
        return UIFont.bold(of: 24)
    }
    
    /// bold26
    public class var bold26: UIFont {
        return UIFont.bold(of: 26)
    }
    
    /// bold22
    public class var bold22: UIFont {
        return UIFont.bold(of: 22)
    }
    
    /// bold21
    public class var bold21: UIFont {
        return UIFont.bold(of: 21)
    }
    
    /// bold20
    public class var bold20: UIFont {
        return UIFont.bold(of: 20)
    }
    
    /// bold18
    public class var bold18: UIFont {
        return UIFont.bold(of: 18)
    }
    
    /// bold16
    public class var bold16: UIFont {
        return UIFont.bold(of: 16)
    }
    
    /// bold15
    public class var bold15: UIFont {
        return UIFont.bold(of: 15)
    }
    
    /// bold14
    public class var bold14: UIFont {
        return UIFont.bold(of: 14)
    }
    
    /// bold14
    public class var bold13: UIFont {
        return UIFont.bold(of: 13)
    }
    
    /// bold12
    public class var bold12: UIFont {
        return UIFont.bold(of: 12)
    }
    
    /// bold11
    public class var bold11: UIFont {
        return UIFont.bold(of: 11)
    }
    
    /// bold10
    public class var bold10: UIFont {
        return UIFont.bold(of: 10)
    }
    
    //MARK: Regular
    
    /// regular50
    public class var regular50: UIFont {
        return UIFont.regular(of: 50)
    }
    
    /// regular35
    public class var regular35: UIFont {
        return UIFont.regular(of: 35)
    }
    
    /// regular25
    public class var regular25: UIFont {
        return UIFont.regular(of: 25)
    }
    
    /// regular24
    public class var regular24: UIFont {
        return UIFont.regular(of: 24)
    }
    
    /// regular22
    public class var regular22: UIFont {
        return UIFont.regular(of: 22)
    }
    
    /// regular20
    public class var regular20: UIFont {
        return UIFont.regular(of: 20)
    }
    
    /// regular19
    public class var regular19: UIFont {
        return UIFont.regular(of: 19)
    }
    
    /// regular18
    public class var regular18: UIFont {
        return UIFont.regular(of: 18)
    }
    
    /// regular17
    public class var regular17: UIFont {
        return UIFont.regular(of: 17)
    }
    
    // regular16
    public class var regular16: UIFont {
        return UIFont.regular(of: 16)
    }
    
    //  regular15
    public class var regular15: UIFont {
        return UIFont.regular(of: 15)
    }
    
    /// regular14
    public class var regular14: UIFont {
        return UIFont.regular(of: 14)
    }
    
    /// regular13
    public class var regular13: UIFont {
        return UIFont.regular(of: 13)
    }
    
    /// regular12
    public class var regular12: UIFont {
        return UIFont.regular(of: 12)
    }
    
    /// regular11
    public class var regular11: UIFont {
        return UIFont.regular(of: 11)
    }
    
    /// regular10
    public class var regular10: UIFont {
        return UIFont.regular(of: 10)
    }
    
    //MARK: Light
    
    // light15
    public class var light15: UIFont {
        return UIFont.light(of: 15)
    }
    
    //MARK: - Private
    
    private enum FontNames: String {
        case thin = "Circe-Thin"
        case extraLight = "Circe-ExtraLight"
        case light = "Circe-Light"
        case regular = "Circe-Regular"
        case bold = "Circe-Bold"
        case extraBold = "Circe-ExtraBold"
    }
    
    private class func extraBold(of size: CGFloat) -> UIFont {
        return UIFont(name: FontNames.extraBold.rawValue, size: size)!
    }
    
    private class func bold(of size: CGFloat) -> UIFont {
        return UIFont(name: FontNames.bold.rawValue, size: size)!
    }
    
    private class func regular(of size: CGFloat) -> UIFont {
        return UIFont(name: FontNames.regular.rawValue, size: size)!
    }
    
    private class func light(of size: CGFloat) -> UIFont {
        return UIFont(name: FontNames.light.rawValue, size: size)!
    }
    
    private class func extraLight(of size: CGFloat) -> UIFont {
        return UIFont(name: FontNames.extraLight.rawValue, size: size)!
    }
    
    private class func thin(of size: CGFloat) -> UIFont {
        return UIFont(name: FontNames.thin.rawValue, size: size)!
    }
}
