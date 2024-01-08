//
//  ImageCell.swift
//  ImageGalaryApp
//
//  Created by Nikita Moskalenko on 4.01.24.
//

import UIKit
import Resolver
import NVActivityIndicatorView

final class ImageCell: UICollectionViewCell {

    @Injected private var imageLoader: ImageLoaderManagerProtocol
    @Injected private var imageCache: ImageCacheManagerProtocol

    var onStarBtnTap: ((Bool) -> Void)?

    private var activityIndicator: NVActivityIndicatorView?

    @IBOutlet private weak var starBtn: UIButton!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var likesCountLabel: UILabel!
    @IBOutlet private weak var heartImageView: UIImageView!

    private var isFavorite: Bool = false

    override func prepareForReuse() {
        super.prepareForReuse()

        self.imageView.image = nil
        self.likesCountLabel.text = nil
        self.activityIndicator?.stopAnimating()
        self.activityIndicator?.removeFromSuperview()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        layer.shadowPath = UIBezierPath(
            roundedRect: bounds,
            cornerRadius: 8
        ).cgPath
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true

        layer.cornerRadius = 8
        layer.masksToBounds = true

        layer.shadowRadius = 8.0
        layer.shadowOpacity = 0.10
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 5)

        self.setupUI()
    }

    func reuse(with cellDataModel: ImageCellDataModel) {

        self.loadImage(from: cellDataModel.imageUrl)
        self.starBtn.setImage(UIImage(systemName: cellDataModel.isFavorite ? "star.fill" : "star"), for: .normal)
        self.starBtn.tintColor = .yellow
        self.isFavorite = cellDataModel.isFavorite
        self.likesCountLabel.text = cellDataModel.likes.description
    }
}

private extension ImageCell {

    @IBAction func starBtnTap() {
        self.isFavorite.toggle()
        self.starBtn.setImage(UIImage(systemName: self.isFavorite ? "star.fill" : "star"), for: .normal)
        self.onStarBtnTap?(self.isFavorite)
    }
}

private extension ImageCell {

    func setupUI() {
        self.imageView.contentMode = .scaleAspectFill
        self.heartImageView.image = UIImage(systemName: "suit.heart.fill")
        self.heartImageView.tintColor = .red
    }

    func loadImage(from url: String) {
        self.startLoader()
        guard
            let image = self.imageCache.getFromCache(id: url)
        else {
            self.imageLoader
                .loadImageFrom(
                    imageURL: url,
                    onSuccess: { [weak self] image in
                        guard let self else { return }
                       
                        DispatchQueue.main.async {
                            self.stopLoader()
                            self.imageCache.addToCache(image: image, id: url)
                            self.imageView.image = image
                        }

                    },
                    onFailure: { [weak self] error in
                        guard let self else { return }

                        self.stopLoader()
                    }
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
}
