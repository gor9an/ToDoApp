//
//  CancellableStorage.swift
//  ToDoApp
//
//  Created by Andrey Gordienko on 13.07.2024.
//

import Foundation

final class CancellableStorage: ICancellable, @unchecked Sendable {
    public enum State {
        case active
        case cancelled
        case deactivated
    }

    private let lock = NSLock()
    private var cancellables: [ICancellable] = []
    private var _state = State.active

    public var state: State {
        defer { lock.unlock() }
        lock.lock()

        return _state
    }

    public init() { }

    @discardableResult public func add(_ cancellable: ICancellable) -> Bool {
        lock.lock()

        switch _state {
        case .active:
            cancellables.append(cancellable)

            lock.unlock()

            return true

        case .cancelled:
            lock.unlock()

            cancellable.cancel()

            return false

        case .deactivated:
            lock.unlock()

            return false
        }
    }

    public func cancel() {
        lock.lock()

        if _state != State.active {
            return lock.unlock()
        }

        _state = State.cancelled

        let cancellable = self.cancellables

        lock.unlock()

        cancellable.forEach { $0.cancel() }
    }

    public func deactivate() -> Bool {
        lock.lock()

        if _state != State.active {
            lock.unlock()

            return false
        }

        _state = State.deactivated

        self.cancellables.removeAll()

        lock.unlock()

        return true
    }
}
