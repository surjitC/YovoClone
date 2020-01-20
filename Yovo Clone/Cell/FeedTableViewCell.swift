//
//  FeedTableViewCell.swift
//  Yovo Clone
//
//  Created by Surjit's iMac on 20/01/20.
//  Copyright © 2020 Surjit. All rights reserved.
//

import UIKit
import AVFoundation

class FeedTableViewCell: UITableViewCell {

    // MARK: - Cell Identifier
    static let cellIdentifier = "FeedTableViewCell"
    
    // MARK: - IBOutlets
    @IBOutlet var playerView: PlayerView!
    @IBOutlet var playerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var userName: UILabel!
    @IBOutlet var time: UILabel!
    @IBOutlet var profileImageButton: UIButton!
    
    // MARK: - Properties
    var post: Post?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        playerViewHeightConstraint.constant = UIScreen.main.bounds.height
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        playerViewHeightConstraint.constant = UIScreen.main.bounds.height
        
    }
    
    func configureCell(for post: Post) {
        self.contentView.layer.borderWidth = 2
        self.contentView.layer.borderColor = UIColor.black.cgColor
        self.userName.text = post.userName
        self.time.text = post.time
        self.post = post
//        self.setVideo()
    }
    
    func setVideo() {
        guard let url = self.post?.vUrl else { return }
        let videoURL = NSURL(string: url)!
        let avPlayer = AVPlayer(url: videoURL as URL)
        self.playerView.playerLayer.player = avPlayer
        
    }
    
    func setImage(imageData: Data) {
        self.userName.text = "Hello"
        self.profileImageButton.setBackgroundImage(UIImage(data: imageData), for: .normal)
    }

}
