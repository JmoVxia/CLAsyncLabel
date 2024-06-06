//
//  AsyncLabelCell.swift
//  CLAsyncLabel
//
//  Created by 菜鸽途讯 on 2025/9/28.
//

import UIKit

// MARK: - JmoVxia---类-属性

class AsyncLabelCell: UITableViewCell {
    static let reuseIdentifier = "AsyncLabelCell"

    private lazy var asyncLabel: CLAsyncLabel = {
        let label = CLAsyncLabel()
        label.numberOfLines = 0
        label.backgroundColor = .clear
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        makeConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - JmoVxia---布局

private extension AsyncLabelCell {
    func setupUI() {
        selectionStyle = .none
        contentView.addSubview(asyncLabel)
    }

    func makeConstraints() {
        asyncLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(15)
        }
    }
}

// MARK: - JmoVxia---override

extension AsyncLabelCell {
    override func prepareForReuse() {
        super.prepareForReuse()
        asyncLabel.attributedText = nil
        asyncLabel.layer.contents = nil
    }
}

// MARK: - JmoVxia---objc

@objc private extension AsyncLabelCell {}

// MARK: - JmoVxia---私有方法

private extension AsyncLabelCell {}

// MARK: - JmoVxia---公共方法

extension AsyncLabelCell {
    func configure(with attributedText: NSAttributedString) {
        asyncLabel.attributedText = attributedText
    }
}
