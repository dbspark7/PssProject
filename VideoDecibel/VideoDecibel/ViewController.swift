//
//  ViewController.swift
//  VideoDecibel
//
//  Created by iot-parksooseong on 2022/11/28.
//

import UIKit
import AVFoundation
import Photos

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
    
    var recorder: AVAudioRecorder!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        try! AVAudioSession.sharedInstance().setCategory(.multiRoute)
//        try! AVAudioSession.sharedInstance().setMode(.voiceChat)
        try! AVAudioSession.sharedInstance().setMode(.measurement)
        try! AVAudioSession.sharedInstance().setActive(true)
        
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
        
//        let audioDevice = AVCaptureDevice.default(for: AVMediaType.audio)!
//            let audioInput = try? AVCaptureDeviceInput(device: audioDevice)
//            if captureSession.canAddInput(audioInput!) {
//              captureSession.addInput(audioInput!)
//            }
        
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
                
        if captureSession.canAddOutput(videoOutput) {
            captureSession.addOutput(videoOutput)
        } else {
            fatalError("아웃풋 설정이 불가합니다.")
        }
        
//        if captureSession.canAddOutput(audioOutput) {
//            captureSession.addOutput(audioOutput)
//        } else {
//            fatalError("아웃풋 설정이 불가합니다.")
//        }
        videoOutput.connections.first?.videoOrientation = .portrait

        captureSession.commitConfiguration()
        
        DispatchQueue.global().async {
            self.captureSession.startRunning()
        }
        
        
//        let recordersettings = [
//                AVFormatIDKey: Int(kAudioFormatAppleIMA4),
//                AVSampleRateKey: 44100,
//                AVNumberOfChannelsKey: 1,
//                AVLinearPCMBitDepthKey: 16,
//                AVLinearPCMIsFloatKey: false,
//                AVLinearPCMIsBigEndianKey: false,
//                //AVEncoderAudioQualityKey: AVAudioQuality.High.rawValue
//        ] as [String : Any]
        
//        let recordSettings = [AVSampleRateKey : 44100,
//                AVFormatIDKey : Int(kAudioFormatMPEG4AAC),
//                AVNumberOfChannelsKey : 1,
//                AVEncoderAudioQualityKey : AVAudioQuality.high.rawValue]
        
        let settings:[String : Any] = [ AVFormatIDKey : kAudioFormatAppleLossless,
            AVEncoderAudioQualityKey : AVAudioQuality.max.rawValue,
            AVEncoderBitRateKey: 320000,
            AVNumberOfChannelsKey : 2,
            AVSampleRateKey : 44100.0 ] as [String : Any]
        
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        let recordOutputUrl = URL(fileURLWithPath: documentsPath.appendingPathComponent("videoFile")).appendingPathExtension("mp4")
        
        
//        AVAudioSession.sharedInstance().requestRecordPermission({ [weak self] asdf in
//
//        })

        PHPhotoLibrary.requestAuthorization { [weak self] status in
            if status == .authorized {
                do
                {
                    self?.recorder = try AVAudioRecorder(url: recordOutputUrl, settings: settings)
                    self?.recorder.isMeteringEnabled = true
                    if self?.recorder.prepareToRecord() ?? false {
                        self?.recorder.record()
                    }
                    
                }
                catch let error
                {
                    print("error: \(error)")
                }
            } else {
                
            }
        }
        
        
    }
    
    private func normalizeSoundLevel(level: Float) -> Float {
            // 화면에 표시되는 rawSoundLevel 기준
            // white noise만 존재할 때의 값을 lowLevel 에 할당
            // 가장 큰 소리를 냈을 때 값을 highLevel 에 할당
            
            let lowLevel: Float = -50
            let highLevel: Float = -10
            
            var level = max(0.0, level - lowLevel) // low level이 0이 되도록 shift
            level = min(level, highLevel - lowLevel) // high level 도 shift
            // 이제 level은 0.0 ~ 40까지의 값으로 설정 됨.
            return level / (highLevel - lowLevel) // scaled to 0.0 ~ 1
        }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
//        print("여기 \(output.connection(with: .video)) \(output.connection(with: .audio)))")
        if recorder != nil {
            recorder.updateMeters()
            let level = recorder.peakPower(forChannel: 0)
            print("여기 \(recorder.isRecording) \(recorder.averagePower(forChannel: 0)), \(recorder.peakPower(forChannel: 0))")
//            print("\(normalizeSoundLevel(level: level)) dB")
        }
        
//            if !takePicture {
//                return
//            }
//
//            guard let cvBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
//                return
//            }
//            let ciImage = CIImage(cvImageBuffer: cvBuffer)
//            let uiImage = UIImage(ciImage: ciImage)
//            self.takePicture = false
//            self.captureSession.stopRunning()
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
