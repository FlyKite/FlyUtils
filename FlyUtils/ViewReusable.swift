//
//  ViewReusable.swift
//  FlyUtils
//
//  Created by FlyKite on 2022/10/24.
//

import UIKit

protocol ViewReusable {
    static var reuseIdentifier: String { get }
}

extension ViewReusable {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: ViewReusable { }

extension UICollectionReusableView: ViewReusable { }

extension UITableViewHeaderFooterView: ViewReusable { }

public struct CellHandler<V> {
    let view: V
    init(view: V) {
        self.view = view
    }
}

extension UITableView {
    public var ch: CellHandler<UITableView> {
        return CellHandler<UITableView>(view: self)
    }
}

extension UICollectionView {
    public var ch: CellHandler<UICollectionView> {
        return CellHandler<UICollectionView>(view: self)
    }
}

extension CellHandler where V: UITableView {
    public func register<T: UITableViewCell>(_ cellType: T.Type) {
        if Bundle.main.path(forResource: cellType.reuseIdentifier, ofType: "nib") != nil {
            view.register(UINib(nibName: cellType.reuseIdentifier, bundle: Bundle.main),
                          forCellReuseIdentifier: cellType.reuseIdentifier)
        } else {
            view.register(cellType, forCellReuseIdentifier: cellType.reuseIdentifier)
        }
    }
    
    public func dequeueReusableCell<T: UITableViewCell>(_ cellType: T.Type) -> T? {
        return view.dequeueReusableCell(withIdentifier: cellType.reuseIdentifier) as? T
    }
    
    public func dequeueReusableCell<T: UITableViewCell>(_ cellType: T.Type, for indexPath: IndexPath) -> T {
        if let cell = view.dequeueReusableCell(withIdentifier: cellType.reuseIdentifier, for: indexPath) as? T {
            return cell
        } else {
            fatalError("Dequeue cell failed at (row: \(indexPath.item), section: \(indexPath.section))")
        }
    }
    
    public func register<T: UITableViewHeaderFooterView>(_ viewType: T.Type) {
        if Bundle.main.path(forResource: viewType.reuseIdentifier, ofType: "nib") != nil {
            view.register(UINib(nibName: viewType.reuseIdentifier, bundle: Bundle.main),
                          forHeaderFooterViewReuseIdentifier: viewType.reuseIdentifier)
        } else {
            view.register(viewType, forHeaderFooterViewReuseIdentifier: viewType.reuseIdentifier)
        }
    }
    
    public func dequeueReusableView<T: UITableViewHeaderFooterView>(_ viewType: T.Type) -> T? {
        return view.dequeueReusableHeaderFooterView(withIdentifier: viewType.reuseIdentifier) as? T
    }
}

public enum UICollectionViewElementKind {
    case sectionHeader
    case sectionFooter
    
    fileprivate var elementKind: String {
        switch self {
        case .sectionHeader: return UICollectionView.elementKindSectionHeader
        case .sectionFooter: return UICollectionView.elementKindSectionFooter
        }
    }
}

extension CellHandler where V: UICollectionView {
    
    public func register<T: UICollectionViewCell>(_ cellType: T.Type) {
        if Bundle.main.path(forResource: cellType.reuseIdentifier, ofType: "nib") != nil {
            view.register(UINib(nibName: cellType.reuseIdentifier, bundle: Bundle.main),
                          forCellWithReuseIdentifier: cellType.reuseIdentifier)
        } else {
            view.register(cellType, forCellWithReuseIdentifier: cellType.reuseIdentifier)
        }
    }
    
    public func register<T: UICollectionReusableView>(_ viewType: T.Type, forSupplementaryViewOfKind: String) {
        if Bundle.main.path(forResource: viewType.reuseIdentifier, ofType: "nib") != nil {
            view.register(UINib(nibName: viewType.reuseIdentifier, bundle: Bundle.main),
                          forSupplementaryViewOfKind: forSupplementaryViewOfKind,
                          withReuseIdentifier: viewType.reuseIdentifier)
        } else {
            view.register(viewType, forSupplementaryViewOfKind: forSupplementaryViewOfKind, withReuseIdentifier: viewType.reuseIdentifier)
        }
    }
    
    public func dequeueReusableCell<T: UICollectionViewCell>(_ cellType: T.Type, for indexPath: IndexPath) -> T {
        if let cell = view.dequeueReusableCell(withReuseIdentifier: cellType.reuseIdentifier, for: indexPath) as? T {
            return cell
        } else {
            fatalError("Dequeue cell failed at (item: \(indexPath.item), section: \(indexPath.section))")
        }
    }
    
    public func dequeueReusableSupplementaryView<T: UICollectionReusableView>(_ viewType: T.Type, ofKind: String, for indexPath: IndexPath) -> T {
        if let view = view.dequeueReusableSupplementaryView(ofKind: ofKind, withReuseIdentifier: viewType.reuseIdentifier, for: indexPath) as? T {
            return view
        } else {
            fatalError("Dequeue view failed at (item: \(indexPath.item), section: \(indexPath.section))")
        }
    }
    
    public func register<T: UICollectionReusableView>(_ viewType: T.Type, ofKind kind: UICollectionViewElementKind) {
        if Bundle.main.path(forResource: viewType.reuseIdentifier, ofType: "nib") != nil {
            view.register(UINib(nibName: viewType.reuseIdentifier, bundle: Bundle.main),
                          forSupplementaryViewOfKind: kind.elementKind,
                          withReuseIdentifier: viewType.reuseIdentifier)
        } else {
            view.register(viewType, forSupplementaryViewOfKind: kind.elementKind, withReuseIdentifier: viewType.reuseIdentifier)
        }
    }
    
    public func dequeueReusableSupplementaryView<T: UICollectionReusableView>(_ viewType: T.Type,
                                                                       ofKind kind: UICollectionViewElementKind,
                                                                       for indexPath: IndexPath) -> T {
        if let view = view.dequeueReusableSupplementaryView(ofKind: kind.elementKind,
                                                            withReuseIdentifier: viewType.reuseIdentifier,
                                                            for: indexPath) as? T {
            return view
        } else {
            fatalError("Dequeue supplementary view failed at (item: \(indexPath.item), section: \(indexPath.section))")
        }
    }
    
}
