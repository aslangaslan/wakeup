//
//  Button+Extension.swift
//  WakeUp
//
//  Created by Giray Gençaslan on 28.03.2019.
//  Copyright © 2019 Aslan Apps. All rights reserved.
//

import UIKit

@IBDesignable class UIButtonExtension: UIButton {

    @IBInspectable var cornerRadius: CGFloat {
        get { return self.layer.cornerRadius }
        set { self.layer.cornerRadius = newValue }
    }
}
