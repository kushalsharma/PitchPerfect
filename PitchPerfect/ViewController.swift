//
//  ViewController.swift
//  PitchPerfect
//
//  Created by Kushal Sharma on 24/01/17.
//  Copyright © 2017 Kushal. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    
    var audioRecorder: AVAudioRecorder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        stopButton.isEnabled = false
    }
    
    @IBAction func startButton(_ sender: UIButton) {
        configureUI(recording: true)
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with:AVAudioSessionCategoryOptions.defaultToSpeaker)
    
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func stopButton(_ sender: UIButton) {
        configureUI(recording: false)
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
            showAlertActivity(titleText: "Warning", messageText: "Somthing went wrong!", buttonText: "Okay")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "stopRecording"){
            let playSoundVC = segue.destination as! PlaySoundsViewController
            let recordAudioUrl = sender as! URL
            playSoundVC.recordedAudioURL = recordAudioUrl
        }
    }
    
    func configureUI(recording: Bool) {
        recordingLabel.text = recording ? "Recording in progress" : "Tap to Record"
        stopButton.isEnabled = recording
        recordButton.isEnabled = !recording
    }
    
    func showAlertActivity(titleText: String, messageText: String, buttonText: String) {
        let actionSheetController: UIAlertController = UIAlertController(title: titleText, message: messageText, preferredStyle: .alert)
        let cancelAction: UIAlertAction = UIAlertAction(title: buttonText, style: .cancel) { action -> Void in
            //Just dismiss the action sheet
        }
        actionSheetController.addAction(cancelAction)
        self.present(actionSheetController, animated: true, completion: nil)
    }
}

