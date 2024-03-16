//
//  NSLayoutConstraint+Operators.swift
//  Activities
//
//  Created by Chikinov Maxim on 16.03.2024.
//

import Foundation
import UIKit

func ==(lhs: NSLayoutXAxisAnchor, rhs: NSLayoutXAxisAnchor) -> NSLayoutConstraint {
    return lhs.constraint(equalTo: rhs)
}

func >=(lhs: NSLayoutXAxisAnchor, rhs: NSLayoutXAxisAnchor) -> NSLayoutConstraint {
    return lhs.constraint(greaterThanOrEqualTo: rhs)
}

func <=(lhs: NSLayoutXAxisAnchor, rhs: NSLayoutXAxisAnchor) -> NSLayoutConstraint {
    return lhs.constraint(lessThanOrEqualTo: rhs)
}

func ==(lhs: NSLayoutYAxisAnchor, rhs: NSLayoutYAxisAnchor) -> NSLayoutConstraint {
    return lhs.constraint(equalTo: rhs)
}

func >=(lhs: NSLayoutYAxisAnchor, rhs: NSLayoutYAxisAnchor) -> NSLayoutConstraint {
    return lhs.constraint(greaterThanOrEqualTo: rhs)
}

func <=(lhs: NSLayoutYAxisAnchor, rhs: NSLayoutYAxisAnchor) -> NSLayoutConstraint {
    return lhs.constraint(lessThanOrEqualTo: rhs)
}

func ==(lhs: NSLayoutDimension, rhs: CGFloat) -> NSLayoutConstraint {
    return lhs.constraint(equalToConstant: rhs)
}

func >=(lhs: NSLayoutDimension, rhs: CGFloat) -> NSLayoutConstraint {
    return lhs.constraint(greaterThanOrEqualToConstant: rhs)
}

func <=(lhs: NSLayoutDimension, rhs: CGFloat) -> NSLayoutConstraint {
    return lhs.constraint(lessThanOrEqualToConstant: rhs)
}

struct LayoutTerm<AnchorType> where AnchorType : AnyObject {
    let anchor: NSLayoutAnchor<AnchorType>
    let constant: CGFloat
}

func +(lhs: NSLayoutXAxisAnchor, rhs: CGFloat) -> LayoutTerm<NSLayoutXAxisAnchor> {
    return LayoutTerm<NSLayoutXAxisAnchor>(anchor: lhs, constant: rhs)
}

func +(lhs: LayoutTerm<NSLayoutXAxisAnchor>, rhs: CGFloat) -> LayoutTerm<NSLayoutXAxisAnchor> {
    return LayoutTerm<NSLayoutXAxisAnchor>(anchor: lhs.anchor, constant: lhs.constant + rhs)
}

func -(lhs: NSLayoutXAxisAnchor, rhs: CGFloat) -> LayoutTerm<NSLayoutXAxisAnchor> {
    return LayoutTerm<NSLayoutXAxisAnchor>(anchor: lhs, constant: -rhs)
}

func -(lhs: LayoutTerm<NSLayoutXAxisAnchor>, rhs: CGFloat) -> LayoutTerm<NSLayoutXAxisAnchor> {
    return LayoutTerm<NSLayoutXAxisAnchor>(anchor: lhs.anchor, constant: lhs.constant - rhs)
}

func +(lhs: NSLayoutYAxisAnchor, rhs: CGFloat) -> LayoutTerm<NSLayoutYAxisAnchor> {
    return LayoutTerm<NSLayoutYAxisAnchor>(anchor: lhs, constant: rhs)
}

func +(lhs: LayoutTerm<NSLayoutYAxisAnchor>, rhs: CGFloat) -> LayoutTerm<NSLayoutYAxisAnchor> {
    return LayoutTerm<NSLayoutYAxisAnchor>(anchor: lhs.anchor, constant: lhs.constant + rhs)
}

func -(lhs: NSLayoutYAxisAnchor, rhs: CGFloat) -> LayoutTerm<NSLayoutYAxisAnchor> {
    return LayoutTerm<NSLayoutYAxisAnchor>(anchor: lhs, constant: -rhs)
}

func -(lhs: LayoutTerm<NSLayoutYAxisAnchor>, rhs: CGFloat) -> LayoutTerm<NSLayoutYAxisAnchor> {
    return LayoutTerm<NSLayoutYAxisAnchor>(anchor: lhs.anchor, constant: lhs.constant - rhs)
}

func ==(lhs: NSLayoutXAxisAnchor, rhs: LayoutTerm<NSLayoutXAxisAnchor>) -> NSLayoutConstraint {
    return lhs.constraint(equalTo: rhs.anchor, constant: rhs.constant)
}

func >=(lhs: NSLayoutXAxisAnchor, rhs: LayoutTerm<NSLayoutXAxisAnchor>) -> NSLayoutConstraint {
    return lhs.constraint(greaterThanOrEqualTo: rhs.anchor, constant: rhs.constant)
}

func <=(lhs: NSLayoutXAxisAnchor, rhs: LayoutTerm<NSLayoutXAxisAnchor>) -> NSLayoutConstraint {
    return lhs.constraint(lessThanOrEqualTo: rhs.anchor, constant: rhs.constant)
}

