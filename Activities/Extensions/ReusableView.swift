//
//  ReusableView.swift
//  Winline
//
//  Created by Алексей Гущин on 30.11.2020.
//  Copyright © 2020 Grow App. All rights reserved.
//

import UIKit

protocol ReusableView: NSObjectProtocol {
    static var reuseID: String { get }
}

extension ReusableView {
    static var reuseID: String {
        String(describing: Self.self)
    }
}

protocol NibLoadable {
    static var nib: UINib { get }
    static var nibName: String { get }
}

extension NibLoadable where Self: UIView {
    static var nibName: String {
        return String(describing: self)
    }
    
    static var nib: UINib {
        return UINib(nibName: nibName, bundle: nil)
    }
}

extension UIView: ReusableView {}

extension UITableView {
    
    func register(cell: ReusableView.Type) {
        register(cell, forCellReuseIdentifier: cell.reuseID)
    }
    
    func register(_ cell: (ReusableView & NibLoadable).Type) {
        register(cell.nib, forCellReuseIdentifier: cell.reuseID)
    }
    
    func register(headerFooterView: ReusableView.Type) {
        register(headerFooterView, forHeaderFooterViewReuseIdentifier: headerFooterView.reuseID)
    }
    
//    func dequeueCell<CellType: ReusableView>(cell: ReusableView.Type, for indexPath: IndexPath) -> CellType? {
//        return dequeueReusableCell(withIdentifier: cell.reuseID, for: indexPath) as? CellType
//    }
    
    func dequeueCell<CellType: ReusableView>(for indexPath: IndexPath) -> CellType {
        return dequeueReusableCell(withIdentifier: CellType.reuseID, for: indexPath) as! CellType
    }
    
    func dequeueHeaderFooter<HeaderFooterType: ReusableView>() -> HeaderFooterType {
        return dequeueReusableHeaderFooterView(withIdentifier: HeaderFooterType.reuseID) as! HeaderFooterType
    }
}

extension UICollectionView {
    func register(cell: ReusableView.Type) {
        register(cell, forCellWithReuseIdentifier: cell.reuseID)
    }
    
    func register(_ cell: (ReusableView & NibLoadable).Type) {
        register(cell.nib, forCellWithReuseIdentifier: cell.reuseID)
    }
    
    func register(_ cell: (ReusableView & NibLoadable).Type, forSupplementaryViewOfKind: String) {
        register(cell.nib, forSupplementaryViewOfKind: forSupplementaryViewOfKind, withReuseIdentifier: cell.reuseID)
    }
    
    func dequeueReusableCell<CellType: UICollectionViewCell>(withType cellType: CellType.Type, for indexPath: IndexPath) -> CellType {
        return self.dequeueReusableCell(withReuseIdentifier: self.identifier(for: cellType), for: indexPath) as! CellType
    }
    
    func dequeueReusableSupplementaryView<CellType: UICollectionReusableView>(ofKind elementKind: String, withType cellType: CellType.Type, for indexPath: IndexPath) -> CellType {
        return self.dequeueReusableSupplementaryView(ofKind: elementKind, withReuseIdentifier: self.identifier(for: cellType), for: indexPath) as! CellType
    }
    
    func dequeueCell<CellType: ReusableView>(for indexPath: IndexPath) -> CellType {
        return dequeueReusableCell(withReuseIdentifier: CellType.reuseID, for: indexPath) as! CellType
    }
    
    private func identifier<CellType: UICollectionViewCell>(for cellType: CellType.Type) -> String {
        let id = "\(String(describing: cellType))"
        return id
    }
    
    private func identifier<CellType: UICollectionReusableView>(for cellType: CellType.Type) -> String {
        let id = "\(String(describing: cellType))"
        return id
    }
}

extension UITableView {
    func register<CellType: UITableViewCell>(cellType: CellType.Type) {
        self.register(cellType, forCellReuseIdentifier: self.identifier(for: cellType))
    }
//
    func dequeueReusableCell<CellType: UITableViewCell>(withType cellType: CellType.Type, for indexPath: IndexPath) -> CellType {
        return self.dequeueReusableCell(withIdentifier: self.identifier(for: cellType), for: indexPath) as! CellType
    }
    
    private func identifier<CellType: UITableViewCell>(for cellType: CellType.Type) -> String {
        let id = "\(String(describing: cellType))"
        return id
    }
}

extension UITableViewCell {
    static var reuseID: String {
        String(describing: Self.self)
    }
}
