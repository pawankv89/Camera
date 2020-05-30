//
//  CustomCameraDefaultVC.swift
//  Custom Camera View
//
//  Created by Pawan kumar on 28/05/20.
//  Copyright © 2020 Pawan Kumar. All rights reserved.
//
import UIKit
import AVFoundation

/*
 Help
 
 https://guides.codepath.com/ios/Creating-a-Custom-Camera-View
 
 https://medium.com/ios-os-x-development/ios-camera-frames-extraction-d2c0f80ed05a
 
 https://stackoverflow.com/questions/28487146/how-to-add-live-camera-preview-to-uiview
 
 https://developer.apple.com/documentation/avfoundation/cameras_and_media_capture/avcam_building_a_camera_app
 
 https://gist.github.com/MihaelIsaev/273e4e8ddaaf062d2155
 
 */

class CustomCameraDefaultVC: UIViewController , AVCapturePhotoCaptureDelegate{
    
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var captureImageView: UIImageView!
    @IBOutlet weak var takePhoto: UIButton!
    
    var captureSession: AVCaptureSession!
    var stillImageOutput: AVCapturePhotoOutput!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .medium
        
        
        guard let backCamera = AVCaptureDevice.default(for: AVMediaType.video)
            else {
                print("Unable to access back camera!")
                return
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: backCamera)
            //Step 9
            
            stillImageOutput = AVCapturePhotoOutput()

            if captureSession.canAddInput(input) && captureSession.canAddOutput(stillImageOutput) {
                captureSession.addInput(input)
                captureSession.addOutput(stillImageOutput)
                setupLivePreview()
            }
            
        }
        catch let error  {
            print("Error Unable to initialize back camera:  \(error.localizedDescription)")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Setup your camera here...
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.captureSession.stopRunning()
    }
    
    func setupLivePreview() {
        
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        
        videoPreviewLayer.videoGravity = .resizeAspectFill //.resizeAspect
        videoPreviewLayer.connection?.videoOrientation = .portrait
        previewView.layer.addSublayer(videoPreviewLayer)
        
        //Step12
        
        DispatchQueue.global(qos: .userInitiated).async { //[weak self] in
            self.captureSession.startRunning()
            //Step 13
            
            DispatchQueue.main.async {
                self.videoPreviewLayer.frame = self.previewView.bounds
            }
        }
    }

    @IBAction func didTakePhoto(_ button: UIButton) {
        
        let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
        stillImageOutput.capturePhoto(with: settings, delegate: self)
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
        guard let imageData = photo.fileDataRepresentation()
            else { return }
        
        let image = UIImage(data: imageData)
        captureImageView.image = image
        
        //captureImageView.image = self.takeScreenshotwindow()
    }
}
