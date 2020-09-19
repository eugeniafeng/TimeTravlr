//
//  GameViewController.swift
//  TimeTravlr
//
//  Created by Eugenia Feng on 9/19/20.
//  Copyright © 2020 Eugenia Feng. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    @IBOutlet weak var gameImage: UIImageView!
    
    func setImage(from url: String) {
        guard let imageURL = URL(string: url) else { return }

            // just not to cause a deadlock in UI!
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: imageURL) else { return }

            let image = UIImage(data: imageData)
            DispatchQueue.main.async {
                self.gameImage.image = image
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setImage (from: "https://earthengine.googleapis.com/v1alpha/projects/earthengine-legacy/thumbnails/0d5fb7a94b62bfc7848ec19ce2cc90b7-27172365d41070e0324d994e0bbb278c:getPixels")
        // Do any additional setup after loading the view.
        // gameImage.image =
        createTapGestureForRemovingKeyboard()
        
        let imageUrlString = "http://swiftdeveloperblog.com/wp-content/uploads/2015/07/1.jpeg"
        guard let imageUrl:URL = URL(string: imageUrlString) else {
            return
        }
             
        // Start background thread so that image loading does not make app unresponsive
        DispatchQueue.global().async { [weak self] in
                 
            guard let self = self else { return }
                 
            guard let imageData = try? Data(contentsOf: imageUrl) else {
                return
            }
                 
            // When from a background thread, UI needs to be updated on main_queue
            DispatchQueue.main.async {
                let image = UIImage(data: imageData)
                self.gameImage.image = image
                self.gameImage.contentMode = UIView.ContentMode.scaleAspectFit
                self.view.addSubview(self.gameImage)
            }
        }
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

