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
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
