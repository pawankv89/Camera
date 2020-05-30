//
//  Extension.swift
//  Custom Camera View
//
//  Created by Pawan kumar on 28/05/20.
//  Copyright © 2020 Pawan Kumar. All rights reserved.
//

import UIKit
import Foundation

extension CALayer {
    func makeSnapshot() -> UIImage? {
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(frame.size, false, scale)
        defer { UIGraphicsEndImageContext() }
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        render(in: context)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        return screenshot
    }
}

extension UIView {
    func makeSnapshot() -> UIImage? {
        if #available(iOS 10.0, *) {
            let renderer = UIGraphicsImageRenderer(size: frame.size)
            return renderer.image { _ in drawHierarchy(in: bounds, afterScreenUpdates: true) }
        } else {
            return layer.makeSnapshot()
        }
    }
}

extension UIView {
   var screenShot: UIImage?  {
        if #available(iOS 10, *) {
            let renderer = UIGraphicsImageRenderer(bounds: self.bounds)
            return renderer.image { (context) in
                self.layer.render(in: context.cgContext)
            }
        } else {
            UIGraphicsBeginImageContextWithOptions(bounds.size, false, 5);
            if let _ = UIGraphicsGetCurrentContext() {
                drawHierarchy(in: bounds, afterScreenUpdates: true)
                let screenshot = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                return screenshot
            }
            return nil
        }
    }
}

extension UIViewController {
    
    /// Takes the screenshot of the screen and returns the corresponding image
       ///
       /// - Parameter shouldSave: Boolean flag asking if the image needs to be saved to user's photo library. Default set to 'true'
       /// - Returns: (Optional)image captured as a screenshot
       
       open func takeScreenshotlayer(_ shouldSave: Bool = true) -> UIImage? {
           
              var screenshotImage : UIImage?
              let layer = self.view.layer
              print("layers ", layer)
              let scale = self.view.layer.contentsScale
              UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale);
              guard let context = UIGraphicsGetCurrentContext() else {return nil}
              layer.render(in: context)
              screenshotImage =
               UIGraphicsGetImageFromCurrentImageContext()
              UIGraphicsEndImageContext()
              if let image = screenshotImage, shouldSave {
                  UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
              }
           
              return screenshotImage
          }
    
    open func takeScreenshotwindow(_ shouldSave: Bool = true) -> UIImage? {
     
        var screenshotImage :UIImage?
        let layer = UIApplication.shared.windows.last?.layer
        let scale = UIScreen.main.scale
        
        UIGraphicsBeginImageContextWithOptions(layer!.frame.size, false, scale);
        guard let context = UIGraphicsGetCurrentContext() else {return nil}
        layer!.render(in: context)
        screenshotImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if let image = screenshotImage, shouldSave {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
     
        return screenshotImage
    }
}
