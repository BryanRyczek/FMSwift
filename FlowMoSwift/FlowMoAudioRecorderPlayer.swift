//
//  FlowMoAudioRecorderPlayer.swift
//  FlowMoSwift
//
//  Created by Bryan Ryczek on 12/30/15.
//  Copyright © 2015 Bryan Ryczek. All rights reserved.
//

import AVFoundation
import Foundation

class FlowMoAudioRecorderPlayer: NSObject {

    var audioRecorder:AVAudioRecorder!
    var audioPlayer:AVAudioPlayer!
    
    let recordSettings = [AVSampleRateKey : NSNumber(float: Float(44100.0)),
        AVFormatIDKey : NSNumber(int: Int32(kAudioFormatMPEG4AAC)),
        AVNumberOfChannelsKey : NSNumber(int: 1),
        AVEncoderAudioQualityKey : NSNumber(int: Int32(AVAudioQuality.Medium.rawValue))]
    
    func audioSetup() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryRecord)
            try audioRecorder = AVAudioRecorder(URL: self.directoryURL()!, settings: recordSettings)
            audioRecorder.prepareToRecord()
        } catch {
        }
    }
    
    func directoryURL() -> NSURL? {
        let fileManager = NSFileManager.defaultManager()
        let urls = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        let documentDirectory = urls[0] as NSURL
        let soundURL = documentDirectory.URLByAppendingPathComponent("sound.m4a")
        return soundURL
    }
    
    func recordAudio() {
        if !audioRecorder.recording {
            let audioSession = AVAudioSession.sharedInstance()
            do {
                try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
                print("record")
                try audioSession.setActive(true)
                audioRecorder.record()
            } catch {
            }
        }
    }
    
    func playAudio(url: NSURL, startTime: NSTimeInterval) {
            do {
                print(startTime)
                try audioPlayer = AVAudioPlayer(contentsOfURL: url)
                //audioPlayer.prepareToPlay()
                audioPlayer.currentTime = startTime
                audioPlayer.play()
            } catch {
        }
    
    }
    
        func stopRecording() {
            audioRecorder.stop()
            let audioSession = AVAudioSession.sharedInstance()
            do {
                print("stop")
                try audioSession.setActive(false)
                try audioSession.setCategory(AVAudioSessionCategoryPlayback)
            } catch {
                
            }
        }
    
}
