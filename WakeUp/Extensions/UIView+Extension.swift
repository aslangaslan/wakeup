//
//  UIView+Extension.swift
//  WakeUp
//
//  Created by Giray Gençaslan on 2.04.2019.
//  Copyright © 2019 Aslan Apps. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class UIViewExtension: UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        get { return self.layer.cornerRadius }
        set { self.layer.cornerRadius = newValue }
    }
}
