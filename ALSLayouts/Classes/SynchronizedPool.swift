//
//  SynchronizedPool.swift
//  Pods
//
//  Created by Mariotaku Lee on 16/9/2.
//
//

import Foundation

class SynchronizedPool<T : AnyObject> {
    
    let lock: AnyObject = NSObject()
    let size: Int
    
    var items:[T] = [T]()
    
    init(size: Int) {
        self.size = size
    }
    
    func acquire() -> T? {
        return synchronized(lock) { () -> T? in
            return self.items.popLast()
        }
    }
    
    func release(obj: T) -> Bool {
        return synchronized(lock) { () -> Bool in
            if (self.items.contains { item in return item === obj }) {
                abort()
            }
            if (self.items.count < self.size) {
                self.items.append(obj)
                return true
            }
            return false
        }
    }
    
    private func synchronized<T>(lock:AnyObject, block:() -> T) -> T {
        objc_sync_enter(lock)
        defer {
            objc_sync_exit(lock)
        }
        
        return block()
    }
}