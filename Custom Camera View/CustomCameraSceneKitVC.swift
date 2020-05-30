//
//  CustomCameraSceneKitVC.swift
//  Custom Camera View
//
//  Created by Pawan kumar on 28/05/20.
//  Copyright © 2020 Pawan Kumar. All rights reserved.
//


import UIKit
import SceneKit
import ARKit

class CustomCameraSceneKitVC: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var captureImageView: UIImageView!
    @IBOutlet weak var takePhoto: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Connfiguration ARKit
        self.configurationARKit()
    }
    
   override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    func configurationARKit() {
           
           // Configure the ARSCNView which will be used to display the AR content.
           sceneView.delegate = self
           
           // Since we will also capture from the view we will limit ourselves to 30 fps.
           sceneView.preferredFramesPerSecond = 60
           // Since we are in a streaming environment, we will render at a relatively low resolution.
           sceneView.contentScaleFactor = 1

           start()
       }
       func start() {
           // Starting capture is a two step process. We need to start the ARSession and schedule the CADisplayLinkTimer.
           let configuration = ARWorldTrackingConfiguration()
           sceneView.session.run(configuration)
       }
    
    func stop() {
          self.sceneView.session.pause()
      }

    @IBAction func didTakePhoto(_ button: UIButton) {
        
       let currentFrame = self.sceneView.snapshot
       
      //Convert Image to Givin Size
      let senndImage: UIImage = currentFrame()
      captureImageView.image = senndImage
    }
}
