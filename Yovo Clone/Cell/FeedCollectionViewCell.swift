//
//  FeedCollectionViewCell.swift
//  Yovo Clone
//
//  Created by Surjit's iMac on 20/01/20.
//  Copyright © 2020 Surjit. All rights reserved.
//

import UIKit
import AVFoundation

class FeedCollectionViewCell: UICollectionViewCell {

    // MARK: - Cell Identifier
    static let cellIdentifier = "FeedCollectionViewCell"
    
    // MARK: - IBOutlets
    @IBOutlet var playerView: PlayerView!
    @IBOutlet var userName: UILabel!
    @IBOutlet var timeAgo: UILabel!
    @IBOutlet var profileImageButton: UIButton!
    
    // MARK: - Properties
    var post: Post?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.configureUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.configureUI()
    }
    
    func configureUI() {
        self.profileImageButton.layer.borderColor = UIColor.white.cgColor
        self.profileImageButton.layer.borderWidth = 2.0
        self.profileImageButton.layer.cornerRadius = 20.0
    }
    
    func configureCell(for post: Post) {
        self.userName.text = post.userName
        self.timeAgo.text = post.time
        self.post = post
    }
    
    func playVideo() {
        self.pauseVideo()
        guard let url = self.post?.vUrl else { return }
        let videoURL = URL(string: url)!
        let avPlayer = AVPlayer(url: videoURL)
        self.playerView.playerLayer.player = avPlayer
        self.playerView.player?.play()
    }
    
    func pauseVideo() {
        self.playerView.player?.seek(to: .zero)
        self.playerView.player?.pause()
    }
    
    func setImage(imageData: Data) {
        self.profileImageButton.setBackgroundImage(UIImage(data: imageData), for: .normal)
    }

}
