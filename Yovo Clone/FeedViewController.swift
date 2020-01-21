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
//        if let imageUrl = post.userImageUrl {
//            self.feedViewModel.downloadImage(from: imageUrl, at: indexPath) { (data, index) in
//                if let data = data {
//                    DispatchQueue.main.async {
//                        guard let cell = collectionView.cellForItem(at: index) as? FeedCollectionViewCell else { return }
//                        cell.setImage(imageData: data)
//                        self.feedCollectionView.reloadData()
//                    }
//                }
//            }
//        }
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
    
}

