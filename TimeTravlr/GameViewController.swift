//
//  GameViewController.swift
//  TimeTravlr
//
//  Created by Eugenia Feng on 9/19/20.
//  Copyright © 2020 Eugenia Feng. All rights reserved.
//

import UIKit

class GameViewController: UIViewController, UITextFieldDelegate {

/*
    let places: [UIImage: Int] = [UIImage(named: "1902 Hawaii")!: 1902, UIImage(named: "1914 Porterville California")!: 1914, UIImage(named: "1915 Yosemite")!: 1915, UIImage(named: "1929 New York")!: 1929, UIImage(named: "1947 Philadelphia")!: 1947, UIImage(named: "1950 Old Faithful")!: 1950, UIImage(named: "1966 London")!: 1966, UIImage(named: "1971 New York")!: 1971, UIImage(named: "2016 Mount Rainier")!: 2016, UIImage(named: "2018 Yosemite")!: 2018]
    var baseImages: [UIImage] = [UIImage(named: "1902 Hawaii")!, UIImage(named: "1914 Porterville California")!, UIImage(named: "1915 Yosemite")!, UIImage(named: "1929 New York")!, UIImage(named: "1947 Philadelphia")!, UIImage(named: "1950 Old Faithful")!, UIImage(named: "1966 London")!, UIImage(named: "1971 New York")!, UIImage(named: "2016 Mount Rainier")!, UIImage(named: "2018 Yosemite")!]
    
//    let URL_IMAGE = URL(string: "https://image.shutterstock.com/image-vector/sample-stamp-grunge-texture-vector-260nw-1389188336.jpg")
*/
    
    var score = 0
    var highScore = 0
    var roundsCount = 0
    
    var location: [String:String] = [:]
    var year: Int = -1
    var image2: UIImage?
    
    @IBOutlet weak var gameImage: UIImageView!
    @IBOutlet weak var firstYearLabel: UILabel!
    @IBOutlet weak var gameImage2: UIImageView!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var guessTextField: UITextField!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var correctAnswerLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    @IBAction func checkButtonTouchedUp(_ sender: UIButton) {
        guard let guess = Int(guessTextField.text ?? "0") else { return }
        var roundScore = 0
        
        if checkButton.titleLabel!.text == "Next" && roundsCount == 5 {
            performSegue(withIdentifier: "endGame", sender: nil)
        }
        else if checkButton.titleLabel!.text == "Check" {
            if (abs(guess-year) <= 100) {
                if (abs(guess-year) >= 50) {
                    roundScore = Int(0.5*Double(100-abs(guess-year)))
                } else if (abs(guess-year) >= 25) {
                    roundScore = 75 - abs(guess-year)
                } else {
                    roundScore = 2*(50 - abs(guess-year))
                }
            }
            self.score = self.score + roundScore
            roundScore = 0
            correctAnswerLabel.text = "Correct Answer: " + String(year)
            placeLabel.text = location["location"]!
            checkButton.setTitle("Next", for: .normal)
            guessTextField.isEnabled = false
            scoreLabel.text = "Score: " + String(score)
            roundsCount = roundsCount + 1
            gameImage.image = convertToGrayScale(image: gameImage.image!)
            gameImage2.image = convertToGrayScale(image: gameImage2.image!)
        }
        else {
            self.loadView()
            correctAnswerLabel.text = " "
            placeLabel.text = " "
            guessTextField.isEnabled = true
            checkButton.setTitle("Check", for: .normal)
            scoreLabel.text = "Score: " + String(score)
            location = Constants.IMAGES[roundsCount]
            
            let revealed = Int.random(in: 1..<3)
            let image1FileName = getImageFileName(location["location"]!, revealed == 1 ? location["year1"]! : location["year2"]!)
            gameImage.image = UIImage(named: image1FileName)!
            firstYearLabel.text = "Year: \(revealed == 1 ? location["year1"]! : location["year2"]!)"
            let image2FileName = getImageFileName(location["location"]!, revealed == 1 ? location["year2"]! : location["year1"]!)
            image2 = UIImage(named: image2FileName)!
            gameImage2.image = image2
            year = revealed == 1 ? Int(location["year2"]!)! : Int(location["year1"]!)!
            
            createTapGestureForRemovingKeyboard()
            setUpKeyboardObservers()
        }
        

        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        Constants.IMAGES.shuffle()
        createTapGestureForRemovingKeyboard()
        setUpKeyboardObservers()
        location = Constants.IMAGES[roundsCount]
        
        let revealed = Int.random(in: 1..<3)
        let image1FileName = getImageFileName(location["location"]!, revealed == 1 ? location["year1"]! : location["year2"]!)
        gameImage.image = UIImage(named: image1FileName)!
        firstYearLabel.text = "Year: \(revealed == 1 ? location["year1"]! : location["year2"]!)"
        let image2FileName = getImageFileName(location["location"]!, revealed == 1 ? location["year2"]! : location["year1"]!)
        image2 = UIImage(named: image2FileName)!
        gameImage2.image = image2
        year = revealed == 1 ? Int(location["year2"]!)! : Int(location["year1"]!)!
        
        correctAnswerLabel.text = " "
        placeLabel.text = " "
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
        let firstWord = location.components(separatedBy: " ")[0].lowercased().replacingOccurrences(of: ",", with: "")
        return firstWord + year
    }
    
    // Creates a tap gesture for removing any visible keyboard when the screen is tapped.
     private func createTapGestureForRemovingKeyboard() {
         let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
         view.addGestureRecognizer(tap)
     }
    
    /// Sets up observers for shifting screen when keyboard appears or disappears.
    private func setUpKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    /// Slides screen up when keyboard appears.
    @objc internal func keyboardWillShow(notification: NSNotification) {
        if self.view.frame.origin.y >= 0 {
            self.view.frame.origin.y -= 130
        }
    }

    /// Slides screen back down when keyboard disappears.
    @objc internal func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y < 0 {
            self.view.frame.origin.y += 130
        }
    }

    /// Removes keyboard from screen when "return" key is pressed.
    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
            vc.image = image2!
            vc.score = self.score
            vc.highScore = self.highScore
        }
    }
    
}

