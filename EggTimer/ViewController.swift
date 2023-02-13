//
//  ViewController.swift
//  EggTimer
//
//  Created by Angela Yu on 08/07/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var timerBar: UIProgressView!
    @IBOutlet weak var topLabel: UILabel!
    
    var timer = Timer()
    var eggTime: Int?
    var artisHizi: Float?
    let eggTimes: [String: Int] = ["Soft" : 5, "Medium": 8, "Hard": 12]
    var player: AVAudioPlayer?
    
    //Program başlarken yapılacaklar
    override func viewDidLoad() {
        super.viewDidLoad()
        timerBar.progress=0.0
    }
    
    //Butona tıklandığında yapılacak işlemler
    @IBAction func hardnessSelected(_ sender: UIButton) {
        timer.invalidate()
        timerBar.progress=0.0
        
        topLabel.text = "How do you like your eggs?"
        let hardness = sender.currentTitle!
        eggTime = (eggTimes[hardness]!)
        artisHizi = 1 / Float(eggTime!)
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
    }
    
    // Sayacın azaltılması ve barın arttırılması
    @objc func updateCounter(time: Int) {
        //example functionality
        if eggTime! > 0 {
            print("\(eggTime!) seconds until the egg is cooked")
            eggTime! -= 1
            timerBar.progress += artisHizi!
        }else {
            timer.invalidate()
            topLabel.text = "Egg is cooked"
            playSound()
        }
    }
    
    //Ses işlemleri
    func playSound() {
        guard let url = Bundle.main.url(forResource: "alarm_sound", withExtension: "mp3") else { return }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

            /* iOS 10 and earlier require the following line:
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */

            guard let player = player else { return }

            player.play()

        } catch let error {
            print(error.localizedDescription)
        }
    }
    
}
