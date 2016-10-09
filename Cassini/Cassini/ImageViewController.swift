//
//  ImageViewController.swift
//  Cassini
//
//  Created by lyxia on 2016/9/23.
//  Copyright © 2016年 lyxia. All rights reserved.
//

import UIKit

var ImageViewControllerCount = 0

class ImageViewController: UIViewController, UIScrollViewDelegate {
    deinit {
        ImageViewControllerCount -= 1
        print("deinit ImageViewController and ImageViewControllerCount = \(ImageViewControllerCount)")
    }
    
    var imageUrl: URL? {
        didSet {
            image = nil
            if view.window != nil {
                fetchImage()
            }
        }
    }
    
    func fetchImage() {
        if let url = imageUrl {
            DispatchQueue.global(qos: .userInitiated).async {
                () -> Void in
                do {
                    self.snaper.startAnimating()
                    print("start loading url = \(url.absoluteString)")
                    let imageData = try Data(contentsOf: url)
                    DispatchQueue.main.async {
                        () -> Void in
                        print("loaded url = \(url.absoluteString) and current view url = \(self.imageUrl?.absoluteString)")
                        if url == self.imageUrl {
                            self.image = UIImage(data: imageData)
                        }
                    }
                } catch {
                    print("-------------catch error")
                    self.snaper.stopAnimating()
                }
            }
        }
    }
    
    let imageView = UIImageView()
    
    var image: UIImage? {
        get {
            return imageView.image
        }
        set {
            imageView.image = newValue
            imageView.sizeToFit()
            snaper.stopAnimating()
            configScrollView()
        }
    }

    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            configScrollView()
            scrollView.delegate = self
        }
    }
    
    func configScrollView() {
        if scrollView != nil {
            scrollView.contentSize = imageView.frame.size
            scrollView.minimumZoomScale = 0.3
            scrollView.maximumZoomScale = 1
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchImage()
    }
    
    @IBOutlet weak var snaper: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.addSubview(imageView)
        
        ImageViewControllerCount += 1
        print("create ImageViewController and ImageViewControllerCount=\(ImageViewControllerCount)")
    }

}
