//
//  FavoritesPhotosView.swift
//  ImageGalaryApp
//
//  Created by Nikita Moskalenko on 7.01.24.
//

import UIKit

protocol FavoritesPhotosViewProtocol: AnyObject {

    func loadURLs(_ cells: [ImageCellDataModel])
    func openDescriptionView(
        favoriteImages: [FavoriteImageModel],
        selectedIndex: Int
    )
}

final class FavoritesPhotosView: BaseViewController {

    var interactor: FavoritesPhotosViewInateractorProtocol?
    var router: FavoritesPhotosViewRouterProtocol?

    private var adapter: ImagesListCollectionViewAdapter?
    @IBOutlet private weak var collectionView: UICollectionView!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.setupAdapter()
        self.interactor?.loadFavoritesImages()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    func setupAdapter() {
        self.adapter = ImagesListCollectionViewAdapter(collectionView: self.collectionView)
        self.adapter?.onStarBtnTap = { [weak self] (isFAvorite, itemIndex) in
            guard let self else { return }

            self.interactor?.removeFromFavoritesImage(at: itemIndex)
            self.interactor?.loadFavoritesImages()
        }

        self.adapter?.didSelectRowAt = { [weak self] index in
            guard let self else { return }

            self.interactor?.requestImageDescriptionAt(index: index)
        }
    }
}

extension FavoritesPhotosView: FavoritesPhotosViewProtocol {
    
    func loadURLs(_ cells: [ImageCellDataModel]) {
        self.adapter?.reloadData(cellData: cells)
    }

    func reloadCellAt(indexPath: IndexPath) {
        self.adapter?.reloadItemAt(indexPath: indexPath)
    }

    func openDescriptionView(
        favoriteImages: [FavoriteImageModel],
        selectedIndex: Int
    ) {
        self.router?.showImageDescription(
            favoriteImages: favoriteImages,
            selectedIndex: selectedIndex
        )
    }
}
