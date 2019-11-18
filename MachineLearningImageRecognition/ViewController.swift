//
//  ViewController.swift
//  MachineLearningImageRecognition
//
//  Created by apple on 18.11.2019.
//  Copyright © 2019 Mustafa KILINÇ. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var resultLabel: UILabel!
    var choosenImage = CIImage()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
    }

    @IBAction func changeClicked(_ sender: Any) {
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
        
        if let ciImage = CIImage(image: imageView.image!)
        {
            choosenImage = ciImage
        }
        
        
        recognizeImage(image: choosenImage)
        
        
    }

    //Kullanıcı resmi seçer seçmez çağrılacak.
    //Avantajı kullanıcı resmi seçtiği gibi sonu. birkaç saniye içerisinde gösterilecek.
    //Dezavantajı CIImage adında bir görsel yapısı bekleyecek. CIImage, UIImage gibi core image tarafından kullanılabilecek bir görseldir.
    func recognizeImage(image: CIImage)
    {
        //1-)Request
        //2-) Handler
        
        resultLabel.text = "Finding ..."
        
        if let model = try? VNCoreMLModel(for: MobileNetV2().model)
        {
            let request = VNCoreMLRequest(model: model) { (vnrequest, error) in
                
                if let results = vnrequest.results as? [VNClassificationObservation]
                {
                    if results.count > 0
                    {
                        let topResult = results.first
                        
                        DispatchQueue.main.async {
                            let confidenceLevel = (topResult?.confidence ?? 0) * 100
                            let raunded = Int(confidenceLevel * 100) / 100
                            self.resultLabel.text = "\(raunded)% it's \(topResult!.identifier)"
                            
                        }
                    }
                }
                
               
            }
            let handler = VNImageRequestHandler(ciImage: image)
                           DispatchQueue.global(qos: .userInteractive).async {
                            
                            do{
                                try handler.perform([request])
                           }catch
                           {
                            print("error")
                            }
        }
        
    }
    
    
}

}
