//
//  ViewController.swift
//  VideoDecibel
//
//  Created by iot-parksooseong on 2022/11/28.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureAudioDataOutputSampleBufferDelegate {
    
    var captureSession: AVCaptureSession!
    var backCamera: AVCaptureDevice!
    var frontCamera: AVCaptureDevice!
    var backCameraInput: AVCaptureInput!
    var frontCameraInput: AVCaptureInput!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var videoOutput: AVCaptureVideoDataOutput!
    var audioOutput: AVCaptureAudioDataOutput!

    var takePicture = false
    var isBackCamera = true

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        captureSession = AVCaptureSession()
        captureSession.beginConfiguration()
        if captureSession.canSetSessionPreset(.high) {
            captureSession.sessionPreset = .high
        }
        
        if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
                    backCamera = device
                } else {
                    fatalError("후면 카메라가 없어요.")
                }
                
                if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) {
                    frontCamera = device
                } else {
                    fatalError("전면 카메라가 없어요.")
                }
                
                guard let backCameraDeviceInput = try? AVCaptureDeviceInput(device: backCamera) else {
                    fatalError("후면 카메라로 인풋설정이 불가능합니다.")
                }
                backCameraInput = backCameraDeviceInput
                if !captureSession.canAddInput(backCameraInput) {
                    fatalError("후면 카메라 설치가 되지 않습니다.")
                }
                
                guard let frontCameraDeviceInput = try? AVCaptureDeviceInput(device: frontCamera) else {
                    fatalError("전면 카메라로 인풋설정이 불가능합니다.")
                }
                frontCameraInput = frontCameraDeviceInput
                if !captureSession.canAddInput(frontCameraInput) {
                    fatalError("전면 카메라 설치가 되지 않습니다.")
                }
                
                captureSession.addInput(backCameraInput)
        
        let audioDevice = AVCaptureDevice.default(for: AVMediaType.audio)!
            let audioInput = try? AVCaptureDeviceInput(device: audioDevice)
            if captureSession.canAddInput(audioInput!) {
              captureSession.addInput(audioInput!)
            }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.connection?.videoOrientation = .portrait
        self.previewLayer.frame = self.view.frame
        view.layer.insertSublayer(previewLayer, at: 0)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        videoOutput = AVCaptureVideoDataOutput()
        audioOutput = AVCaptureAudioDataOutput()
        let cameraSampleBufferQueue = DispatchQueue(label: "cameraGlobalQueue", qos: .userInteractive)
        let queue = DispatchQueue(label: "cameraAudioGlobalQueue", qos: .userInteractive)
        videoOutput.setSampleBufferDelegate(self, queue: cameraSampleBufferQueue)
        audioOutput.setSampleBufferDelegate(self, queue: queue)
                
//        if captureSession.canAddOutput(videoOutput) {
//            captureSession.addOutput(videoOutput)
//        } else {
//            fatalError("아웃풋 설정이 불가합니다.")
//        }
        
        if captureSession.canAddOutput(audioOutput) {
            captureSession.addOutput(audioOutput)
        } else {
            fatalError("아웃풋 설정이 불가합니다.")
        }
        videoOutput.connections.first?.videoOrientation = .portrait

        captureSession.commitConfiguration()
        
        DispatchQueue.global().async {
            self.captureSession.startRunning()
        }
        
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        print("여기 \(output.connection(with: .video)) \(output.connection(with: .audio)))")
        
            if !takePicture {
                return
            }
        
            guard let cvBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
                return
            }
            let ciImage = CIImage(cvImageBuffer: cvBuffer)
            let uiImage = UIImage(ciImage: ciImage)
            self.takePicture = false
            self.captureSession.stopRunning()
//            DispatchQueue.main.async {
//                guard let pictureViewController = self.storyboard?.instantiateViewController(identifier: "PictureViewController") as? PictureViewController else { return }
//                pictureViewController.picture = uiImage
//                self.present(pictureViewController, animated: true, completion: nil)
//
//            }
    }
    
//    func switchCameraInput() { //카메라 화면 전환
//            switchCameraButton.isUserInteractionEnabled = false
//            //이렇게 값 변경할때 필요한 begin, commit!!
//            captureSession.beginConfiguration()
//            if isbackCamera {
//                captureSession.removeInput(backInput)
//                captureSession.addInput(frontInput)
//                isbackCamera = false
//            } else {
//                captureSession.removeInput(frontInput)
//                captureSession.addInput(backInput)
//                isbackCamera = true
//            }
//            videoOutput.connections.first?.videoOrientation = .portrait
//            videoOutput.connections.first?.isVideoMirrored = !isbackCamera
//
//            captureSession.commitConfiguration()
//
//            switchCameraButton.isUserInteractionEnabled = true
//    }
}
