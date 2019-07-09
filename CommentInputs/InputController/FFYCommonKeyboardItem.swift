//
//  FFYCommonKeyboardItem.swift
//  FFF
//
//  Created by Just Do It on 2019/7/9.
//  Copyright © 2019 com.advance. All rights reserved.
//

import Foundation
import UIKit

protocol InputNormalElementViewDelegate {
    func normalElementClicked(element: InputNormalElement) ->Void
}

protocol InputExpandElementViewDelegate {
    func sendViewClicked() -> Void
    func expandElementClicked(element: InputExpandElement) ->Void
}

protocol InputElementProcol {
    var text: String? {get}
    var image: UIImage? {get}
}

enum InputNormalElement:String, InputElementProcol {
    
    case commentArea
    case collection
    case like
    case share
    
    var text: String? {
        switch self {
        case .commentArea:
            return nil
        default:
            return nil
        }
    }
    
    var image: UIImage? {
        switch self {
        case .commentArea:
            return UIImage(named: "comment_area_icon")
        case .collection:
            return UIImage(named: "")
        case .like:
            return UIImage(named: "unlike_icon_big")
        case .share:
            return UIImage(named: "comment_share_icon")
        }
    }
    
    //maybe have normal/select status
    func setStatus(normal: Bool = false) -> InputNormalElement {
        
        return self
    }
}

enum InputExpandElement:String, InputElementProcol{
    case send
    case repost
    case at
    case picture
    case emoji
    
    
    var text: String? {
        switch self {
        case .repost:
            return "Also Repost"
        case .send:
            return "Send"
        default:
            return nil
        }
    }
    
    var image: UIImage? {
        switch self {
            
        case .send:
            return UIImage(named: "")
        case .repost:
            return UIImage(named: "")
        case .at:
            return UIImage(named: "at_icon")
        case .picture:
            return UIImage(named: "")
        case .emoji:
            return UIImage(named: "emoji_icon")
        }
    }
}
