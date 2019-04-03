//
//  UIImageView+Extension.swift
//  WakeUp
//
//  Created by Giray Gençaslan on 3.04.2019.
//  Copyright © 2019 Aslan Apps. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class UIImageViewExtension: UIImageView {
    
    @IBInspectable var isCircle: Bool {
        
        get { return self.isCircle }
        
        set {
            if self.isCircle {
                self.layer.cornerRadius = (self.layer.frame.size.width / 2)
                self.clipsToBounds = true
            }
            else {
                self.layer.cornerRadius = 0
                self.clipsToBounds = false
            }
        }
    }
}
