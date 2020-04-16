//
//  GenericType.swift
//  PhotoFlikr
//
//  Created by Varun Tomar on 05/04/20.
//  Copyright © 2020 Tarun Tomar. All rights reserved.
//

import Foundation

class GenericType<T> {
    
    typealias ValueObserver = ((_ newValue: T) -> Void)
    
    var value: T {
        didSet {
            notify()
        }
    }
    
    var observer: ValueObserver!
    
    init(_ value: T) {
        self.value = value
    }
    
    func addObserverAndNotify(observer: @escaping ValueObserver) {
        self.observer = observer
        notify()
    }
    
    func notify() {
        self.observer(self.value)
    }
    
}
