//
//  CLTransaction.swift
//  CLAsyncLabel
//
//  Created by Chen JmoVxia on 2024/6/6.
//

import Foundation

enum CLTransaction {}

extension CLTransaction {
    static func commit(_ target: AnyObject, with selector: Selector) {
        let item = Item(target, with: selector)
        CLTransaction.setup
        waits.insert(item)
    }
}

extension CLTransaction {
    private static var waits: Set<Item> = []

    private static let setup: Void = {
        let runloop = CFRunLoopGetCurrent()
        let observer = CFRunLoopObserverCreate(
            kCFAllocatorDefault,
            CFRunLoopActivity.beforeWaiting.rawValue | CFRunLoopActivity.exit.rawValue,
            true,
            0xFFFFFF,
            callback,
            nil
        )
        CFRunLoopAddObserver(runloop, observer, .commonModes)
    }()

    private static let callback: CFRunLoopObserverCallBack = { _, _, _ in
        waits.forEach { _ = $0.target.perform($0.selector) }
        waits = []
    }
}

extension CLTransaction {
    private struct Item: Hashable {
        let target: AnyObject
        let selector: Selector

        init(_ target: AnyObject, with selector: Selector) {
            self.target = target
            self.selector = selector
        }

        func hash(into hasher: inout Hasher) {
            hasher.combine(target.hash)
            hasher.combine(selector)
        }

        static func == (lhs: CLTransaction.Item, rhs: CLTransaction.Item) -> Bool {
            lhs.target === rhs.target && lhs.selector == rhs.selector
        }
    }
}
