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
    
    //MARK: - Properties
    var profileViewModel = ProfileViewModel()
    var spacing: CGFloat = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        profileViewModel.parseJson()
        profileCollectionView.reloadData()
        
    }
    
    func setCollectionViewLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        self.profileCollectionView?.collectionViewLayout = layout
    }
    
    

}

extension ProfileViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return profileViewModel.user?.posts?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileCollectionViewCell.cellIdentifier, for: indexPath) as? ProfileCollectionViewCell else { return UICollectionViewCell() }
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let width = (self.profileCollectionView.frame.width / 3) - 7
//        return CGSize(width: width, height: width)
//    }
    
    
}

// MARK: - Collection View Flow Layout Delegate
extension ProfileViewController : UICollectionViewDelegateFlowLayout {
  
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfItemsPerRow:CGFloat = 3
        let spacingBetweenCells:CGFloat = 8
        
        let totalSpacing = (2 * self.spacing) + ((numberOfItemsPerRow - 1) * spacingBetweenCells) //Amount of total spacing in a row
        
        if let collection = self.profileCollectionView {
            let width = (collection.bounds.width - totalSpacing)/numberOfItemsPerRow
            return CGSize(width: width, height: width)
        }else{
            return CGSize(width: 0, height: 0)
        }
    }
}
