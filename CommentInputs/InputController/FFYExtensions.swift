//
//  FFYExtensions.swift
//  FFF
//
//  Created by Just Do It on 2019/7/9.
//  Copyright © 2019 com.advance. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    convenience init(hex: UInt32, alpha: CGFloat = 1) {
        let r: CGFloat = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        let g: CGFloat = CGFloat((hex & 0x00FF00) >> 8) / 255.0
        let b: CGFloat = CGFloat((hex & 0x0000FF)) / 255.0
        self.init(red: r, green: g, blue: b, alpha: alpha)
    }
}

extension UIColor {
    struct ffy {
       
        struct blue {
            static let light  : UIColor = .init(hex: 0xE0E4F0)
            static let primary: UIColor = .init(hex: 0x4499DD)
            static let medium : UIColor = .init(hex: 0x3066FF)
            static let facebook: UIColor = .init(hex: 0x3A559F)
            static let userName: UIColor = .init(hex: 0x5F98C4)
            static let commentSend: UIColor = .init(hex: 0x5F98C4)
        }
        
        struct green {
            static let light    : UIColor = .init(hex: 0xCCDDCC)
            static let correct  : UIColor = .init(hex: 0x55BB10)
            static let highlight: UIColor = .init(hex: 0x7CC633, alpha: 22.0 / 255.0)
            static let game     : UIColor = .init(hex: 0x5CC414)
            static let support  : UIColor = .init(hex: 0x23C325)
            static let followBg: UIColor  = .init(hex: 0x45b55c)
        }
        
        struct white {
            static let alpha86: UIColor = .init(hex: 0xFFFFFF, alpha: 86.0 / 100.0)
            static let alpha72: UIColor = .init(hex: 0xFFFFFF, alpha: 72.0 / 100.0)
            static let alpha54: UIColor = .init(hex: 0xFFFFFF, alpha: 54.0 / 100.0)
            static let alpha30: UIColor = .init(hex: 0xFFFFFF, alpha: 30.0 / 100.0)
            static let alpha16: UIColor = .init(hex: 0xFFFFFF, alpha: 16.0 / 100.0)
            static let alpha15: UIColor = .init(hex: 0xFFFFFF, alpha: 15.0 / 100.0)
        }
        
        struct black {
            static let alpha87: UIColor = .init(hex: 0x000000, alpha: 87.0 / 100.0)
            static let alpha80: UIColor = .init(hex: 0x000000, alpha: 80.0 / 100.0)
            static let alpha56: UIColor = .init(hex: 0x000000, alpha: 56.0 / 100.0)
            static let alpha50: UIColor = .init(hex: 0x000000, alpha: 50.0 / 100.0)
            static let alpha40: UIColor = .init(hex: 0x000000, alpha: 40.0 / 100.0)
            static let alpha38: UIColor = .init(hex: 0x000000, alpha: 38.0 / 100.0)
            static let alpha30: UIColor = .init(hex: 0x000000, alpha: 30.0 / 100.0)
            static let alpha24: UIColor = .init(hex: 0x000000, alpha: 24.0 / 100.0)
            static let alpha20: UIColor = .init(hex: 0x000000, alpha: 20.0 / 100.0)
            
            /// Almost as dark as UIColor.black: 0x212121.
            static let dark  : UIColor = .init(hex: 0x212121)
            static let light : UIColor = .init(hex: 0x414042)
            static let option: UIColor = .init(hex: 0x232323)
            static let defaultDialog: UIColor = .init(hex: 0x000000, alpha: 153.0 / 255.0)
            static let customDialog : UIColor = .init(hex: 0x101010, alpha: 192.0 / 255.0)
        }
        
        
        
        struct gray {
            static let gray : UIColor = .init(hex: 0x999999)
            static let light: UIColor = .init(hex: 0xFBFBFB)
            static let dark : UIColor = .init(hex: 0x666666)
            
            static let secondary : UIColor = .init(hex: 0xBDBDBD)
            static let tertiary  : UIColor = .init(hex: 0xDDDDDD)
            static let quaternary: UIColor = .init(hex: 0xEEEEEE)
            
            static let chateau  : UIColor = .init(hex: 0xA3A3A3)
            static let highlight: UIColor = .init(hex: 0xE8E8E8)
            
            static let hex88: UIColor = .init(hex: 0x888888)
            static let hexBB: UIColor = .init(hex: 0xbbbbbb)
            
            static let background     : UIColor = .init(hex: 0xF5F5F5)
            static let forumBackground: UIColor = .init(hex: 0xF0F0F0)
            
            static let placeholder: UIColor = .init(hex: 0xF5F5F5)
            
            static let commentGray: UIColor = .init(hex: 0x6D7278)
            static let inputBackground: UIColor = .init(hex: 0xf3f3f3)
            static let tableViewBackground: UIColor = .init(hex: 0xf5f5f5)
            
            static let commentNormal: UIColor = .init(hex: 0xC9C9C9)
            static let sepratorGray: UIColor = UIColor(hex: 0xEDEDED, alpha: 0.8)
        }
        
        struct red {
            static let like    : UIColor = #colorLiteral(red: 0.9411764706, green: 0.4, blue: 0.3333333333, alpha: 1)
            static let exit    : UIColor = #colorLiteral(red: 0.9960784314, green: 0.231372549, blue: 0.231372549, alpha: 1)
        }
        
        struct orange {
            static let primary  : UIColor = .init(hex: 0xF99E22)
            static let secondary: UIColor = .init(hex: 0xF6E6A6)
            static let light    : UIColor = .init(hex: 0xFFF5E8)
        }
        
        
    }
}

