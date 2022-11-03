//
//  Listenable.swift
//  FlyUtils
//
//  Created by FlyKite on 2022/11/3.
//

import Foundation

fileprivate protocol ListenerDelegate: AnyObject {
    func onListenerDeinit(_ listenerIdentifier: UUID)
}

public class Listener<Value> {
    fileprivate let identifier: UUID = UUID()
    fileprivate let onChange: (Value) -> Void
    fileprivate weak var delegate: ListenerDelegate?
    
    fileprivate init(onChange: @escaping (Value) -> Void) {
        self.onChange = onChange
    }
    
    deinit {
        delegate?.onListenerDeinit(identifier)
    }
}

@propertyWrapper
public class Listenable<Value>: ListenerDelegate {
    public var wrappedValue: Value {
        get { value }
        set {
            value = newValue
            notifyListeners(newValue)
        }
    }
    private var value: Value
    
    private var listeners: [UUID: ListenerWeakContainer] = [:]
    private let queue: DispatchQueue = DispatchQueue(label: "com.FlyKite.FlyUtils.Listenable")
    
    public init(wrappedValue value: Value) {
        self.value = value
    }
    
    public func listen(onChange: @escaping (Value) -> Void) -> Listener<Value> {
        let listener = Listener(onChange: onChange)
        listener.delegate = self
        let container = ListenerWeakContainer(listener: listener)
        queue.async(flags: .barrier) {
            self.listeners[listener.identifier] = container
        }
        onChange(value)
        return listener
    }
    
    private func notifyListeners(_ newValue: Value) {
        let listeners = queue.sync { self.listeners }
        for (_, container) in listeners {
            container.listener?.onChange(newValue)
        }
    }
    
    func onListenerDeinit(_ listenerIdentifier: UUID) {
        queue.async(flags: .barrier) {
            self.listeners[listenerIdentifier] = nil
        }
    }
    
    private class ListenerWeakContainer {
        weak var listener: Listener<Value>?
        
        init(listener: Listener<Value>) {
            self.listener = listener
        }
    }
}
