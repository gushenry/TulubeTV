//
//  ViewController.swift
//  Tulube
//
//  Created by James Ormond on 10/23/16.
//  Copyright © 2016 James Ormond. All rights reserved.
//

import UIKit

/**
 This class represents the UIViewController for drawing. All zooming and panning
 functionality is handled by this class.
 
 Note: All touches related to drawing on the Canvas are not handled by the
 DrawViewController, and are instead handled by the Canvas itself.
 */
class DrawViewController: UIViewController, UIScrollViewDelegate {
    
    
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var deviceCodeLabel: UILabel!
    
    var imageViewSize : CGSize = CGSize(width: 0, height: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let canvas = Canvas()
        let drawModel = DrawModel()
        DrawManager.sharedInstance.canvas = canvas
        DrawManager.sharedInstance.drawModel = drawModel
      
        SocketIOManager.sharedInstance.drawViewController = self
        SocketIOManager.sharedInstance.establishConnection()
        
        canvas.frame.size = CGSize(width: 900, height: 600)
        canvas.backgroundColor = UIColor.white
        canvas.isUserInteractionEnabled = true
        
        //        scrollView = UIScrollView(frame: view.bounds)
        scrollView.backgroundColor = UIColor.lightGray
        scrollView.contentSize = canvas.bounds.size
        
        scrollView.addSubview(canvas)
        //        view.addSubview(scrollView)
        
        scrollView.delegate = self
        
        // remove gesture delays on scroll view
        if let gestures = scrollView.gestureRecognizers {
            for gesture in gestures {
                gesture.delaysTouchesBegan = false
            }
        }
        
        self.imageViewSize = canvas.bounds.size
        
        setZoomScale()
        scrollViewDidZoom(scrollView)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return DrawManager.sharedInstance.canvas
    }
    
    /**
     Sets the zoom scale (min and max) for zooming functionality.
     */
    func setZoomScale() {
        let scrollViewSize = scrollView.bounds.size
        let widthScale = scrollViewSize.width / self.imageViewSize.width
        let heightScale = scrollViewSize.height / self.imageViewSize.height
        
        //        scrollView.minimumZoomScale = 0.1
        //        scrollView.maximumZoomScale = 6.0
        //        scrollView.zoomScale = 1.0
        
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 1.0
        scrollView.zoomScale = 1.0
        
    }
    
    override func viewWillLayoutSubviews() {
        setZoomScale()
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let imageViewSize = DrawManager.sharedInstance.canvas!.frame.size
        let scrollViewSize = scrollView.bounds.size
        
        let verticalPadding = imageViewSize.height < scrollViewSize.height ? (scrollViewSize.height - imageViewSize.height) / 2 : 0
        let horizontalPadding = imageViewSize.width < scrollViewSize.width ? (scrollViewSize.width - imageViewSize.width) / 2 : 0
        
        scrollView.contentInset = UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding)
    }
    
    @IBAction func blackPressed(_ sender: UIBarButtonItem) {
        DrawManager.sharedInstance.setColor(hex: "#000000")
    }
    
    @IBAction func bluePressed(_ sender: UIBarButtonItem) {
        DrawManager.sharedInstance.setColor(hex: "#0000FF")
    }
    
    @IBAction func greenPressed(_ sender: UIBarButtonItem) {
        DrawManager.sharedInstance.setColor(hex: "#00FF00")
    }
    
    @IBAction func redPressed(_ sender: UIBarButtonItem) {
        DrawManager.sharedInstance.setColor(hex: "#FF0000")
    }
    
    @IBAction func eraserPressed(_ sender: UIBarButtonItem) {
//        if self.eraserButton.tintColor == nil {
//            self.eraserButton.tintColor = UIColor.red
//        } else {
//            self.eraserButton.tintColor = nil
//        }
        DrawManager.sharedInstance.eraserPressed()
    }
    
    @IBAction func clearPressed(_ sender: UIBarButtonItem) {
        DrawManager.sharedInstance.clearCanvas(emit: true)
    }
    
    @IBAction func thicknessChanged(_ sender: Any) {
//        let thickness = self.thicknessSlider.value
//        DrawManager.sharedInstance.updateThickness(thickness: thickness)
    }
    
//    override var prefersStatusBarHidden: Bool {
//        return true
//    }
  
}

