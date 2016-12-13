//
//  ViewController.swift
//  JDAnimationKit
//
//  Created by Juanpe on 02/22/2016.
//  Copyright (c) 2016 Juanpe. All rights reserved.
//

import UIKit
import JDAnimationKit

class ViewController: UIViewController {
    
    @IBOutlet weak var squareView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        var frame = self.squareView.frame
        frame.size.width = frame.height

        self.squareView.changeAnchorPoint(0, y: 0.5)
            .changeBounds(frame, spring: true)
            .changeBgColor(UIColor.green)
            .changeAnchorPoint(0, y: 0, delay: 0.6)
            .rotateTo(60, spring: true, springConfig: JDSpringConfig(bounciness: 20, speed: 10), delay:0.7)
            .didStopAnimation { (node, key, finished, error) -> Void in
                
                if finished == true{
                    self.squareView.moveYTo(1000, duration: 0.8, timing: .easeIn).opacityTo(0, duration: 1)
                }
        }
    }
}

