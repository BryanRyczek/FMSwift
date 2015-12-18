////
////  FlowMoAudioRecorder.swift
////  FlowMoSwift
////
////  Created by Bryan Ryczek on 12/16/15.
////  Copyright © 2015 Bryan Ryczek. All rights reserved.
////
//
//import UIKit
//import AVFoundation
//import Foundation
//
//class FlowMoAudioRecorder: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
//
//    var audioRecorder: AVAudioRecorder!
//    var recordingSession: AVAudioSession!
//    var audioPlayer: AVAudioPlayer
//    var audioURL: NSURL
//    
//    
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        recorderSetup()
//    }
//    
//    func recorderSetup() {
//        recordingSession = AVAudioSession.sharedInstance()
//        
//        do {
//            try recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
//            try recordingSession.setActive(true)
//            recordingSession.requestRecordPermission() { [unowned self] (allowed: Bool) -> Void in
//                dispatch_async(dispatch_get_main_queue()) {
//                    if allowed {
//                        //Do nothing
//                    } else {
//                        // failed to record!
//                    }
//                }
//            }
//        } catch {
//            // failed to record!
//        }
//    }
//    
//    func loadRecordingUI() {
//        //RECORDING UI
//    }
//    
//    func startRecording() {
//        let audioFilename = getDocumentsDirectory().URLByAppendingPathComponent("recording.m4a")
//        let audioURL = NSURL(fileURLWithPath: audioFilename)
//        
//        let settings = [
//            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
//            AVSampleRateKey: 12000.0,
//            AVNumberOfChannelsKey: 1 as NSNumber,
//            AVEncoderAudioQualityKey: AVAudioQuality.High.rawValue
//        ]
//        
//        do {
//            audioRecorder = try AVAudioRecorder(URL: audioURL, settings: settings)
//            audioRecorder.delegate = self
//            audioRecorder.record()
//        } catch {
//            finishRecording(success: false)
//        }
//    }
//    
//    func getDocumentsDirectory() -> String {
//        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
//        let documentsDirectory = paths[0]
//        return documentsDirectory
//    }
//    
//    func finishRecording(success success:Bool) {
//        audioRecorder.stop()
//        audioRecorder = nil
//        if success {
//            // Recording Successful!
//        } else {
//            // Recording Failed!
//        }
//    }
//    
//    func flowmoRecording() {
//        if audioRecorder == nil {
//            startRecording()
//        } else {
//            finishRecording(success: true)
//        }
//    }
//    
//    // If iOS stops recording, this will handle the interruption so we aren't still recording
//    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
//        if !flag {
//            finishRecording(success: false)
//        }
//    }
//    
//}
