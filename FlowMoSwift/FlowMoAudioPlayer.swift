//
//  FlowMoAudioPlayer.swift
//  FlowMoSwift
//
//  Created by Bryan Ryczek on 12/18/15.
//  Copyright © 2015 Bryan Ryczek. All rights reserved.
//

import UIKit
import AVFoundation

class FlowMoAudioPlayer: UIViewController {

    var audioPlayer: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func playAudio() {
        let path = NSBundle.mainBundle().pathForResource("recording.m4a", ofType:nil)!
        let url = NSURL(fileURLWithPath: path)
        
        do {
            let sound = try AVAudioPlayer(contentsOfURL: url)
            audioPlayer = sound
            sound.play()
        } catch {
            print("contents")
        }
    }
    
    func playAudio(url: NSURL) {
        do {
            let sound = try AVAudioPlayer(contentsOfURL: url)
            audioPlayer = sound
            sound.play()
        } catch {
            print("contents")
        }
    }
    
    func stopAudio() {
        if audioPlayer != nil {
            audioPlayer.stop()
            audioPlayer = nil
        }
    }
}
