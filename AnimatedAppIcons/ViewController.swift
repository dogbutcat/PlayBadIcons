//
//  ViewController.swift
//  AnimatedAppIcons
//
//  Created by Bryce Bostwick on 5/25/24.
//

import UIKit

class ViewController: UIViewController {

    // An `IconAnimator` that runs at 30fps on the main thread
    let iconAnimator = IconAnimator(
        numberOfFrames: 876,
        numberOfLoops: 1,
        targetFramesPerSecond: 30,
        shouldRunOnMainThread: true
    )

    // A button to start the animation
    lazy var startButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(buttonTapped), for: .primaryActionTriggered)
        button.setTitle("点击后返回桌面1秒后开始播放", for: .normal)
        button.setTitleColor(.link, for: .normal)
        button.setTitleColor(.white, for: .highlighted)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var cancelButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(buttonCancelTapped), for: .primaryActionTriggered)
        button.setTitle("停止播放后重置", for: .normal)
        button.setTitleColor(.link, for: .normal)
        button.setTitleColor(.white, for: .highlighted)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // A background task to keep our app alive while we're animating
    var backgroundTask: UIBackgroundTaskIdentifier? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(startButton)
        view.addSubview(cancelButton)
        NSLayoutConstraint.activate([
            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            cancelButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cancelButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 50),
        ])
    }

    @objc
    private func buttonCancelTapped() {
        DispatchQueue.main.async {
            self.stopAnimation()
        }
    }
    
    @objc
    private func buttonTapped() {
//        backgroundTask = UIApplication.shared.beginBackgroundTask()
        // backgroundTask can't handle long time event
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now () + .seconds(1)) {
            AudioManager.shared.startBackgroundAudio()
            self.startAnimation()
        }
    }

    private func startAnimation() {
        // Start the animation
        iconAnimator.startAnimation() { [weak self] frameTimeGapArr in
            // Once the animation is complete,
            // end our background task so that iOS knows
            // that our app has finished its work
//            if let backgroundTask = self?.backgroundTask {
//                UIApplication.shared.endBackgroundTask(backgroundTask)
//            }
            self?.backgroundTask = nil
            let avg = frameTimeGapArr.reduce(0.0, +) / CGFloat(frameTimeGapArr.count)
            print(avg)
            DispatchQueue.global(qos: .background).async {
                AudioManager.shared.stopBackgroundAudio()
            }
        }
    }
    
    private func stopAnimation(){
        iconAnimator.cancel()
    }

}

