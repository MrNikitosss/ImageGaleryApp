//
//  ImagesListView.swift
//  ImageGalaryApp
//
//  Created by Nikita Moskalenko on 3.01.24.
//

import UIKit

protocol ImagesListViewProtocol: AnyObject {
    func reloadCollectionView(with cellData: [ImageCellDataModel])
    func showProgressHUD()
    func hideProgressHUD()
    func showDescription(uiData: [PhotoImageData], selectedIndex: Int)
    func showError(text: String)
}

final class ImagesListView: BaseViewController {

    var interactor: ImagesListViewInteractorProtocol?
    var router: ImagesListViewRouterProtocol?

    @IBOutlet private weak var collectionView: UICollectionView!
    private var cellData: [ImageCellDataModel] = []
    private var collectionViewAdapter: ImagesListCollectionViewAdapter?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.setupAdapter()
        self.interactor?.requestData()
    }
    
    func setupAdapter() {
        self.collectionViewAdapter = ImagesListCollectionViewAdapter(collectionView: self.collectionView)
        self.collectionViewAdapter?.onStarBtnTap = {[weak self] isFavorite, itemIndex in
            guard let self else { return }

            isFavorite ?
            self.interactor?.addToFavoriteImage(at: itemIndex) :
            self.interactor?.removeFromFavoritesImage(at: itemIndex)
        }

        self.collectionViewAdapter?.loadData = {[weak self] in
            guard let self else { return }

            self.interactor?.requestData()
        }

        self.collectionViewAdapter?.didSelectRowAt = { [weak self] itemIndex in
            guard let self else { return }
            
            self.interactor?.requestImageDescriptionAt(index: itemIndex)
        }
    }
}

extension ImagesListView: ImagesListViewProtocol {

    func reloadCollectionView(with cellData: [ImageCellDataModel]) {
        self.collectionViewAdapter?.appendData(cellData: cellData)
    }

    func showProgressHUD() {
        self.showProgress()
    }

    func hideProgressHUD() {
        self.stopProgress()
    }

    func showDescription(uiData: [PhotoImageData], selectedIndex: Int) {
        self.router?.showImageDescription(uiData: uiData, selectedIndex: selectedIndex)
    }

    func showError(text: String) {
        self.showAlert(title: "Error", message: text)
    }
}
