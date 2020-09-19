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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

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

