//
//  UIControl+Extension.swift
//  Activities
//
//  Created by Chikinov Maxim on 16.03.2024.
//

import Foundation
import UIKit

extension UIControl {
    func addAction(for controlEvents: UIControl.Event = .touchUpInside, _ closure: @escaping () -> Void) {
        if #available(iOS 14.0, *) {
            addAction(UIAction { _ in closure() }, for: controlEvents)
        } else {
            let sleeve = ClosureSleeve(closure)
            addTarget(sleeve, action: #selector(sleeve.invoke), for: controlEvents)
            objc_setAssociatedObject(self, UUID().uuidString, sleeve, .OBJC_ASSOCIATION_RETAIN)
        }
    }
}

private class ClosureSleeve {
    let closure: () -> Void
    
    init(_ closure: @escaping () -> Void) {
        self.closure = closure
    }
    
    @objc func invoke() {
        closure()
    }
}
