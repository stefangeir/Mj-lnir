//
//  InstagramMediaCVVideoCell.swift
//  Mjölnir
//
//  Created by Stefán Geir on 9.3.2015.
//  Copyright (c) 2015 Stefán Geir Sigfússon. All rights reserved.
//

import UIKit
import MediaPlayer

class InstagramMediaCVVideoCell: UICollectionViewCell {
    
    var media: InstagramMedia? {
        didSet {
            updateUI()
        }
    }
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var videoIcon: UILabel! {
        didSet {
            let recognizer = UITapGestureRecognizer(target: self, action: "playPause:")
            videoIcon.addGestureRecognizer(recognizer)
            videoIcon.userInteractionEnabled = true
        }
    }
    
    func showVideoIcon() {
        videoIcon.textColor = UIColor.redColor()
    }
    
    func hideVideoIcon() {
        videoIcon.textColor = UIColor.clearColor()
    }
    
    var player: MPMoviePlayerController?
    
    func updateUI() {
        if let media = media {
            if media.isVideo {
                let imageURL = media.standardResolutionImageURL
                imageView.setImageWithURL(imageURL, placeholderImage: UIImage(named: placeholderImageNameString))
                player = MPMoviePlayerController(contentURL: media.standardResolutionVideoURL)
                if let player = player {
                    player.view.frame = bounds
                    player.view.backgroundColor = UIColor.clearColor()
                    player.scalingMode = MPMovieScalingMode.AspectFit
                    player.controlStyle = MPMovieControlStyle.None
                    player.repeatMode = .One
                    player.shouldAutoplay = true
                    player.prepareToPlay()
                }
            }
        }
    }
    
    func playPause(gesture: UITapGestureRecognizer) {
        if gesture.state == .Ended {
            if let player = player {
                if player.playbackState == .Playing {
                    player.pause()
                } else if player.playbackState == .Paused || player.playbackState == .Stopped {
                    player.play()
                }
            }
        }
    }
    
    var initialPlay = true
    
    func playbackStateChanged() {
        if let player = player {
            switch player.playbackState {
            case .Stopped, .Paused, .Interrupted:
                showVideoIcon()
            case .Playing:
                if initialPlay {
                    contentView.insertSubview(player.view, belowSubview: videoIcon)
                    initialPlay = false
                }
                
                hideVideoIcon()
            default:
                break
            }
        }
    }
}
