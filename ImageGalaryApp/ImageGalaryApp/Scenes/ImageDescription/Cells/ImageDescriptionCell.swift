//
//  ImageDescriptionCell.swift
//  ImageGalaryApp
//
//  Created by Nikita Moskalenko on 8.01.24.
//

import UIKit
import NVActivityIndicatorView
import Resolver

final class ImageDescriptionCell: UICollectionViewCell {

    var onStarBtnTap: (() -> Void)?

    @Injected private var imageLoader: ImageLoaderManagerProtocol
    @Injected private var imageCacheManager: ImageCacheManagerProtocol

    private var activityIndicator: NVActivityIndicatorView?

    @IBOutlet private weak var contentStackView: UIStackView!
    @IBOutlet private weak var starBtn: UIButton!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var descriptionLabel: UILabel!

    override func prepareForReuse() {
        super.prepareForReuse()

        self.imageView.image = nil
        self.activityIndicator?.stopAnimating()
        self.activityIndicator?.removeFromSuperview()
        self.descriptionLabel.text = nil
        self.imageLoader.cancelAnyRequest()
    }

    func reuseWith(data: FavoriteImageModel?) {
        self.loadImage(from: data?.fullImageUrl)
        self.starBtn.setImage(UIImage(systemName: (data?.isFavorite ?? false) ? "star.fill" : "star"), for: .normal)
        self.starBtn.tintColor = .yellow
        self.descriptionLabel.text = data?.description
    }

    func loadImage(from url: String?) {
        guard let url else { return }

        guard
            let image = self.imageCacheManager.getFromCache(id: url)
        else {
            self.startLoader()

            self.imageLoader
                .loadImageFrom(
                    imageURL: url,
                    onSuccess: { [weak self] image in
                        guard let self else { return }

                        DispatchQueue.main.async {
                            self.stopLoader()
                            self.imageView.image = image
                            self.imageCacheManager.addToCache(image: image, id: url)
                        }
                        
                    },
                    onFailure: { _ in }
                )
            return
        }

        self.stopLoader()
        self.imageView.image = image
    }

    func startLoader() {
        self.activityIndicator = NVActivityIndicatorView(
            frame: CGRect(x: self.imageView.center.x - 20, y: self.imageView.center.y - 20, width: 40, height: 40),
            type: .ballPulse,
            color: .blue,
            padding: nil
        )

        self.imageView.addSubview(self.activityIndicator!)
        self.imageView.bringSubviewToFront(self.activityIndicator!)

        self.activityIndicator?.startAnimating()
    }

    func stopLoader() {
        self.activityIndicator?.stopAnimating()
        self.activityIndicator?.removeFromSuperview()
    }

    @IBAction func starBtnTap() {
        self.onStarBtnTap?()
    }
}
