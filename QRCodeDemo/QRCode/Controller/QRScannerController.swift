//
//  QRScannerController.swift
//  QRCodeDemo
//
//  Created by maiGit on 2017/4/18.
//  Copyright © 2017年 maiGit. All rights reserved.
//

import UIKit
import AVFoundation

class QRScannerController: UIViewController {
    @IBOutlet weak var tapBar: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var backView: QRCodeHollowView!
    
    @IBAction func backBtnEvent(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var grCodeFrameView: QRCodeView!
    
    /// 判断系统权限
    private let captureAuth   = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)

    /// 创建AVCaptureSession 负责输入和输出设备之间的数据传递,初始化会话操作
    private lazy var captureSession: AVCaptureSession = {
        let session = AVCaptureSession()
        /*
         设置会话操作的分辨率，一般在自定义相机，录像中会用到，并且要与输入，输出流的分辨率对应
        if (session.canSetSessionPreset(AVCaptureSessionPreset640x480)) {
            session.sessionPreset = AVCaptureSessionPreset640x480
        }*/
        return session
    }()
    
    ///设备输入流
    private lazy var captureDeviceInput: AVCaptureDeviceInput? = {
        let devices = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        do {
            let input = try AVCaptureDeviceInput(device:devices)
            return input
        } catch{
            return nil
        }
    }()
    
    /// 设备输出流
    private let captureMetadataOutput = AVCaptureMetadataOutput()
    
    fileprivate lazy var captureVideoPreviewLayer: AVCaptureVideoPreviewLayer = {
        let layer = AVCaptureVideoPreviewLayer.init(session: self.captureSession)
        layer?.frame = CGRect(x:0, y:0, width:self.view.frame.size.width, height:self.view.frame.size.height)
        layer?.videoGravity  = AVLayerVideoGravityResizeAspectFill//填充模式
        return layer!
    }()

    private func startScan(){
                //将设备输入添加到会话中
                if captureSession.canAddInput(captureDeviceInput) {
                    captureSession.addInput(captureDeviceInput)
//                    //根据设备输出获得连接
//                    let captureConnection = captureMetadataOutput?.connection(withMediaType: AVMediaTypeVideo)
//                    let device:AVCaptureDevice = self.getCameraDeviceWithPosition(AVCaptureDevicePosition.front)
//                    //是否支持光学防抖
//                    if device.activeFormat.isVideoStabilizationModeSupported(AVCaptureVideoStabilizationMode.cinematic) {
//                        captureConnection?.preferredVideoStabilizationMode = AVCaptureVideoStabilizationMode.cinematic
//                    }
                }
                //将设备输出添加到会话中
                if (captureSession.canAddOutput(captureMetadataOutput)) {
                    captureSession.addOutput(captureMetadataOutput)
                }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        captureSession.startRunning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        captureSession.stopRunning()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startScan()
        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        // 匹配扫描二维码
        captureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
        view.layer.addSublayer(self.captureVideoPreviewLayer)
        //显示在View的最上层
        view.bringSubview(toFront: messageLabel)
        view.bringSubview(toFront: tapBar)
        view.bringSubview(toFront: grCodeFrameView)
        view.bringSubview(toFront: backView)
    }
    
    /**
     * 在viewDidLoad之后会根据初始的frame再计算一次frame,过程中,你虽然更改了frame,但是auto layout之后又恢复了之前的frame,所以模拟器显示没有变化.
     * 但为什么打印值变了呢?很简单,因为auto layout是在viewDidLoad方法之后计算的,所以在viewDidLoad方法中打印出的值肯定改变了,可后面又被改变回原来的值.
     *
     * 方法一：在 viewDidLayoutSubviews 设置frame
     *
     * 方法二：取消掉 UseAutoLayout选项
     */
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // grCodeFrameView.frame.origin.y-64该处减去64是因为 backView相对于self.view 有一个自定义View的高度
        backView._hollowRect = CGRect(x:grCodeFrameView.frame.origin.x,
                                      y:grCodeFrameView.frame.origin.y-64,
                                      width:grCodeFrameView.frame.size.width,
                                      height:grCodeFrameView.frame.size.height)
    }
}

extension QRScannerController : AVCaptureMetadataOutputObjectsDelegate {
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        
        if metadataObjects == nil || metadataObjects.count == 0 {
            messageLabel.text = "No QR code is detected"
            return
        }
        
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        if metadataObj.type == AVMetadataObjectTypeQRCode {
            _ = captureVideoPreviewLayer.transformedMetadataObject(for: metadataObj)
            if metadataObj.stringValue != nil {
                messageLabel.text = metadataObj.stringValue
            }
        }
    }
    
}
