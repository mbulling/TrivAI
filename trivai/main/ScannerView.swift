//
//  ScannerView.swift
//  trivai
//
//  Created by Iram Liu on 3/17/23.
//  Copyright © 2023 Mithun. All rights reserved.
//
import SwiftUI
import VisionKit

struct ScannerView: UIViewControllerRepresentable {
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(completion: completionHandler)
    }
    
    class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate {
        let completionHandler: ([String]?) -> Void
        
        init(completion: @escaping ([String]?) -> Void){
            self.completionHandler = completion
        }
        
        func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
            completionHandler(nil)
        }
        
        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
            completionHandler(nil)
        }
        
        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
            let recognizer = TextCV(cameraScan: scan)
            recognizer.recognizeText(withCompletionHandler: completionHandler)
        }
    }
    
    func makeUIViewController(context: Context) -> VNDocumentCameraViewController {
        let scannerViewController = VNDocumentCameraViewController()
        scannerViewController.delegate = context.coordinator
        return scannerViewController
    }
    
    func updateUIViewController(_ uiViewController: VNDocumentCameraViewController, context: Context) { }
    
    let completionHandler: ([String]?) -> Void
    
    init(completion: @escaping ([String]?) -> Void) {
        self.completionHandler = completion
    }
    
    typealias UIViewControllerType = VNDocumentCameraViewController
}
