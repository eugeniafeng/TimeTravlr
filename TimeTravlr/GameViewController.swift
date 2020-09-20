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
    
    var randomInt = 0
    var score = 0
    var highScore = 0
    var roundsCount = 0
    
    var location: [String: String] = [:]
    var image: UIImage?
    
    @IBOutlet weak var gameImage: UIImageView!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var guessTextField: UITextField!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var correctAnswerLabel: UILabel!
    @IBAction func checkButtonTouchedUp(_ sender: UIButton) {
        let year = Int(location["year1"]!)
        guard let guess = Int(guessTextField.text ?? "0") else { return }
        var roundScore = 0
        
        if checkButton.titleLabel!.text == "Next" && roundsCount == 5 {
            performSegue(withIdentifier: "endGame", sender: nil)
        }
        else if checkButton.titleLabel!.text == "Check" {
            if (abs(guess-year!) <= 100) {
                roundScore = 100 - abs(guess-year!)
            }
            self.score = self.score + roundScore
            roundScore = 0
            correctAnswerLabel.text = "Correct Answer: " + String(year!)
            checkButton.setTitle("Next", for: .normal)
            guessTextField.isEnabled = false
            scoreLabel.text = "Score: " + String(score)
            roundsCount = roundsCount + 1
            gameImage.image = convertToGrayScale(image: gameImage.image!)
        }
        else {
            self.loadView()
            correctAnswerLabel.text = " "
            guessTextField.isEnabled = true
            checkButton.setTitle("Check", for: .normal)
            randomInt = Int.random(in: 0..<10)
            scoreLabel.text = "Score: " + String(score)
            gameImage.image = baseImages[randomInt]

        }
        

        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        createTapGestureForRemovingKeyboard()
        location = Constants.IMAGES[Int.random(in: 0..<Constants.IMAGES.count)]
        let image1FileName = getImageFileName(location["location"]!, location["year1"]!)
        image = UIImage(named: image1FileName)!
        gameImage.image = image
        correctAnswerLabel.text = " "
        scoreLabel.text = "Score: " + String(score)

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
    
    private func getImageFileName(_ location: String, _ year: String) -> String {
        var firstWord = location.components(separatedBy: " ")[0].lowercased()
        firstWord = firstWord.replacingOccurrences(of: ",", with: "")
        return firstWord + year
    }
    
    // Creates a tap gesture for removing any visible keyboard when the screen is tapped.
     private func createTapGestureForRemovingKeyboard() {
         let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
         view.addGestureRecognizer(tap)
     }
    
    func convertToGrayScale(image: UIImage) -> UIImage {

        // Create image rectangle with current image width/height
        let imageRect:CGRect = CGRect(x:0, y:0, width:image.size.width, height: image.size.height)

        // Grayscale color space
        let colorSpace = CGColorSpaceCreateDeviceGray()
        let width = image.size.width
        let height = image.size.height

        // Create bitmap content with current image size and grayscale colorspace
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.none.rawValue)

        // Draw image into current context, with specified rectangle
        // using previously defined context (with grayscale colorspace)
        let context = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)
        context?.draw(image.cgImage!, in: imageRect)
        let imageRef = context!.makeImage()

        // Create a new UIImage object
        let newImage = UIImage(cgImage: imageRef!)

        return newImage
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
            vc.image = image!
            vc.year = Int(location["year1"]!)!
            vc.score = self.score
            vc.highScore = self.highScore
        }
    }
    
}

