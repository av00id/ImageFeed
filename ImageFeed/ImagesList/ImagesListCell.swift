//
//  ImagesFeedCell.swift
//  ImageFeed
//
//  Created by Сергей Андреев on 22.11.2022.
//

import UIKit
import Kingfisher

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
    func reloadView(_ cell: ImagesListCell)
}

final class ImagesListCell: UITableViewCell {
    
    static let reuseIdentifier = "ImagesListCell"
    
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    
    private let animationGradient = AnimationGradientFactory.shared
    
    weak var delegate: ImagesListCellDelegate?
    
    @IBAction private func likeButtonClicked() {
        delegate?.imageListCellDidTapLike(self)
    }
    
    private func reloadView() {
        delegate?.reloadView(self)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cellImage.kf.cancelDownloadTask()
    }
    
    func configure(from photo: Photo) {
        let offsetX: CGFloat = 20
        let offsetY: CGFloat = 3
        let cornerRadius: CGFloat = cellImage.layer.cornerRadius
        
        let gradient = animationGradient.createGradient(
                  width: frame.width - offsetX * 2,
                  height: frame.height - offsetY * 2,
                  offsetX: offsetX, offsetY: offsetY, cornerRadius: cornerRadius)
        cellImage.layer.addSublayer(gradient)
        
        cellImage.kf.indicatorType = .activity
        cellImage.kf.setImage(with: photo.thumbImageURL) {_ in
            gradient.removeFromSuperlayer()
                }
        cellImage.kf.setImage(with: photo.thumbImageURL) { result in self.reloadView()
        }
        setIsLiked(isLiked: photo.isLiked)
        if let date = photo.createdAt {
            dateLabel.text = date.dateTimeString
        }
    }
    
    func setIsLiked(isLiked: Bool) {
        let likeImage = isLiked ? UIImage(named: "like_button_on") : UIImage(named: "like_button_off")
        likeButton.setImage(likeImage, for: .normal)
    }
}


