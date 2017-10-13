//
//  MusicPlayer.swift
//  ECE564_F17_HOMEWORK
//
//  Created by The Ritler on 9/26/17.
//  Copyright © 2017 ece564. All rights reserved.
//

import Foundation

import AVFoundation

public class MusicPlayer {
    static let sharedHelper = MusicPlayer()
    var audioPlayer: AVAudioPlayer?
    var isMusicPlaying = false
    
    func playBackgroundMusic(songName : String) {
        let aSound = NSURL(fileURLWithPath: Bundle.main.path(forResource: songName, ofType: "mp3")!)
        do{
        audioPlayer = try AVAudioPlayer(contentsOf:aSound as URL)
            
            if(isMusicPlaying){
                audioPlayer!.stop()
                isMusicPlaying = false
            }else{
            audioPlayer!.numberOfLoops = 0
            audioPlayer!.prepareToPlay()
            audioPlayer!.play()
            isMusicPlaying = true
            }
            
        } catch{
            print("music not found")
        }
        
        
    }
}
