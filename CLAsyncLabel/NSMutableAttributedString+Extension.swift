//
//  NSMutableAttributedString+Extension.swift
//  CKD
//
//  Created by Chen JmoVxia on 2021/3/26.
//  Copyright © 2021 JmoVxia. All rights reserved.
//

import UIKit

extension NSMutableAttributedString {
    /// 添加字符串并为此段添加对应的Attribute
    @discardableResult
    func addText(_ text: String, attributes: ((_ item: AttributesItem) -> Void)? = nil) -> NSMutableAttributedString {
        let item = AttributesItem()
        attributes?(item)
        append(NSMutableAttributedString(string: text, attributes: item.attributes))
        return self
    }

    /// 添加图片
    @discardableResult
    func addImage(_ image: UIImage?, bounds: CGRect, attributes: ((_ item: AttributesItem) -> Void)? = nil) -> NSMutableAttributedString {
        guard let image else { return self }
        append(NSAttributedString(image: image, bounds: bounds, attributes: attributes))
        return self
    }

    /// 添加Attribute作用于当前字符串
    @discardableResult
    func addAttributes(_ attributes: (_ item: AttributesItem) -> Void, rang: NSRange? = nil, replace: Bool = false) -> NSMutableAttributedString {
        let item = AttributesItem()
        attributes(item)
        enumerateAttributes(in: rang ?? NSRange(string.startIndex ..< string.endIndex, in: string), options: .reverse) { oldAttribute, oldRange, _ in
            var newAtt = oldAttribute
            for attribute in item.attributes where replace ? true : !oldAttribute.keys.contains(attribute.key) {
                newAtt[attribute.key] = attribute.value
            }
            addAttributes(newAtt, range: oldRange)
        }
        return self
    }

    /// 添加间隙
    @discardableResult
    func addPadding(_ padding: CGFloat) -> NSMutableAttributedString {
        let attch = NSTextAttachment()
        attch.bounds = .init(origin: .zero, size: .init(width: padding, height: 0))
        append(NSAttributedString(attachment: attch))
        return self
    }
}
