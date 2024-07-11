//
//  AudioManager.swift
//  AnimatedAppIcons
//
//  Created by oliver on 6/18/24.
//

import AVFoundation

class AudioManager {
    static let shared = AudioManager()
    private var audioPlayer: AVAudioPlayer?
    
    private init() {}
    
    func setupAudioSession() {
        do {
            
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: .mixWithOthers)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("设置音频会话失败: \(error)")
        }
    }
    
    func startBackgroundAudio() {
        guard let url = Bundle.main.url(forResource: "badapple", withExtension: "aac") else {
            print("无法找到音频文件")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.numberOfLoops = -1 // 无限循环
            audioPlayer?.volume = 0.1 // 设置很低的音量
            audioPlayer?.play()
        } catch {
            print("播放音频失败: \(error)")
        }
    }
    
    func stopBackgroundAudio() {
        audioPlayer?.stop()
    }
}
