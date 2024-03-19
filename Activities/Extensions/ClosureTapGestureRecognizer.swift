//
//  ClosureGestureRecognizer.swift
//  Activities
//
//  Created by Chikinov Maxim on 16.03.2024.
//

import UIKit

final class ClosureTapGestureRecognizer: UITapGestureRecognizer {
    private var action: (UIGestureRecognizer.State) -> ()

    init(action: @escaping (UIGestureRecognizer.State) -> ()) {
        self.action = action
        super.init(target: nil, action: nil)
        self.addTarget(self, action: #selector(execute))
    }

    @objc private func execute() {
        action(self.state)
    }
}

final class ClosurePanGestureRecognizer: UIPanGestureRecognizer {
    private var action: (UIPanGestureRecognizer) -> ()

    init(action: @escaping (UIPanGestureRecognizer) -> ()) {
        self.action = action
        super.init(target: nil, action: nil)
        self.addTarget(self, action: #selector(execute))
    }

    @objc private func execute() {
        action(self)
    }
}

final class ClosureLongPressGestureRecognizer: UILongPressGestureRecognizer {
    private var action: (UILongPressGestureRecognizer) -> ()

    init(action: @escaping (UILongPressGestureRecognizer) -> ()) {
        self.action = action
        super.init(target: nil, action: nil)
        self.addTarget(self, action: #selector(execute))
    }

    @objc private func execute() {
        action(self)
    }
}

extension UIView {
    @discardableResult
    func addTapGesture(with closure: @escaping (UIGestureRecognizer.State) -> ()) -> UIGestureRecognizer {
        isUserInteractionEnabled = true
        let rec = ClosureTapGestureRecognizer(action: closure)
        self.addGestureRecognizer(rec)
        return rec
    }
    
    @discardableResult
    func addDoubleTapGesture(with closure: @escaping (UIGestureRecognizer.State) -> ()) -> UIGestureRecognizer {
        isUserInteractionEnabled = true
        let rec = ClosureTapGestureRecognizer(action: closure)
        rec.numberOfTapsRequired = 2
        self.addGestureRecognizer(rec)
        return rec
    }
    
    @discardableResult
    func addPanGesture(with closure: @escaping (UIPanGestureRecognizer) -> ()) -> UIGestureRecognizer {
        isUserInteractionEnabled = true
        let rec = ClosurePanGestureRecognizer(action: closure)
        self.addGestureRecognizer(rec)
        return rec
    }
    
    @discardableResult
    func addLongPressGesture(with closure: @escaping (UILongPressGestureRecognizer) -> ()) -> UIGestureRecognizer {
        isUserInteractionEnabled = true
        let rec = ClosureLongPressGestureRecognizer(action: closure)
        self.addGestureRecognizer(rec)
        return rec
    }
}
