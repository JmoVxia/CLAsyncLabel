//
//  CLAsyncLabel.swift
//  CLAsyncLabel
//
//  Created by Chen JmoVxia on 2024/6/6.
//

import UIKit

// MARK: - JmoVxia---枚举

extension CLAsyncLabel {}

// MARK: - JmoVxia---类-属性

public class CLAsyncLabel: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        makeConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public var attributedText: NSAttributedString? {
        didSet { updateTextAttributes() }
    }

    public var numberOfLines: Int = 0 {
        didSet { updateTextAttributes() }
    }

    public var preferredMaxLayoutWidth: CGFloat = 0 {
        didSet { updateTextAttributes() }
    }

    public var isAsynchronous: Bool {
        set { (layer as? CLAsyncLayer)?.isAsynchronous = newValue }
        get { (layer as? CLAsyncLayer)?.isAsynchronous ?? false }
    }
}

// MARK: - JmoVxia---布局

private extension CLAsyncLabel {
    func setupUI() {}

    func makeConstraints() {}
}

// MARK: - JmoVxia---override

public extension CLAsyncLabel {
    override class var layerClass: AnyClass {
        CLAsyncLayer.self
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        updateTextAttributes()
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        guard let attributedString = attributedText else { return .zero }
        let constrainedSize = size == .zero ? CGSize(width: preferredMaxLayoutWidth > 0 ? preferredMaxLayoutWidth : .greatestFiniteMagnitude, height: .greatestFiniteMagnitude) : CGSize(width: preferredMaxLayoutWidth > 0 ? min(size.width, preferredMaxLayoutWidth) : size.width, height: .greatestFiniteMagnitude)
        let framesetter = CTFramesetterCreateWithAttributedString(attributedString)
        let range: CFRange = {
            var range = CFRangeMake(0, 0)
            let path = CGPath(rect: CGRect(origin: .zero, size: constrainedSize), transform: nil)
            let frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, nil)
            guard let lines = CTFrameGetLines(frame) as? [CTLine] else { return range }
            let lineCount = min(numberOfLines, lines.count)
            guard lineCount > 0 else { return range }
            let lastLine = lines[lineCount - 1]
            range = CTLineGetStringRange(lastLine)
            return range
        }()
        let suggestedSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, range.location + range.length), nil, constrainedSize, nil)
        return CGSize(width: ceil(suggestedSize.width), height: ceil(suggestedSize.height))
    }

    override var intrinsicContentSize: CGSize {
        sizeThatFits(.init(width: bounds.width, height: .greatestFiniteMagnitude))
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateTextAttributes()
    }
}

// MARK: - JmoVxia---objc

@objc private extension CLAsyncLabel {
    func updateDisplay() {
        invalidateIntrinsicContentSize()
        layer.setNeedsDisplay()
    }
}

// MARK: - JmoVxia---私有方法

private extension CLAsyncLabel {
    func updateTextAttributes() {
        CLTransaction.commit(self, with: #selector(updateDisplay))
    }
}

// MARK: - JmoVxia---公共方法

extension CLAsyncLabel {}

extension CLAsyncLabel: CLAsyncLayerDelegate {
    public func display(draw layer: CLAsyncLayer, at context: CGContext, with size: CGSize, isCancelled: () -> Bool) {
        guard let attributedString = attributedText else { return }
        context.textMatrix = .identity
        context.translateBy(x: 0, y: size.height)
        context.scaleBy(x: 1, y: -1)

        let textPath = CGMutablePath()
        textPath.addRect(CGRect(origin: .zero, size: size))
        context.addPath(textPath)

        let framesetter = CTFramesetterCreateWithAttributedString(attributedString)
        let frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), textPath, nil)
        CTFrameDraw(frame, context)
    }
}
