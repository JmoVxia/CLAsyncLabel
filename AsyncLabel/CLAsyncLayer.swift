//
//  CLAsyncLayer.swift
//  CLAsyncLabel
//
//  Created by Chen JmoVxia on 2024/6/6.
//

import UIKit

public protocol CLAsyncLayerDelegate {
    func display(will layer: CLAsyncLayer)

    func display(draw layer: CLAsyncLayer, at context: CGContext, with size: CGSize, isCancelled: () -> Bool)

    func display(did layer: CLAsyncLayer, with finished: Bool)
}

public extension CLAsyncLayerDelegate {
    func display(will layer: CLAsyncLayer) {}

    func display(did layer: CLAsyncLayer, with finished: Bool) {}
}

public class CLAsyncLayer: CALayer {
    var isAsynchronous: Bool = true

    private static let queues: [DispatchQueue] = {
        (0 ... $0).map { _ in DispatchQueue(label: "com.lee.async.render") }
    }(max(min(ProcessInfo().activeProcessorCount, 16), 1))

    private static var current = 0

    private static var display: DispatchQueue {
        objc_sync_enter(self)
        current += current == Int.max ? -current : 1
        objc_sync_exit(self)
        return queues[current % queues.count]
    }

    private var atomic = 0

    deinit {
        cancel()
    }
}

public extension CLAsyncLayer {
    override class func defaultValue(forKey key: String) -> Any? {
        guard key == "isAsynchronous" else { return super.defaultValue(forKey: key) }
        return true
    }

    override func setNeedsDisplay() {
        cancel()
        super.setNeedsDisplay()
    }

    override func display() {
        display(isAsynchronous)
    }

    func cancel() {
        objc_sync_enter(self)
        atomic += 1
        objc_sync_exit(self)
    }
}

extension CLAsyncLayer {
    private func display(_ async: Bool) {
        guard let delegate = delegate as? CLAsyncLayerDelegate else { return }

        delegate.display(will: self)

        if async {
            let size = bounds.size
            let opaque = isOpaque
            let scale = UIScreen.main.scale
            let background = (opaque && (backgroundColor != nil)) ? backgroundColor : nil

            let current = atomic
            let isCancelled = { current != self.atomic }

            CLAsyncLayer.display.async { [weak self] in
                guard let self else { return }
                guard !isCancelled() else { return }

                UIGraphicsBeginImageContextWithOptions(size, opaque, scale)
                guard let context = UIGraphicsGetCurrentContext() else { return }

                if opaque {
                    context.saveGState()
                    let rect = CGRect(x: 0, y: 0, width: size.width * scale, height: size.height * scale)
                    if background == nil || background?.alpha != 1 {
                        context.setFillColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
                        context.addRect(rect)
                        context.fillPath()
                    }
                    if let color = background {
                        context.setFillColor(color)
                        context.addRect(rect)
                        context.fillPath()
                    }
                    context.restoreGState()
                }

                delegate.display(draw: self, at: context, with: size, isCancelled: isCancelled)

                if isCancelled() {
                    UIGraphicsEndImageContext()
                    DispatchQueue.main.async {
                        delegate.display(did: self, with: false)
                    }
                    return
                }

                let image = UIGraphicsGetImageFromCurrentImageContext()
                if isCancelled() {
                    UIGraphicsEndImageContext()
                    DispatchQueue.main.async {
                        delegate.display(did: self, with: false)
                    }
                    return
                } else {
                    UIGraphicsEndImageContext()
                }

                DispatchQueue.main.async {
                    if isCancelled() {
                        delegate.display(did: self, with: false)
                    } else {
                        self.contents = image?.cgImage
                        delegate.display(did: self, with: true)
                    }
                }
            }

        } else {
            UIGraphicsBeginImageContextWithOptions(bounds.size, isOpaque, UIScreen.main.scale)
            guard let context = UIGraphicsGetCurrentContext() else { return }

            if isOpaque {
                var size = bounds.size
                size.width *= contentsScale
                size.height *= contentsScale
                context.saveGState()

                if backgroundColor == nil || backgroundColor!.alpha < 1 {
                    context.setFillColor(UIColor.white.cgColor)
                    context.addRect(CGRect(origin: .zero, size: size))
                    context.fillPath()
                }
                if let color = backgroundColor {
                    context.setFillColor(color)
                    context.addRect(CGRect(origin: .zero, size: size))
                    context.fillPath()
                }
                context.restoreGState()
            }

            delegate.display(draw: self, at: context, with: bounds.size) { false }

            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            contents = image?.cgImage
            delegate.display(did: self, with: true)
        }
    }
}