func ==(lhs: NSLayoutYAxisAnchor, rhs: LayoutTerm<NSLayoutYAxisAnchor>) -> NSLayoutConstraint {
    return lhs.constraint(equalTo: rhs.anchor, constant: rhs.constant)
}

func >=(lhs: NSLayoutYAxisAnchor, rhs: LayoutTerm<NSLayoutYAxisAnchor>) -> NSLayoutConstraint {
    return lhs.constraint(greaterThanOrEqualTo: rhs.anchor, constant: rhs.constant)
}

func <=(lhs: NSLayoutYAxisAnchor, rhs: LayoutTerm<NSLayoutYAxisAnchor>) -> NSLayoutConstraint {
    return lhs.constraint(lessThanOrEqualTo: rhs.anchor, constant: rhs.constant)
}

struct LayoutFactor {
    let anchor: NSLayoutDimension
    let multiplier: CGFloat
    let constant: CGFloat
    
    init(anchor: NSLayoutDimension, multiplier: CGFloat) {
        self.anchor = anchor
        self.multiplier = multiplier
        self.constant = 0.0
    }
    
    init(anchor: NSLayoutDimension, multiplier: CGFloat, constant: CGFloat) {
        self.anchor = anchor
        self.multiplier = multiplier
        self.constant = constant
    }
}

func *(lhs: NSLayoutDimension, rhs: CGFloat) -> LayoutFactor {
    return LayoutFactor(anchor: lhs, multiplier: rhs)
}

func *(lhs: CGFloat, rhs: NSLayoutDimension) -> LayoutFactor {
    return rhs * lhs
}

func /(lhs: NSLayoutDimension, rhs: CGFloat) -> LayoutFactor {
    return LayoutFactor(anchor: lhs, multiplier: 1.0 / rhs)
}

func *(lhs: LayoutFactor, rhs: CGFloat) -> LayoutFactor {
    return LayoutFactor(anchor: lhs.anchor, multiplier: lhs.multiplier * rhs)
}

func *(lhs: CGFloat, rhs: LayoutFactor) -> LayoutFactor {
    return rhs * lhs
}

func /(lhs: LayoutFactor, rhs: CGFloat) -> LayoutFactor {
    return LayoutFactor(anchor: lhs.anchor, multiplier: lhs.multiplier / rhs)
}

func +(lhs: NSLayoutDimension, rhs: CGFloat) -> LayoutFactor {
    return LayoutFactor(anchor: lhs, multiplier: 1.0, constant: rhs)
}

func -(lhs: NSLayoutDimension, rhs: CGFloat) -> LayoutFactor {
    return LayoutFactor(anchor: lhs, multiplier: 1.0, constant: -rhs)
}

func +(lhs: LayoutFactor, rhs: CGFloat) -> LayoutFactor {
    return LayoutFactor(anchor: lhs.anchor, multiplier: lhs.multiplier, constant: lhs.constant + rhs)
}

func -(lhs: LayoutFactor, rhs: CGFloat) -> LayoutFactor {
    return LayoutFactor(anchor: lhs.anchor, multiplier: lhs.multiplier, constant: lhs.constant - rhs)
}

func ==(lhs: NSLayoutDimension, rhs: LayoutFactor) -> NSLayoutConstraint {
    return lhs.constraint(equalTo: rhs.anchor, multiplier: rhs.multiplier, constant: rhs.constant)
}

func ==(lhs: NSLayoutDimension, rhs: NSLayoutDimension) -> NSLayoutConstraint {
    return lhs.constraint(equalTo: rhs, multiplier: 1.0, constant: 0.0)
}

func >=(lhs: NSLayoutDimension, rhs: LayoutFactor) -> NSLayoutConstraint {
    return lhs.constraint(greaterThanOrEqualTo: rhs.anchor, multiplier: rhs.multiplier, constant: rhs.constant)
}

func >=(lhs: NSLayoutDimension, rhs: NSLayoutDimension) -> NSLayoutConstraint {
    return lhs.constraint(greaterThanOrEqualTo: rhs)
}

func <=(lhs: NSLayoutDimension, rhs: LayoutFactor) -> NSLayoutConstraint {
    return lhs.constraint(lessThanOrEqualTo: rhs.anchor, multiplier: rhs.multiplier, constant: rhs.constant)
}

func <=(lhs: NSLayoutDimension, rhs: NSLayoutDimension) -> NSLayoutConstraint {
    return lhs.constraint(lessThanOrEqualTo: rhs)
}

/// Basically same as the usual assignment, but also returns assigned value instead of ().
infix operator <-: AssignmentPrecedence
func <-(lhs: inout NSLayoutConstraint!, rhs: NSLayoutConstraint) -> NSLayoutConstraint {
    lhs = rhs
    return lhs
}

infix operator ~: ConstraintPriorityPrecedence
precedencegroup ConstraintPriorityPrecedence {
    higherThan: AssignmentPrecedence
    lowerThan: ComparisonPrecedence
    associativity: left
}

func ~(lhs: NSLayoutConstraint, rhs: UILayoutPriority) -> NSLayoutConstraint {
    lhs.priority = rhs
    return lhs
}
