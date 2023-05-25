//
//  PlaySound.swift
//  GyroMaze
//
//  Created by Ferry Dwianta P on 24/05/23.
//

import AVFoundation

var audioPlayer: AVAudioPlayer?

func playSound(sound: String, type: String, loop: Int) {
    if let path = Bundle.main.path(forResource: sound, ofType: type) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(filePath: path))
            audioPlayer?.play()
            audioPlayer?.numberOfLoops = loop
        } catch {
            print("error")
        }
    }
}
