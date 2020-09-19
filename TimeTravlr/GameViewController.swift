//
//  GameViewController.swift
//  TimeTravlr
//
//  Created by Eugenia Feng on 9/19/20.
//  Copyright © 2020 Eugenia Feng. All rights reserved.
//

import UIKit

class GameViewController: UIViewController, UITextFieldDelegate {
    
    let places: [UIImage: Int] = [UIImage(named: "1902 Hawaii")!: 1902, UIImage(named: "1914 Porterville California")!: 1914, UIImage(named: "1915 Yosemite")!: 1915, UIImage(named: "1929 New York")!: 1929, UIImage(named: "1947 Philadelphia")!: 1947, UIImage(named: "1950 Old Faithful")!: 1950, UIImage(named: "1966 London")!: 1966, UIImage(named: "1971 New York")!: 1971, UIImage(named: "2016 Mount Rainier")!: 2016, UIImage(named: "2018 Yosemite")!: 2018]
    let baseImages: [UIImage] = [UIImage(named: "1902 Hawaii")!, UIImage(named: "1914 Porterville California")!, UIImage(named: "1915 Yosemite")!, UIImage(named: "1929 New York")!, UIImage(named: "1947 Philadelphia")!, UIImage(named: "1950 Old Faithful")!, UIImage(named: "1966 London")!, UIImage(named: "1971 New York")!, UIImage(named: "2016 Mount Rainier")!, UIImage(named: "2018 Yosemite")!]
    
    let URL_IMAGE = URL(string: "https://image.shutterstock.com/image-vector/sample-stamp-grunge-texture-vector-260nw-1389188336.jpg")
    
    let randomInt = Int.random(in: 0..<10)
    var score = 0
    
    @IBOutlet weak var gameImage: UIImageView!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var guessTextField: UITextField!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBAction func checkButtonTouchedUp(_ sender: UIButton) {
        let year = places[baseImages[randomInt]]
        guard let guess = Int(guessTextField.text ?? "0") else { return }
        var roundScore = 0
        
        if (abs(guess-year!) <= 10) {
            roundScore = 10 - abs(guess-year!)
        }
        
        self.score = self.score + roundScore
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        createTapGestureForRemovingKeyboard()
        gameImage.image = baseImages[randomInt]

//        let session = URLSession(configuration: .default)
//
//        let getImageFromUrl = session.dataTask(with: URL_IMAGE!) { (data, response, error) in
//            if let e = error{
//                print("Some error occurred: \(e)")
//            } else {
//
//                if(response as? HTTPURLResponse) != nil{
//
//                    if let imageData = data{
//                        let image = UIImage(data: imageData)
//                        DispatchQueue.main.async {
//                            self.gameImage.image = image
//                        }
//                    } else {
//                        print("no image  found")
//                    }
//
//                } else{
//                    print("No response from server")
//                }
//            }
//        }
//        getImageFromUrl.resume()
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
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? EndGameViewController {
            vc.image = baseImages[randomInt]
            vc.year = places[baseImages[randomInt]]
            vc.score = self.score
        }
    }
    
    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

