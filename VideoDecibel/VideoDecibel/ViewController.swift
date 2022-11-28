//
//  ViewController.swift
//  VideoDecibel
//
//  Created by iot-parksooseong on 2022/11/28.
//

import UIKit
import AVFoundation
import Photos
import Charts
import ReplayKit

class ViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureAudioDataOutputSampleBufferDelegate {
    
    @IBOutlet var videoView: UIView!
    @IBOutlet var chartView: LineChartView!
    
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
    
    var shouldHideData: Bool = false
    
//    var values = [ChartDataEntry]()
    
    var count = 1000
    
    lazy var values: [ChartDataEntry] = {
        var ret = [ChartDataEntry]()
        for i in 0..<1000 {
            ret.append(ChartDataEntry(x: Double(i), y: 0))
        }
        return ret
    }()
    
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
        self.previewLayer.frame = self.videoView.frame
        self.videoView.layer.insertSublayer(previewLayer, at: 0)
        
        
        chartView.delegate = self

        chartView.chartDescription.enabled = false
        chartView.dragEnabled = true
        chartView.setScaleEnabled(true)
        chartView.pinchZoomEnabled = true
        
        // x-axis limit line
        let llXAxis = ChartLimitLine(limit: 10, label: "Index 10")
        llXAxis.lineWidth = 4
        llXAxis.lineDashLengths = [10, 10, 0]
        llXAxis.labelPosition = .rightBottom
        llXAxis.valueFont = .systemFont(ofSize: 10)

        chartView.xAxis.gridLineDashLengths = [10, 10]
        chartView.xAxis.gridLineDashPhase = 0

        let ll1 = ChartLimitLine(limit: 150, label: "Upper Limit")
        ll1.lineWidth = 4
        ll1.lineDashLengths = [5, 5]
        ll1.labelPosition = .rightTop
        ll1.valueFont = .systemFont(ofSize: 10)

        let ll2 = ChartLimitLine(limit: -30, label: "Lower Limit")
        ll2.lineWidth = 4
        ll2.lineDashLengths = [5,5]
        ll2.labelPosition = .rightBottom
        ll2.valueFont = .systemFont(ofSize: 10)

        let leftAxis = chartView.leftAxis
        leftAxis.removeAllLimitLines()
        leftAxis.addLimitLine(ll1)
        leftAxis.addLimitLine(ll2)
        leftAxis.axisMaximum = 50
        leftAxis.axisMinimum = -150
        leftAxis.gridLineDashLengths = [5, 5]
        leftAxis.drawLimitLinesBehindDataEnabled = true

        chartView.rightAxis.enabled = false
        
//        let marker = BalloonMarker(color: UIColor(white: 180/255, alpha: 1),
//                                   font: .systemFont(ofSize: 12),
//                                   textColor: .white,
//                                   insets: UIEdgeInsets(top: 8, left: 8, bottom: 20, right: 8))
//        marker.chartView = chartView
//        marker.minimumSize = CGSize(width: 80, height: 40)
//        chartView.marker = marker

        chartView.legend.form = .line
        
//        self.setDataCount(45, range: 100)
        
//        chartView.animate(xAxisDuration: 2.5)
    }
    
    func setData() {
        let set1 = LineChartDataSet(entries: values, label: "DataSet 1")
        set1.drawIconsEnabled = false
        setup(set1)

        let value = ChartDataEntry(x: Double(3), y: 3)
        set1.addEntryOrdered(value)
        let gradientColors = [ChartColorTemplates.colorFromString("#00ff0000").cgColor,
                              ChartColorTemplates.colorFromString("#ffff0000").cgColor]
        let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)!

        set1.fillAlpha = 1
        set1.fill = LinearGradientFill(gradient: gradient, angle: 90)
        set1.drawFilledEnabled = true

        let data = LineChartData(dataSet: set1)

        chartView.data = data
    }
    
