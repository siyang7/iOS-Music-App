//
//  ViewController.swift
//  MusicApp
//
//  Created by Si-Yang Wu on 2018-04-13.
//  Copyright © 2018 Si-Yang Wu. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVSpeechSynthesizerDelegate {
    
    @IBOutlet var song1: UILabel!
    @IBOutlet var song2: UILabel!
    @IBOutlet var song3: UILabel!
    @IBOutlet var song4: UILabel!
    @IBOutlet var song5: UILabel!
    @IBOutlet weak var songLabel: UILabel!
    @IBOutlet weak var timePlayed: UILabel!
    @IBOutlet weak var timeLeft: UILabel!
    @IBOutlet weak var speedBtn: UIButton!
    
    var songPlayer = AVAudioPlayer()
    var songNumber = 1
    var songNames:[String] = ["Index 0", "ABBA - Take A Chance On Me", "Rick Astley - Never Gonna Give You Up", "Johnathan Coulton - Re Your Brains", "Tom Lehrer - New Math", "The Ramones - I Wanna Be Sedated"]
    var isPlaying = false
    var songSpeed = 1
    var playbackRate = Float(1.0)
    var timer = Timer()
    var myUtterance = AVSpeechUtterance(string: "")
    var synth: AVSpeechSynthesizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        synth = AVSpeechSynthesizer()
        synth.delegate = self
        
        self.song1.text = "ABBA - Take A Chance On Me"
        self.song2.text = "Rick Astley - Never Gonna Give You Up"
        self.song3.text = "Johnathan Coulton - Re Your Brains"
        self.song4.text = "Tom Lehrer - New Math"
        self.song5.text = "The Ramones - I Wanna Be Sedated"
        
        let tapSong1 = UITapGestureRecognizer(target: self, action: #selector(ViewController.tapFunction1))
        song1.isUserInteractionEnabled = true
        song1.addGestureRecognizer(tapSong1)
        
        let tapSong2 = UITapGestureRecognizer(target: self, action: #selector(ViewController.tapFunction2))
        song2.isUserInteractionEnabled = true
        song2.addGestureRecognizer(tapSong2)
        
        let tapSong3 = UITapGestureRecognizer(target: self, action: #selector(ViewController.tapFunction3))
        song3.isUserInteractionEnabled = true
        song3.addGestureRecognizer(tapSong3)
        
        let tapSong4 = UITapGestureRecognizer(target: self, action: #selector(ViewController.tapFunction4))
        song4.isUserInteractionEnabled = true
        song4.addGestureRecognizer(tapSong4)
        
        let tapSong5 = UITapGestureRecognizer(target: self, action: #selector(ViewController.tapFunction5))
        song5.isUserInteractionEnabled = true
        song5.addGestureRecognizer(tapSong5)
    }
    
    // play first song
    @objc func tapFunction1(sender: UITapGestureRecognizer) {
        print("take song tapped")
        songNumber = 1
        songLabel.text = songNames[songNumber]
        speakAndPlay(songName: songNames[songNumber])
    }
    
    // play 2nd song
    @objc func tapFunction2(sender: UITapGestureRecognizer) {
        print("rick song tapped")
        songNumber = 2
        songLabel.text = songNames[songNumber]
        speakAndPlay(songName: songNames[songNumber])
    }
    
    // play 3rd song
    @objc func tapFunction3(sender: UITapGestureRecognizer) {
        print("brains song tapped")
        songNumber = 3
        songLabel.text = songNames[songNumber]
        speakAndPlay(songName: songNames[songNumber])
    }
    
    // play 4th song
    @objc func tapFunction4(sender: UITapGestureRecognizer) {
        print("new math tapped")
        songNumber = 4
        songLabel.text = songNames[songNumber]
        speakAndPlay(songName: songNames[songNumber])
    }
    
    // play 5th song
    @objc func tapFunction5(sender: UITapGestureRecognizer) {
        print("sedated tapped")
        songNumber = 5
        songLabel.text = songNames[songNumber]
        speakAndPlay(songName: songNames[songNumber])
    }
    
    // play the song
    func play() {
        var songName = ""
        
        switch songNumber {
            case 1:
                songName = "Take A Chance On Me"
                break
            case 2:
                songName = "Rick Astley - Never Gonna Give You Up"
                break
            case 3:
                songName = "Re Your Brains"
                break
            case 4:
                songName = "New Math"
                break
            case 5:
                songName = "I Wanna Be Sedated"
                break
            default:
                print("default")
        }
        
        do {
            songPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: songName, ofType: "mp3")!))
            songPlayer.enableRate = true
            songPlayer.rate = Float(playbackRate)
            songPlayer.prepareToPlay()
            let audioSession = AVAudioSession.sharedInstance()
            do {
                try audioSession.setCategory(AVAudioSessionCategoryPlayback)
            } catch {
                print(error)
            }
        } catch  {
            print(error)
        }

        isPlaying = true
        songPlayer.play()
        
        // get the time of the song
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateSongTimer), userInfo: nil, repeats: true)
    }
    
    // get the time played and time left of the current song
    @objc func updateSongTimer() {
        timePlayed.text = "\(Int(songPlayer.currentTime))"
        timeLeft.text = "\(Int(songPlayer.currentTime.distance(to: songPlayer.duration)))"
    }
    
    // play next song button
    @IBAction func nextBtn(_ sender: Any) {
        print("next btn pressed")
        
        songNumber = songNumber == 5 ? 1 : songNumber + 1
        songLabel.text = songNames[songNumber]
        speakAndPlay(songName: songNames[songNumber])
        
    }
    
    // toggle the speed of song
    @IBAction func changeSpeed(_ sender: UIButton) {
        songSpeed = songSpeed == 2 ? 0 : songSpeed + 1
        
        switch songSpeed {
            case 0:
                speedBtn.setTitle("0.5X", for: .normal)
                playbackRate = Float(0.5)
                break
            case 1:
                speedBtn.setTitle("1.0X", for: .normal)
                playbackRate = Float(1.0)
                break
            case 2:
                speedBtn.setTitle("2.0X", for: .normal)
                playbackRate = Float(2.0)
                break
            default:
                print("default")
        }
        
        if (isPlaying) {
            songPlayer.rate = playbackRate
        }
    }
    
    // say the name and play
    func speakAndPlay(songName: String) {
        if (isPlaying) {
            songPlayer.pause()
        }
        myUtterance = AVSpeechUtterance(string: songName)
        myUtterance.rate = 0.5
        synth.speak(myUtterance)
    }
    
    // start song after name is said
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        play()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

