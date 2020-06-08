//
//  ImageLibraryController.swift
//  SecurityPhotoLibrary
//
//  Created by Dmitry Semenuk on 12/04/2020.
//  Copyright © 2020 Dmitry Semenuk. All rights reserved.
//

import UIKit

class ImageLibraryController: UIViewController {

    @IBOutlet private weak var headerView: UIView!
    @IBOutlet private weak var addImageButton: UIButton!
    @IBOutlet private weak var closeControllerButton: UIButton!
    
    @IBOutlet weak var presentImageCollectionView: UICollectionView!
    
    private let imagePicker = UIImagePickerController()
    private var imageArray: [UserImageClass] = []
    
    private let reuseIdentifier = "Cell"
    
    //MARK: - Life Cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        
        imagePicker.delegate = self
        presentImageCollectionView.delegate = self
        presentImageCollectionView.dataSource = self
        loadConfiguration()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        presentImageCollectionView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

    //MARK: - Action methods
    @IBAction private func addImage(_ sender: UIButton) {
        self.imageAlertController()
    }
    
    @IBAction private func closeController(_ sender: Any) {
        if !imageArray.isEmpty {
            UserDefaults.standard.set(encodable: imageArray, forKey: Constant.libraryImage)
        }
        self.navigationController?.popViewController(animated: true)
    }

    //MARK: - Keybord Actions

    //MARK: - UIImagePikerControler
    private func pickCamera() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            if #available(iOS 13.0, *) {
                overrideUserInterfaceStyle = .light
            }
            self.imagePicker.sourceType = .camera
            present(self.imagePicker, animated: true, completion: nil)
        }
    }
    
    private func pickPhoto() {
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        self.imagePicker.sourceType = .photoLibrary
        present(self.imagePicker, animated: true, completion: nil)
    }
    
    
    //MARK: - Save and Loads Data Images
    func saveImage(imageName: String, image: UIImage, userImage: UserImageClass){
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }
        
        let fileURL = documentsDirectory.appendingPathComponent(imageName)
        guard let data = image.jpegData(compressionQuality: 1) else { return }
        
        userImage.imagePath = fileURL
        userImage.uuid = imageName
        userImage.name = imageName
        userImage.favorite = false
        
        do {
            try data.write(to: fileURL)
            print("Image Saved")
        } catch let error {
            print("error to write image", error)
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
    
    //MARK: - Load start configuration
    private func loadConfiguration(){
        self.loadStyle()
        self.loadImages()
    }
       
    private func loadStyle(){
           self.headerView.backgroundColor = .white
           self.headerView.addBorder(for: .bottom, withColor: .blue, borderWidth: 1)
           self.headerView.dropShadow(opacity: 0.4, offSet: CGSize(width: 0, height: 1), radius: 4, scale: true)
    }
    
    private func loadImages(){
        self.imageArray = UserDefaults.standard.value([UserImageClass].self, forKey: Constant.libraryImage) ?? [UserImageClass]()
//        
//        imageArray = [UserImageClass]()
//        UserDefaults.standard.set(encodable: imageArray, forKey: Constant.libraryImage)
        
    }

    func imageAlertController(){
        let alert = UIAlertController(title: "Loaf image", message: "choose were you wont too download image", preferredStyle: .actionSheet)
        
        let imageAlert = UIAlertAction(title: "Library Image", style: .default) { (_) in
            self.pickPhoto()
        }
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (_) in
            self.pickCamera()
        }
        
        let cancelAlert = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            print("Cancel")
        }
        
        alert.addAction(imageAlert)
        alert.addAction(cameraAction)
        alert.addAction(cancelAlert)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
}
//MARK: - PickerController
extension ImageLibraryController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            let userImage = UserImageClass()
            let imageName = UUID().uuidString
            
            self.saveImage(imageName: imageName, image: pickedImage, userImage: userImage)
            
            imageArray.append(userImage)
            presentImageCollectionView.reloadData()
            picker.dismiss(animated: true, completion: nil)
        }
    }

}

//MARK: - Collection View Delegate and DataSource
extension ImageLibraryController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! NewCollectionViewCell
        let item = loadImageFromDiskWith(fileName: imageArray[indexPath.item].name ?? "Empty")
        cell.itemImageView.contentMode = .scaleToFill
        cell.itemImageView.image = item
        cell.backgroundColor = .red
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "GalleryImageViewController") as! GalleryImageViewController
        vc.imageData = imageArray
        vc.indexPath = indexPath
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (presentImageCollectionView.frame.size.width - 10) / 3, height: (presentImageCollectionView.frame.size.width - 10) / 3)
    }
    
    
}

extension ImageLibraryController: GalleryImageDelegate{
    func getCurrentIndex(array: [UserImageClass]) {
        print("here")
        imageArray = array
    }
    
    
}
