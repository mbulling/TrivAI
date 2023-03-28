//
//  TextCV.swift
//  trivai
//
//  Created by Iram Liu on 3/19/23.
//  Copyright © 2023 Mithun. All rights reserved.
//
import Vision
import VisionKit

class TextCV{
    let cameraScan: VNDocumentCameraScan
    init(cameraScan:VNDocumentCameraScan){
        self.cameraScan = cameraScan
        
    }
    let queue = DispatchQueue(label: "scan-codes",qos: .default, attributes: [], autoreleaseFrequency: .workItem)
    func recognizeText(withCompletionHandler completionHandler:@escaping ([String])-> Void) {
            queue.async {
                let images = (0..<self.cameraScan.pageCount).compactMap({
                    self.cameraScan.imageOfPage(at: $0).cgImage
                })
                let imagesAndRequests = images.map({(image: $0, request:VNRecognizeTextRequest())})
                let textPerPage = imagesAndRequests.map{image,request->String in
                    let requestHandler = VNImageRequestHandler(cgImage: image, options: [:])
                    do{
                        try requestHandler.perform([request])
                        guard let observations = request.results as? [VNRecognizedTextObservation] else{return ""}
                        return observations.compactMap({$0.topCandidates(1).first?.string}).joined(separator: "\n")
                    }
                    catch{
                        print(error)
                        return ""
                    }
                }
                DispatchQueue.main.async {
                    completionHandler(textPerPage)
                }
            }
        }
}
