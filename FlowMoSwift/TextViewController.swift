//
//  TextViewController.swift
//  FlowMoSwift
//
//  Created by Bryan Ryczek on 12/8/15.
//  Copyright © 2015 Bryan Ryczek. All rights reserved.
//

//CREATED FOR THE EXPRESS PURPOSE OF TESTING NEW CODE. NOT TO BE INCLUDED IN FINAL PROJECT.

import UIKit

class TextViewController: UIViewController {
    
    var flowmoSlider:UISlider?
    var slider:UISlider?
    // These number values represent each slider position
    var numbers = [1, 2, 3, 4, 5, 6, 7] //Add your values here
    var oldIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        flowmoSlider = UISlider(frame: self.view.bounds)
        self.view.addSubview(flowmoSlider!)
        flowmoSlider!.maximumValue = 100
        flowmoSlider!.minimumValue = 0
        flowmoSlider!.continuous = true
        flowmoSlider!.addTarget(self, action: "sliderValueDidChange:", forControlEvents: .ValueChanged)
        
//        slider = UISlider(frame: self.view.bounds)
//        self.view.addSubview(slider!)
//        slider!.maximumValue = numberOfSteps
//        slider!.minimumValue = 0
//        
//        // As the slider moves it will continously call the -valueChanged:
//        slider!.continuous = true; // false makes it call only once you let go
//        slider!.addTarget(self, action: "valueChanged:", forControlEvents: .ValueChanged)
    }
    
    func valueChanged(sender: UISlider) {
        // round the slider position to the nearest index of the numbers array
        var index = (Int)(slider!.value + 0.5);
        slider?.setValue(Float(index), animated: false)
        var number = numbers[index]; // <-- This numeric value you want
        if oldIndex != index{
            print("sliderIndex:\(index)")
            print("number: \(number)")
            oldIndex = index
        }
    }
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        flowmoSlider = FlowMoSlider(frame: CGRectMake(0, self.view.frame.size.height/2, self.view.frame.size.width, 31))
//        
//        flowmoSlider!.minimumValue = 0
//        flowmoSlider!.maximumValue = 100
//        flowmoSlider!.continuous = true
//        flowmoSlider!.value = 1
//        //print(flowmoSlider.value)
//        //flowmoSlider.addTarget(self, action: "sliderValueDidChange:", forControlEvents: .ValueChanged)
//        self.view.addSubview(flowmoSlider!)
//
//        // Do any additional setup after loading the view.
//    }
//
    func sliderValueDidChange(sender:UISlider!)
    {
//        var index = (Int)(flowmoSlider.value)
//        flowmoSlider?.setValue(Float(index), animated: false)
//        var number = numbers[index]; // <-- This numeric value you want
//        if oldIndex != index{
//            print("sliderIndex:\(index)")
//            print("number: \(number)")
//            oldIndex = index

        print ("value--\(sender.value)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
