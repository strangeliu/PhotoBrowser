//
//  ZoomViewController.swift
//  JXPhotoBrowser_Example
//
//  Created by JiongXing on 2018/10/16.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import JXPhotoBrowser

class ZoomViewController: BaseCollectionViewController, UIViewControllerPreviewingDelegate {
    
    override var name: String {
        return "Zoom动画-使用动画起始/结束视图"
    }
    
    override func makeDataSource() -> [ResourceModel] {
        var result: [ResourceModel] = []
        (0..<7).forEach { index in
            let model = ResourceModel()
            model.localName = "local_\(index)"
            result.append(model)
        }
        return result
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.jx.dequeueReusableCell(BaseCollectionViewCell.self, for: indexPath)
        cell.imageView.image = self.modelArray[indexPath.item].localName.flatMap({ name -> UIImage? in
            return UIImage(named: name)
        })
        registerForPreviewing(with: self, sourceView: cell)
        return cell
    }
    
    override func openPhotoBrowser(with collectionView: UICollectionView, indexPath: IndexPath) {
        // 数据源
        let dataSource = JXLocalDataSource(numberOfItems: {
            // 共有多少项
            return self.modelArray.count
        }, localImage: { index -> UIImage? in
            // 每一项的图片对象
            return self.modelArray[index].localName.flatMap({ name -> UIImage? in
                return UIImage(named: name)
            })
        })
        // 视图代理，实现了光点型页码指示器
        let delegate = JXDefaultPageControlDelegate()
        // 转场动画
        let trans = JXPhotoBrowserZoomTransitioning { (browser, index, view) -> UIView? in
            let indexPath = IndexPath(item: index, section: 0)
            let cell = collectionView.cellForItem(at: indexPath) as? BaseCollectionViewCell
            return cell?.imageView
        }
        // 打开浏览器
        JXPhotoBrowser(dataSource: dataSource, delegate: delegate, transDelegate: trans)
            .show(pageIndex: indexPath.item)
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let cell = previewingContext.sourceView as? UICollectionViewCell else {
            return nil
        }
        guard let indexPath = collectionView.indexPath(for: cell) else {
            return nil
        }
        let dataSource = JXLocalDataSource(numberOfItems: {
            // 共有多少项
            return self.modelArray.count
        }, localImage: { index -> UIImage? in
            // 每一项的图片对象
            return self.modelArray[index].localName.flatMap({ name -> UIImage? in
                return UIImage(named: name)
            })
        })
        // 视图代理，实现了光点型页码指示器
        let delegate = JXDefaultPageControlDelegate()
        // 转场动画
        let trans = JXPhotoBrowserZoomTransitioning { (browser, index, view) -> UIView? in
            let indexPath = IndexPath(item: index, section: 0)
            let cell = self.collectionView.cellForItem(at: indexPath) as? BaseCollectionViewCell
            return cell?.imageView
        }
        // 打开浏览器
        let controller = JXPhotoBrowser(dataSource: dataSource, delegate: delegate, transDelegate: trans)
        controller.pageIndex = indexPath.item
        return controller
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        present(viewControllerToCommit, animated: true, completion: nil)
    }
}
