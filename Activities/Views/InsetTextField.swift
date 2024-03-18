//
//  InsetTextField.swift
//  Activities
//
//  Created by Chikinov Maxim on 18.03.2024.
//

import Foundation
import UIKit

class InsetTextField: UITextField {
    var insets: UIEdgeInsets

    init(insets: UIEdgeInsets) {
        self.insets = insets
        super.init(frame: .zero)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("not intended for use from a NIB")
    }

    // placeholder position
    override func textRect(forBounds bounds: CGRect) -> CGRect {
         return super.textRect(forBounds: bounds.inset(by: insets))
    }
 
    // text position
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
         return super.editingRect(forBounds: bounds.inset(by: insets))
    }
}

extension UITextField {
    class func textFieldWithInsets(insets: UIEdgeInsets) -> UITextField {
        return InsetTextField(insets: insets)
    }
}
