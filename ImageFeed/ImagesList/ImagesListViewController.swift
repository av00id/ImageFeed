//
//  ViewController.swift
//  ImageFeed
//
//  Created by Сергей Андреев on 22.11.2022.
//

import UIKit

protocol ImagesListViewControllerProtocol: AnyObject {
    var presenter: ImagesListPresenterProtocol { get set }
    func updateTableViewAnimated()
}

final class ImagesListViewController: UIViewController & ImagesListViewControllerProtocol {
    
    private var photosName = [String]()
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    
    private let imageListService = ImagesListService.shared
    private var imageListServiceObserver: NSObjectProtocol?
    private var photos: [Photo] = []
    
    lazy var presenter: ImagesListPresenterProtocol = {
        return ImagesListPresenter()
    }()
    
    private var gradient: CAGradientLayer!
    private let animationGradient = AnimationGradientFactory.shared
    
    @IBOutlet private weak var tableView: UITableView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.view = self
        presenter.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            let viewController = segue.destination as! SingleImageViewController
            let indexPath = sender as! IndexPath
            viewController.image = photos[indexPath.row].largeImageURL
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        imageListCell.delegate = self
        
        imageListCell.configure(from: photos[indexPath.row])
        
        return imageListCell
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == photos.count - 1 {
            imageListService.fetchPhotosNextPage()
        }
    }
}

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }
}

extension ImagesListViewController {
    
    func updateTableViewAnimated() {
        let oldCount = photos.count
        let newCount = imageListService.photos.count
        photos = imageListService.photos
        if oldCount != newCount {
            tableView.performBatchUpdates {
                let indexPaths = (oldCount..<newCount).map { i in
                    IndexPath(row: i, section: 0)
                }
                tableView.insertRows(at: indexPaths, with: .automatic)
            } completion: { _ in }
        }
    }
}

extension ImagesListViewController: ImagesListCellDelegate {
    func reloadView(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        _ = photos[indexPath.row]
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        
        let photo = photos[indexPath.row]
        UIBlockingProgressHUD.show()
        
        imageListService.changeLike(photoId: photo.id, shouldLike: !photo.isLiked, photoIdx: indexPath.row) { [weak cell, self] response in
            guard let cell else { return }
            DispatchQueue.main.async {
                switch response {
                case .success(let photoResult):
                    self.photos[indexPath.row].isLiked = photoResult.isLiked
                    cell.setIsLiked(isLiked: photoResult.isLiked)
                case .failure(let error):
                    print(error)
                }
                UIBlockingProgressHUD.dismiss()
            }
        }
    }
}

    



