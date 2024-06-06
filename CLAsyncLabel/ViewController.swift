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

    private var data = [NSAttributedString]()

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.register(AsyncLabelCell.self, forCellReuseIdentifier: AsyncLabelCell.reuseIdentifier)
        return tableView
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
        view.addSubview(tableView)
    }

    func makeConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - JmoVxia---数据

private extension ViewController {
    func configData() {
        for i in 0 ..< 100 {
            let text: String
            let color: UIColor
            let size: CGFloat

            switch i % 3 {
            case 0:
                text = "[\(i)] 谁不想左手诗与远方，右手清风明月，云想衣裳花想容，沉香亭北倚阑干？我一直奢望读书抚琴，岁月静好；也梦想听风赏花，悠然南山。可是红尘滚滚，痴痴情深，远去了嗅梅浅笑，走进了露浓花瘦，此刻心、这段情注重的不应是风花雪月的浪漫，而是柴米油盐的生活。"
                color = .darkGray
                size = 16
            case 1:
                text = "[\(i)] 今天在这个细雨蒙蒙的午后，走在路上丝丝微风的清凉让我有了些许的灵感，好久好久没有如此安静的内心了，曾感叹，这七荤八素的世间，让我无从应付，这滚滚红尘的染缸，也差点把我的心浸泡的冰冷，还好没有生硬。"
                color = UIColor(red: 0.1, green: 0.4, blue: 0.7, alpha: 1.0)
                size = 14
            default:
                text = "[\(i)] 岁月匆匆，生命如草，早晨发芽，夜晚枯干，如此脆弱，怎堪负重？\n好多的事情真的来不及去做，还没感觉长大，却发现自己已经老了。\n回想这些年走过的风风雨雨、经历的形形色色，感慨万千，却欲说还休。"
                color = UIColor(red: 0.8, green: 0.3, blue: 0.3, alpha: 1.0)
                size = 18
            }

            let attributedString = NSAttributedString(text: text, attributes: {
                $0.font(.systemFont(ofSize: size))
                    .alignment(.left)
                    .lineSpacing(6)
                    .foregroundColor(color)
            })
            data.append(attributedString)
        }
    }
}

// MARK: - JmoVxia---override

extension ViewController {}

// MARK: - JmoVxia---objc

extension ViewController: UITableViewDataSource {
    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 复用自定义 Cell
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AsyncLabelCell.reuseIdentifier, for: indexPath) as? AsyncLabelCell else {
            // 如果复用失败，返回一个空的 Cell，避免崩溃
            return UITableViewCell()
        }

        // 使用数据源配置 Cell
        cell.configure(with: data[indexPath.row])

        // 设置交替的背景色，以便清晰地看到 Cell 的边界
        cell.contentView.backgroundColor = indexPath.row % 2 == 0 ? .white : UIColor.black.withAlphaComponent(0.05)

        return cell
    }
}

// MARK: - JmoVxia---私有方法

private extension ViewController {}

// MARK: - JmoVxia---公共方法

extension ViewController {}
