//
//  ProfileViewController.swift
//  Yovo Clone
//
//  Created by Surjit's iMac on 21/01/20.
//  Copyright © 2020 Surjit. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    class func initiateProfileViewController() -> ProfileViewController {
        guard let profileVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfileViewController") as? ProfileViewController else { return ProfileViewController() }
        return profileVC
    }
    
    //MARK: - IBOutlets
    @IBOutlet var profileCollectionView: UICollectionView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var details: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    //MARK: - Properties
    var profileViewModel = ProfileViewModel()
    var spacing: CGFloat = 1
    let imageCache = NSCache<AnyObject, AnyObject>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.setCollectionViewLayout()
        profileViewModel.parseJson()
        configureUI()
        profileCollectionView.reloadData()
        
    }
    
    @IBAction func cancelButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func configureUI() {
        self.profileImage.layer.borderColor = UIColor.white.cgColor
        self.profileImage.layer.borderWidth = 2.0
        self.profileImage.layer.cornerRadius = 30.0
        self.userName.text = profileViewModel.user?.userName
        self.titleText.text = profileViewModel.user?.title
        self.details.text = profileViewModel.user?.description
        if let urlString = profileViewModel.user?.userImageUrl {
            ImageDownloader.sharedInstance.downloadImageFrom(urlString: urlString, indexPath: IndexPath()) { (image, indexPath) in
                DispatchQueue.main.async {
                    self.profileImage.image = image
                }
            }
        }
    }
    
    func setCollectionViewLayout() {
        let layout = self.profileCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        self.profileCollectionView?.collectionViewLayout = layout
    }
    
    
    func getImagefor(_ imageUrl: String, _ indexPath: IndexPath) {
        if let imageFromCache = self.imageCache.object(forKey: imageUrl as AnyObject) as? UIImage {
            self.putImage(at: indexPath, imageFromCache)
        } else {
            ImageDownloader.sharedInstance.downloadImageFrom(urlString: imageUrl, indexPath: indexPath) { [weak self] (image, index) in
                DispatchQueue.main.async {
                    self?.imageCache.setObject(image, forKey: imageUrl as AnyObject)
                    self?.putImage(at: index, image)
                    //                    self?.profileCollectionView.reloadData()
                }
                
            }
        }
    }
    func putImage(at indexPath: IndexPath, _ image: UIImage) {
        var updateCell = self.profileCollectionView.cellForItem(at: indexPath) as? ProfileCollectionViewCell
        DispatchQueue.main.async {
            if updateCell == nil {
                //            profileCollectionView.reloadData()
                self.profileCollectionView.layoutIfNeeded()
                updateCell = self.profileCollectionView.cellForItem(at: indexPath) as? ProfileCollectionViewCell
            }
            if updateCell == nil {
                self.profileCollectionView.reloadData()
                self.profileCollectionView.layoutIfNeeded()
                updateCell = self.profileCollectionView.cellForItem(at: indexPath) as? ProfileCollectionViewCell
            }
            updateCell?.postImage.image = image
        }
        
    }
    
}

extension ProfileViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return profileViewModel.user?.posts?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileCollectionViewCell.cellIdentifier, for: indexPath) as? ProfileCollectionViewCell,
            let post = profileViewModel.user?.posts?[indexPath.item]
            else { return UICollectionViewCell() }
        if let imageUrl = post.userImageUrl {
            getImagefor(imageUrl, indexPath)
        }
        
        return cell
    }
    
}

// MARK: - Collection View Flow Layout Delegate
extension ProfileViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfItemsPerRow:CGFloat = 3
        let spacingBetweenCells:CGFloat = 1
        
        let totalSpacing = (2 * self.spacing) + ((numberOfItemsPerRow - 1) * spacingBetweenCells) //Amount of total spacing in a row
        
        if let collection = self.profileCollectionView {
            let width = (collection.bounds.width - totalSpacing)/numberOfItemsPerRow
            return CGSize(width: width, height: width)
        }else{
            return CGSize(width: 0, height: 0)
        }
    }
}
