//
//  ThreadSafe.swift
//  FlyUtils
//
//  Created by FlyKite on 2022/11/3.
//

import Foundation

@propertyWrapper
public class ThreadSafe<Value> {
    public var wrappedValue: Value {
        get { queue.sync { value } }
        set {
            queue.async(flags: .barrier) {
                self.value = newValue
            }
        }
    }
    
    private var value: Value
    private let queue: DispatchQueue = DispatchQueue(label: "com.FlyKite.FlyUtils.ThreadSafe", attributes: .concurrent)
    
    public init(wrappedValue value: Value) {
        self.value = value
    }
    
    public func transformValue(_ action: @escaping (inout Value) -> Void) {
        queue.async(flags: .barrier) {
            action(&self.value)
        }
    }
}
