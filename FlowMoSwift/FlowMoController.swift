//
//  FlowMoController.swift
//  FlowMoSwift
//
//  Created by Conor Carey on 12/8/15.
//  Copyright © 2015 Bryan Ryczek. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import AVKit
import CoreMedia

class FlowMoController: UIViewController, AVCaptureFileOutputRecordingDelegate {
    
    // define capture session
    let captureSession = AVCaptureSession()
    // define device output
    var videoFileOutput : AVCaptureMovieFileOutput?
    // var to denote recording status
    var isRecording = false

    func capture (sender: AnyObject) {  //cont
    //if we are not currently recording
        if !isRecording {
            isRecording = true
            print ("start recording")
            let outputPath = NSTemporaryDirectory() + "output.mov"
            let outputFileURL = NSURL(fileURLWithPath: outputPath)
            videoFileOutput?.startRecordingToOutputFileURL(outputFileURL, recordingDelegate: self)
    }   else {
            isRecording = false
            videoFileOutput?.stopRecording()
            print ("stop recording")
    }
}
    
    //cont
    func captureOutput(captureOutput: AVCaptureFileOutput!, didFinishRecordingToOutputFileAtURL outputFileURL: NSURL!, fromConnections connections: [AnyObject]!, error: NSError!) {
        if error != nil {
            print(error)
            return
        }
        let urlString = outputFileURL.absoluteString
        UISaveVideoAtPathToSavedPhotosAlbum(urlString, nil, nil, nil)
        generateImageSequence(outputFileURL)
    }
    
    //cont
    func generateImageSequence(outputFileURL: NSURL) {
        let avURLAsset = AVURLAsset(URL: outputFileURL, options:nil)
        
        let imageGenerator = AVAssetImageGenerator.init(asset: avURLAsset)
        imageGenerator.requestedTimeToleranceAfter=kCMTimeZero
        imageGenerator.requestedTimeToleranceBefore=kCMTimeZero
        
        var imageHashRate: [NSValue] = []
        var loopDuration = avURLAsset.duration.value
        let timeValue = Float(CMTimeGetSeconds(avURLAsset.duration))
        print (loopDuration)
        
        for var t = 0; t < 1800; t + 20 {
            var cmTime = CMTimeMake(Int64(t), avURLAsset.duration.timescale)
            var timeValue = NSValue(CMTime: cmTime)
            imageHashRate.append(timeValue)
            
            var imageArray: [UIImage]
            if (!imageArray) {
                imageArray =
            }
            
        }
        
//        -(NSMutableArray *)generateImageSequence:(NSURL *)outputFileURL
//        {
//            
//            NSURL *url = outputFileURL;
//            AVURLAsset *urlAsset = [[AVURLAsset alloc] initWithURL:url options:[NSDictionary dictionaryWithObject:@"YES" forKey:AVURLAssetPreferPreciseDurationAndTimingKey]]; //Change Object to @"NO" to turn off precise access.
//            
//            AVAssetImageGenerator *imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:urlAsset];
//            imageGenerator.requestedTimeToleranceAfter=kCMTimeZero;
//            imageGenerator.requestedTimeToleranceBefore=kCMTimeZero;
//            
//            NSMutableArray *thumbTimes = [[NSMutableArray alloc]init];
//            NSInteger assetDuration = urlAsset.duration.value;
//            
//            if (assetDuration > recordingDuration) {
//                assetDuration = recordingDuration;
//            }
//            
//            
//            for(int t=flowMoStart; t < assetDuration; t=t+20) {
//                CMTime thumbTime = CMTimeMake(t, urlAsset.duration.timescale);
//                NSValue *timeValue=[NSValue valueWithCMTime:thumbTime];
//                [thumbTimes addObject:timeValue];
//            }
//            
//            if (!_imageArray) {
//                _imageArray = [[NSMutableArray alloc] initWithCapacity:thumbTimes.count];
//            } else {
//                [_imageArray removeAllObjects];
//                
//            }
//            
//            //RESET flowMoStart, recordingDuration
//            flowMoStart = 0;
//            recordingDuration = 3000;
//            
//            
//            [imageGenerator generateCGImagesAsynchronouslyForTimes:thumbTimes
//                completionHandler:^(CMTime requestedTime, CGImageRef image, CMTime actualTime,
//                AVAssetImageGeneratorResult result, NSError *error)
//                {
//                if (result == AVAssetImageGeneratorSucceeded) {
//                
//                NSLog(@"SUCCESS!");
//                if ( _cameraOrientation == 1) {
//                
//                [_imageArray addObject:[UIImage imageWithCGImage:image scale:1.0 orientation:UIImageOrientationRight]];
//                
//                } else if (_cameraOrientation == 2) {
//                
//                [_imageArray addObject:[UIImage imageWithCGImage:image scale:1.0 orientation:UIImageOrientationLeftMirrored]];
//                
//                }
//                
//                if (thumbTimes.count == self.imageArray.count) {
//                
//                [self present: outputFileURL];
//                }
//                }
//                if (result == AVAssetImageGeneratorFailed) {
//                NSLog(@"Failed with error: %@", [error localizedDescription]);
//                }
//                if (result == AVAssetImageGeneratorCancelled) {
//                NSLog(@"Canceled");
//                }
//                
//                }];
//            
//            return _imageArray;
//            
//        }
    }
}