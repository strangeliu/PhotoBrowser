//
//  DefaultImageContainerProvider.swift
//  Advance
//
//  Created by Liu on 2018/9/10.
//

import Foundation
import UIKit

extension UIImageView: ImageContainer {
    
    public var getImage: UIImage? {
        return image
    }
    
    public var view: UIView {
        return self
    }
}

open class ContainerProviderManager {
    
    static let `default` = ContainerProviderManager()
    
    var provider: ImageContainerProvider = DefaultImageContainerProvider()
}

open class DefaultImageContainerProvider: ImageContainerProvider {
    
    public static let shared = DefaultImageContainerProvider()
    
    public func createImageContainer() -> ImageContainer {
        return UIImageView()
    }
    
    public func add(imageContainer: ImageContainer, to view: UIView) {
        if let imageView = imageContainer as? UIImageView {
            view.addSubview(imageView)
        }
    }
    
}
