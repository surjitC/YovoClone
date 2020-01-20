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
    @IBOutlet var feedTableView: UITableView!
    
    //MARK: - Properties
    var feedViewModel = FeedViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.feedViewModel.parseJson()
        self.feedTableView.reloadData()
    }
    
    
}

extension FeedViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedViewModel.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let feedCell = tableView.dequeueReusableCell(withIdentifier: FeedTableViewCell.cellIdentifier, for: indexPath) as? FeedTableViewCell else { return UITableViewCell() }
        let post = feedViewModel.posts[indexPath.row]
        feedCell.configureCell(for: post)
        if let imageUrl = post.userImageUrl {
            self.feedViewModel.downloadImage(from: imageUrl, at: indexPath) { (data, index) in
                if let data = data {
                    DispatchQueue.main.async {
                        guard let cell = tableView.cellForRow(at: index) as? FeedTableViewCell else { return }
                        cell.setImage(imageData: data)
                        
                        self.feedTableView.reloadData()
                    }
                }
            }
        }
        
        return feedCell
        
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        var visibleRect = CGRect()
        
        visibleRect.origin = feedTableView.contentOffset
        visibleRect.size = feedTableView.bounds.size
        
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        
        guard let indexPath = feedTableView.indexPathForRow(at: visiblePoint) else { return }
        
        print(indexPath)
    }
}

