//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Сергей Андреев on 01.12.2022.
//

import UIKit

final class SingleImageViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func didTapBackButton() {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func didTapShareButton(_ sender: Any) {
        let share = UIActivityViewController(
            activityItems: [image],
            applicationActivities: nil)
    present(share, animated: true, completion: nil)
    }
    var image: UIImage! {
        didSet {
            guard isViewLoaded else { return }
            imageView.image = image
            rescaleAndCenterImageInScrollView(image: image)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        imageView.image = image
        rescaleAndCenterImageInScrollView(image: image)
    }
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        let visibleRectSize = view.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, max(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
}
extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
}
