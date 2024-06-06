//
//  ViewController.swift
//  CLAsyncLabel
//
//  Created by Chen JmoVxia on 2024/6/6.
//

import SnapKit
import UIKit

// MARK: - JmoVxia---类-属性

class ViewController: UIViewController {
    deinit {}

    private lazy var label1: CLAsyncLabel = {
        let view = CLAsyncLabel()
        view.numberOfLines = 0
        view.backgroundColor = .orange.withAlphaComponent(0.35)
        return view
    }()

    private lazy var label2: CLAsyncLabel = {
        let view = CLAsyncLabel()
        view.numberOfLines = 0
        view.backgroundColor = .red.withAlphaComponent(0.35)
        return view
    }()

    private lazy var label3: CLAsyncLabel = {
        let view = CLAsyncLabel()
        view.numberOfLines = 0
        view.backgroundColor = .lightGray.withAlphaComponent(0.35)
        return view
    }()
}

// MARK: - JmoVxia---生命周期

extension ViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        makeConstraints()
        configData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
}

// MARK: - JmoVxia---布局

private extension ViewController {
    func setupUI() {
        view.addSubview(label1)
        view.addSubview(label2)
        view.addSubview(label3)
    }

    func makeConstraints() {
        label2.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(label1.snp.top).offset(-20)
            make.width.equalTo(view).multipliedBy(0.5)
        }

        label3.snp.makeConstraints { make in
            make.top.equalTo(label1.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.lessThanOrEqualTo(view)
        }
    }
}

// MARK: - JmoVxia---数据

private extension ViewController {
    func configData() {
        label1.attributedText = .init(text: "谁不想左手诗与远方，右手清风明月，云想衣裳花想容，沉香亭北倚阑干？我一直奢望读书抚琴，岁月静好；也梦想听风赏花，悠然南山。可是红尘滚滚，痴痴情深，远去了嗅梅浅笑，走进了露浓花瘦，此刻心、这段情注重的不应是风花雪月的浪漫，而是柴米油盐的生活。", attributes: { $0
                .font(.systemFont(ofSize: 16))
                .alignment(.left)
                .lineSpacing(6)
                .foregroundColor(.gray)
        })
        label1.preferredMaxLayoutWidth = view.bounds.width * 0.75
        label1.sizeToFit()
        label1.center = view.center

        label2.attributedText = .init(text: "今天在这个细雨蒙蒙的午后，走在路上丝丝微风的清凉让我有了些许的灵感，好久好久没有如此安静的内心了，曾感叹，这七荤八素的世间，让我无从应付，这滚滚红尘的染缸，也差点把我的心浸泡的冰冷，还好没有生硬。", attributes: { $0
                .font(.systemFont(ofSize: 14))
                .alignment(.left)
                .lineSpacing(6)
                .foregroundColor(.yellow)
        })

        label3.attributedText = .init(text: "岁月匆匆，生命如草，早晨发芽，夜晚枯干，如此脆弱，怎堪负重？\n好多的事情真的来不及去做，还没感觉长大，却发现自己已经老了。\n回想这些年走过的风风雨雨、经历的形形色色，感慨万千，却欲说还休。", attributes: { $0
                .font(.systemFont(ofSize: 14))
                .alignment(.left)
                .lineSpacing(6)
                .foregroundColor(.red)
        })
    }
}

// MARK: - JmoVxia---override

extension ViewController {}

// MARK: - JmoVxia---objc

@objc private extension ViewController {}

// MARK: - JmoVxia---私有方法

private extension ViewController {}

// MARK: - JmoVxia---公共方法

extension ViewController {}
