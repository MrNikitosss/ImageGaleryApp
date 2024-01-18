//
//  ImagesListCollectionViewAdapter.swift
//  ImageGalaryApp
//
//  Created by Nikita Moskalenko on 7.01.24.
//

import UIKit

final class ImagesListCollectionViewAdapter: NSObject {

    var onStarBtnTap: ((_ isFavorite: Bool, _ index: Int) -> Void)?
    var loadData: (() -> Void)?
    var didSelectRowAt: ((_ index: Int) -> Void)?

    private let collectionView: UICollectionView
    private var cellData: [ImageCellDataModel] = []

    init(
        collectionView: UICollectionView
    ) {
        self.collectionView = collectionView
        super.init()
        self.registerCell()
        self.setupCollectionView()
    }

    func registerCell() {
        self.collectionView.register(
            UINib(nibName: String(describing: ImageCell.self), bundle: nil),
            forCellWithReuseIdentifier: String(describing: ImageCell.self)
        )
    }

    func setupCollectionView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.backgroundColor = .clear
        self.collectionView.contentInset = UIEdgeInsets(top: 20, left: 16, bottom: 10, right: 16)
    }

    func appendData(cellData: [ImageCellDataModel]) {
        self.cellData.append(contentsOf: cellData)
        self.collectionView.reloadData()
    }

    func reloadData(cellData: [ImageCellDataModel]) {
        self.cellData = cellData
        self.collectionView.reloadData()
    }

    func reloadItemAt(indexPath: IndexPath) {
        self.collectionView.reloadItems(at: [indexPath])
    }
}

extension ImagesListCollectionViewAdapter: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let itemSize = (collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right + 10)) / 2
        let cell = collectionView.cellForItem(at: indexPath)?.bounds
        
        return CGSize(width: itemSize, height: itemSize)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        self.didSelectRowAt?(indexPath.item)
    }
}

extension ImagesListCollectionViewAdapter: UICollectionViewDataSource {

    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        self.cellData.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ImageCell.self), for: indexPath) as! ImageCell

        cell.reuse(with: self.cellData[indexPath.item])

        cell.onStarBtnTap = { isFavorite in
            self.onStarBtnTap?(isFavorite, indexPath.item)
        }

        return cell
    }

    func collectionView(
        _ collectionView: UICollectionView,
        willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        if indexPath.item == self.cellData.count - 2 {
            self.loadData?()
        }
    }

}