//    func setDataCount(_ count: Int, range: UInt32) {
//        let values = (0..<count).map { (i) -> ChartDataEntry in
//            let val = Double(arc4random_uniform(range) + 3)
//            return ChartDataEntry(x: Double(i), y: val, icon: nil)
//        }
//
//        let set1 = LineChartDataSet(entries: values, label: "DataSet 1")
//        set1.drawIconsEnabled = false
//        setup(set1)
//
//        let value = ChartDataEntry(x: Double(3), y: 3)
//        set1.addEntryOrdered(value)
//        let gradientColors = [ChartColorTemplates.colorFromString("#00ff0000").cgColor,
//                              ChartColorTemplates.colorFromString("#ffff0000").cgColor]
//        let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)!
//
//        set1.fillAlpha = 1
//        set1.fill = LinearGradientFill(gradient: gradient, angle: 90)
//        set1.drawFilledEnabled = true
//
//        let data = LineChartData(dataSet: set1)
//
//        chartView.data = data
//    }
    
    private func setup(_ dataSet: LineChartDataSet) {
        if dataSet.isDrawLineWithGradientEnabled {
            dataSet.lineDashLengths = nil
            dataSet.highlightLineDashLengths = nil
            dataSet.setColors(.black, .red, .white)
            dataSet.setCircleColor(.black)
            dataSet.gradientPositions = [0, 40, 100]
            dataSet.lineWidth = 1
            dataSet.circleRadius = 3
            dataSet.drawCircleHoleEnabled = false
            dataSet.valueFont = .systemFont(ofSize: 9)
            dataSet.formLineDashLengths = nil
            dataSet.formLineWidth = 1
            dataSet.formSize = 15
        } else {
            dataSet.lineDashLengths = [5, 2.5]
            dataSet.highlightLineDashLengths = [5, 2.5]
            dataSet.setColor(.black)
            dataSet.setCircleColor(.black)
            dataSet.gradientPositions = nil
            dataSet.lineWidth = 1
            dataSet.circleRadius = 3
            dataSet.drawCircleHoleEnabled = false
            dataSet.valueFont = .systemFont(ofSize: 9)
            dataSet.formLineDashLengths = [5, 2.5]
            dataSet.formLineWidth = 1
            dataSet.formSize = 15
        }
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.previewLayer.frame = self.videoView.frame
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
//            print("여기 \(recorder.isRecording) \(recorder.averagePower(forChannel: 0)), \(recorder.peakPower(forChannel: 0))")
//            setDataCount(count, range: UInt32(recorder.peakPower(forChannel: 0)))
            count += 1
            values.removeFirst()
            values.append(ChartDataEntry(x: Double(count), y: Double(level), icon: nil))
            
            
            
            DispatchQueue.main.async {
                self.setData()
            }
            
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
    
    @IBAction func onClickButton(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            RPScreenRecorder.shared().isMicrophoneEnabled = true
            RPScreenRecorder.shared().startRecording() { error in
                print(error)
            }
        } else {
            let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
            let recordOutputUrl = URL(fileURLWithPath: documentsPath.appendingPathComponent("asdf1")).appendingPathExtension("mp4")
            
            if FileManager.default.fileExists(atPath: recordOutputUrl.path) {
                try? FileManager.default.removeItem(at: recordOutputUrl)
            }
            
            RPScreenRecorder.shared().stopRecording(withOutput: recordOutputUrl) { error in
                PHPhotoLibrary.shared().performChanges {
                    PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: recordOutputUrl)
                } completionHandler: { success, error in
                    print("success")
                }
            }
            
            
        }
        
    }
}

extension ViewController: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        
    }
    
    func chartViewDidEndPanning(_ chartView: ChartViewBase) {
        
    }
    
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        
    }
    
    func chartScaled(_ chartView: ChartViewBase, scaleX: CGFloat, scaleY: CGFloat) {
        
    }
    
    func chartTranslated(_ chartView: ChartViewBase, dX: CGFloat, dY: CGFloat) {
        
    }
    
    func chartView(_ chartView: ChartViewBase, animatorDidStop animator: Animator) {
        
    }
}
