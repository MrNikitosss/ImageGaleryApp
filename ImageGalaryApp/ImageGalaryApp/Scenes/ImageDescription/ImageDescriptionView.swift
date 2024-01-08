//
//  ImageDescriptionView.swift
//  ImageGalaryApp
//
//  Created by Nikita Moskalenko on 7.01.24.
//

import UIKit

protocol ImageDescriptionViewProtocol: AnyObject {

    func showProgressHUD()
    func hideProgressHUD()
    func showError(text: String)
    func setItems(items: [FavoriteImageModel])
}

final class ImageDescriptionView: BaseViewController {

    var interactor: ImageDescriptionViewInteractorProtocol?

    @IBOutlet private weak var collectionView: UICollectionView!

    private var itemsCount: Int = 0
    private var items: [FavoriteImageModel] = []
    private var currentItemInagex: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
        self.setupCollectionView()
        self.registerCell()
        self.interactor?.initialUpdate()
    }
}

extension ImageDescriptionView: ImageDescriptionViewProtocol {

    func setItems(items: [FavoriteImageModel]) {
        self.items.append(contentsOf: items)
        self.collectionView.reloadData()
    }

    func showError(text: String) {
        self.showAlert(title: "Error", message: text)
    }

    func showProgressHUD() {
        self.showProgress()
    }

    func hideProgressHUD() {
        self.stopProgress()
    }
}

extension ImageDescriptionView: UICollectionViewDelegateFlowLayout {

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {

        return CGSize(
            width: collectionView.frame.width,
            height: collectionView.frame.height
        )
    }
}

extension ImageDescriptionView: UICollectionViewDataSource {

    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        self.items.count
    }


    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ImageDescriptionCell.self), for: indexPath) as! ImageDescriptionCell

        cell.reuseWith(data: self.items[indexPath.item])

        return cell
    }

    func collectionView(
        _ collectionView: UICollectionView,
        willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        if indexPath.item == self.items.count - 2 {
            self.interactor?.loadImages()
        }
    }
}

private extension ImageDescriptionView {

    func setupCollectionView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.isPagingEnabled = true
        self.collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    func registerCell() {
        self.collectionView.register(
            UINib(nibName: String(describing: ImageDescriptionCell.self), bundle: nil),
            forCellWithReuseIdentifier: String(describing: ImageDescriptionCell.self)
        )
    }

    func setupUI() {
        self.navigationController?.isNavigationBarHidden = true
        self.customNavigationBar.isHidden = false
        self.navigationTitleLabel.text = "Photo"
    }
}
