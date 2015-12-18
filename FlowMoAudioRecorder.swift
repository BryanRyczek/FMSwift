//
//  FlowMoAudioRecorder.swift
//  FlowMoSwift
//
//  Created by Bryan Ryczek on 12/16/15.
//  Copyright © 2015 Bryan Ryczek. All rights reserved.
//


import UIKit
import AVFoundation
import Foundation

class FlowMoAudioRecorder: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    //MARK: GLOBAL VARS
    var recordButton: UIButton!
    var audioRecorder: AVAudioRecorder!
    var recordingSession: AVAudioSession!
    
    // MARK: SETUP METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        recorderSetup()
    }
    
    func recorderSetup() {
        recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] (allowed: Bool) -> Void in
                dispatch_async(dispatch_get_main_queue()) {
                    if allowed {
                        self.loadRecordingUI()
                    } else {
                        // failed to record!
                    }
                }
            }
        } catch {
            // failed to record!
        }
    }
    // MARK: UI METHODS
    func loadRecordingUI() {
        recordButton = UIButton(frame: CGRect(x: 64, y: 64, width: 128, height: 64))
        recordButton.backgroundColor = UIColor.blackColor()
        recordButton.setTitle("Tap to Record", forState: .Normal)
        recordButton.titleLabel?.font = UIFont.preferredFontForTextStyle(UIFontTextStyleTitle1)
        recordButton.addTarget(self, action: "recordTapped", forControlEvents: .TouchUpInside)
        view.addSubview(recordButton)
    }
    // MARK: RECORDING METHODS
    func recordTapped() {
        if audioRecorder == nil {
            startRecording()
        } else {
            finishRecording(success: true)
        }
    }    

    
    func startRecording() {
        let audioFilename = try! NSFileManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: true).URLByAppendingPathComponent("recording.m4a").path!
        //let audioFilename = getDocumentsDirectory().URLByAppendingPathComponent("recording.m4a")
        let audioURL = NSURL(fileURLWithPath: audioFilename)
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000.0,
            AVNumberOfChannelsKey: 1 as NSNumber,
            AVEncoderAudioQualityKey: AVAudioQuality.High.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(URL: audioURL, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()
        } catch {
            finishRecording(success: false)
        }
    }
    
    func finishRecording(success success:Bool) {
        audioRecorder.stop()
        audioRecorder = nil
        if success {
            print("Recording Successful")
        } else {
            print("Recording Failed")
        }
    }
    
    //MARK: DATA HANDLING METHODS
    func getDocumentsDirectory() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    // MARK: HELPER METHODS
    // If iOS stops recording, this will handle the interruption so we aren't still recording
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
        }
    }
    
}
