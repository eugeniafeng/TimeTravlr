//
//  GameViewController.swift
//  TimeTravlr
//
//  Created by Eugenia Feng on 9/19/20.
//  Copyright © 2020 Eugenia Feng. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    let URL_IMAGE = URL(string: "https://earthengine.googleapis.com/v1alpha/projects/earthengine-legacy/thumbnails/0d5fb7a94b62bfc7848ec19ce2cc90b7-27172365d41070e0324d994e0bbb278c:getPixels")
    
    @IBOutlet weak var gameImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // gameImage.image =
        createTapGestureForRemovingKeyboard()
        let session = URLSession(configuration: .default)
        
        let getImageFromUrl = session.dataTask(with: URL_IMAGE!) { (data, response, error) in
            if let e = error{
                print("Some error occurred: \(e)")
            } else {
                
                if(response as? HTTPURLResponse) != nil{
                    
                    if let imageData = data{
                        let image = UIImage(data: imageData)
                        
                        self.gameImage.image = image
                    } else {
                        print("no image  found")
                    }
                    
                } else{
                    print("No response from server")
                }
            }
        }
        getImageFromUrl.resume()
    }
    
    
    // Creates a tap gesture for removing any visible keyboard when the screen is tapped.
     private func createTapGestureForRemovingKeyboard() {
         let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
         view.addGestureRecognizer(tap)
     }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    // Removes keyboard from screen when "return" key is pressed.
    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

