//
//  GalleryImageViewController.swift
//  SecurityPhotoLibrary
//
//  Created by Dmitry Semenuk on 06/05/2020.
//  Copyright © 2020 Dmitry Semenuk. All rights reserved.
//

import UIKit

protocol GalleryImageDelegate: AnyObject {
    func getCurrentIndex(array: [UserImageClass])
}

class GalleryImageViewController: UIViewController {

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var closeGalleryButton: UIButton!
    @IBOutlet weak var deleteImageButton: UIButton!
    
    let cellIdentifier = "PhotoCell"
    
    var imageData = [UserImageClass]()
    var indexPath: IndexPath!
    
    var currentIndexPath: IndexPath = IndexPath()
    weak var delegate: GalleryImageDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        imagesCollectionView.delegate = self
        imagesCollectionView.dataSource = self
        
        imagesCollectionView.register(UINib(nibName: "ImagesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        
        imagesCollectionView.performBatchUpdates(nil) { (_) in
            self.imagesCollectionView.scrollToItem(at: self.indexPath, at: .centeredHorizontally, animated: false)
        }
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        UserDefaults.standard.set(encodable: imageData, forKey: Constant.libraryImage)
    }
    
    @IBAction func closeGallery(_ sender: Any) {
        UserDefaults.standard.set(encodable: imageData, forKey: Constant.libraryImage)
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func deleteImage(_ sender: Any) {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                    return
        }
        if let imageName = imageData[currentIndexPath.item].name {
            let imagePath = "\(documentsDirectory.absoluteURL.absoluteString)\(imageName)".replacingOccurrences(of: "file://", with: "")
            if FileManager.default.fileExists(atPath: imagePath) {
                do {
                    print("here")
                    try FileManager.default.removeItem(atPath: imagePath)
                    print(imageData)
                    imageData.remove(at: currentIndexPath.item)
                    print(imageData)
                    UserDefaults.standard.set(encodable: imageData, forKey: Constant.libraryImage)
                    imagesCollectionView.reloadData()
                    self.delegate?.getCurrentIndex(array: imageData)
                } catch{
                    print(error)
                }
            }
        }
    }
    
    func loadImageFromDiskWith(fileName: String) -> UIImage? {
        
        let documentDirectory = FileManager.SearchPathDirectory.documentDirectory
        
        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)
        
        if let dirPath = paths.first {
            let imageUrl = URL(fileURLWithPath: dirPath).appendingPathComponent(fileName)
            let image = UIImage(contentsOfFile: imageUrl.path)
            return image
            
        }
        
        return nil
    }

}

extension GalleryImageViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDragDelegate {
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let model = imageData[indexPath.item]
        let itemProvider = NSItemProvider(object: loadImageFromDiskWith(fileName: model.name!)!)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = model
        return [dragItem]
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! ImagesCollectionViewCell
        self.currentIndexPath = indexPath
        cell.setState(
            indexPath: indexPath,
            image: loadImageFromDiskWith(
                fileName: imageData[indexPath.item].name!) ?? UIImage(),
            favorite: imageData[indexPath.item].favorite!,
            descriptionText: imageData[indexPath.item].descriptionImage ?? "")
        
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(
            width: imagesCollectionView.frame.size.width,
            height: imagesCollectionView.frame.size.height)
    }
    
}

extension GalleryImageViewController: ImagesDelegate{
    func getIndex(indexPath: IndexPath) {
        print("OK")
    }
    
    func setData(count: Int, _ favorite: Bool, _ descriptionText: String) {
        imageData[count].favorite = favorite
        imageData[count].descriptionImage = descriptionText
    }
}

