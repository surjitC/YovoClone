//
//  FeedViewController.swift
//  Yovo Clone
//
//  Created by Surjit's iMac on 20/01/20.
//  Copyright © 2020 Surjit. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet var feedCollectionView: UICollectionView!
    
    //MARK: - Properties
    var feedViewModel = FeedViewModel()
    let imageCache = NSCache<AnyObject, AnyObject>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.feedViewModel.parseJson()
        self.feedCollectionView.reloadData()
    }
    
    
}

extension FeedViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feedViewModel.posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let feedCell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedCollectionViewCell.cellIdentifier, for: indexPath) as? FeedCollectionViewCell else { return UICollectionViewCell() }
        let post = feedViewModel.posts[indexPath.row]
        feedCell.configureCell(for: post)
        if let imageUrl = post.userImageUrl {
            getImagefor(imageUrl, indexPath)
        }
        if indexPath.row == 0 {
            feedCell.playVideo()
        }
        
        return feedCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = ProfileViewController.initiateProfileViewController()
        self.present(vc, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.feedCollectionView.frame.width, height: self.feedCollectionView.frame.height)
    }
    
    func getIndexPath() -> IndexPath {
        var visibleRect = CGRect()
        
        visibleRect.origin = feedCollectionView.contentOffset
        visibleRect.size = feedCollectionView.bounds.size
        
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        
        guard let indexPath = feedCollectionView.indexPathForItem(at: visiblePoint) else { return IndexPath() }
        
        return indexPath
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let indexPath = getIndexPath()
        guard let cell = feedCollectionView.cellForItem(at: indexPath) as? FeedCollectionViewCell else { return }
        cell.pauseVideo()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let indexPath = getIndexPath()
        guard let cell = feedCollectionView.cellForItem(at: indexPath) as? FeedCollectionViewCell else { return }
        cell.playVideo()
       
    }

    func getImagefor(_ imageUrl: String, _ indexPath: IndexPath) {
        if let imageFromCache = self.imageCache.object(forKey: imageUrl as AnyObject) as? UIImage {
            self.putImage(at: indexPath, imageFromCache)
        } else {
            ImageDownloader.sharedInstance.downloadImageFrom(urlString: imageUrl, indexPath: indexPath) { [weak self] (image, index) in
                DispatchQueue.main.async {
                    self?.imageCache.setObject(image, forKey: imageUrl as AnyObject)
                    self?.putImage(at: index, image)
                    self?.feedCollectionView.reloadData()
                }

            }
        }
    }
    func putImage(at indexPath: IndexPath, _ image: UIImage) {
        if let updateCell = self.feedCollectionView.cellForItem(at: indexPath) as? FeedCollectionViewCell {
            updateCell.profileImageButton.setImage(image, for: .normal)
        }
    }
    
}

