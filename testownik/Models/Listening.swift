//
//  Listening.swift
//  testownik
//
//  Created by Slawek Kurczewski on 05/10/2021.
//  Copyright © 2021 Slawomir Kurczewski. All rights reserved.
//

import Foundation
import UIKit
import Speech

protocol ListeningDelegate {
    func updateGUI(messae recordedMessage: String)
    func listenigStartStop(statusOn : Bool)
}
class Listening  {
    struct Memo {
        var memoTitle: String
        var memoDate: Date
        var memoText: String
    }
    
//    var linkView: UIView?
    var linkSpeaking: Speech?
    var delegate: ListeningDelegate?
    
    var recordingView: UIView?
    
    var recordIsEnabled = false
    var recordingViewHidden = false
    
    var memoData: [Memo] = [Memo]()
    var currentLanguage = 0
    let languaeList = ["pl","en_GB","de","fr_FR","es_ES"]
    var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    var recognitionTask: SFSpeechRecognitionTask?
    lazy var speechRecognizer: SFSpeechRecognizer? = nil
    var recordedMessage = "" {
        didSet {
            print("\(recordedMessage)")
            //  (self.linkView as? UITextView)?.text = recordedMessage
            delegate?.updateGUI(messae: recordedMessage)
        }
    }
    lazy var audioEngine: AVAudioEngine = {  let audioEngine = AVAudioEngine()
        return audioEngine
    }()
    var count: Int {
        get {   return memoData.count   }
    }
    func isIndexInRange(index: Int, isPrintToConsol: Bool = true) -> Bool {
            if index >= count {
                if isPrintToConsol {
                   print("Index \(index) is bigger then count \(count). Give correct index!")
                }
                return false
            }
            else {
                return true
            }
        }
    subscript(index: Int) -> Memo? {
        get {  if isIndexInRange(index: index) {  return memoData[index]  }
            else { return nil}
        }
        set {   if  isIndexInRange(index: index)  {     memoData[index] = newValue!  } }
    }
    func last() -> Memo {
        let lastVal = count-1
        _ = isIndexInRange(index: lastVal)
        return memoData[lastVal]
    }
    func preLast() -> Memo {
        let preLastVal = count-2
        _  = isIndexInRange(index: preLastVal)
        return memoData[preLastVal]
    }

    
    //    lazy var speechRecognizer: SFSpeechRecognizer? = {
    //        if let recognizer = SFSpeechRecognizer(locale: Locale(identifier: languaeList[currentLanguage])) {
    //            recognizer.delegate = self
    //            return recognizer
    //        }
    //        return nil
    //    }()
//    func setNeedsDisplay() {
//        if let delegateView = linkView {
//            delegateView.setNeedsDisplay()
//            //delegateView.layoutIfNeeded()
//            //delegate.setNeedsUpdateConstraints()
//        }
//    }
        func setupSpeechRecognizer() ->  SFSpeechRecognizer? {
            if let recognizer = SFSpeechRecognizer(locale: Locale(identifier: languaeList[currentLanguage])) {
                //recognizer.delegate = self
                return recognizer
            }
            else {
                return nil
            }
        }
        

//        override func viewDidLoad() {
//            super.viewDidLoad()
//            // request auth
//            self.requestAuth()
//            self.recordedMessage.delegate = self
//
//            // init data
//            memoData = []
//
//            // tableview delegations
//            self.tableView.delegate = self
//            self.tableView.dataSource = self
//
//            // hide recording views
//            self.recordingView.isHidden = true
//            self.fadedView.isHidden = true
//
//        }

        func requestAuth() {
            // SFSpeechRecognizerAuthorizationStatus
            SFSpeechRecognizer.requestAuthorization { (authStatus ) in
                DispatchQueue.main.async {
                    switch authStatus {
                    case .authorized:
                        self.recordIsEnabled = true
                        print("authorized")
                        //self.recordButton.isEnabled = true
                    case .denied, .notDetermined, .restricted:
                        self.recordIsEnabled = false
                        print("other")
                        //self.recordButton.isEnabled = false
                    @unknown default:
                        fatalError()
                    }
                }
            }
        }
        
        func didTapRecordButton() {
            self.linkSpeaking?.pauseSpeak()
            self.speechRecognizer = setupSpeechRecognizer()
            if audioEngine.isRunning {
                audioEngine.stop()
                recognitionRequest?.endAudio()

                delegate?.listenigStartStop(statusOn: false)
//                func updateGUI()
//                func listenigStartStop(statusOn: Bool)
//                self.deleateViewCtrl?.listenigStartStop()
//                self.listenigStartStop()
            }
            else {
                self.startRecording()
                self.recordingViewHidden = false
                delegate?.listenigStartStop(statusOn: true)
//                self.recordingView.isHidden = false
//                self.fadedView.alpha = 0.0
//                self.fadedView.isHidden = false
//                UIView.animate(withDuration: 1.0) {
//                    self.fadedView.alpha = 1.0
//                }
            }
        }
        func stopRecording() {
            if audioEngine.isRunning {
                audioEngine.stop()
                recognitionRequest?.endAudio()
                audioEngine.inputNode.removeTap(onBus: 0)
                let memoTmp = Memo(memoTitle: "Nowe nagranie", memoDate: Date(), memoText: self.recordedMessage)
                self.memoData.append(memoTmp)
                
//                UIView.animate(withDuration: 0.5, animations: {
//                    self.fadedView.alpha = 0.0
//                }) { (finished) in
//                    self.fadedView.isHidden = true
//                    self.recordingView.isHidden = true
//                    self.tableView.reloadData()
//                }
            }
            self.speechRecognizer = nil
        }
        
        func startRecording() {
//            Jak ustawiasz swoją AVAudioSession? Ten błąd jest zwykle spowodowany nieprawidłowym ustawieniem.
//
//            Oznacza to, że przed każdym użyciem mikrofonu musisz wywołać poniższy kod (lub podobny w zależności od przypadku użycia),
//            aby upewnić się, że sesja audio jest prawidłowo skonfigurowana. Jeśli tak nie jest, na przykład używasz kategorii .playback i
//            próbujesz użyć mikrofonu, otrzymasz awarię IsFormatSampleRateAndChannelCountValid(format).
 
            if let recognitionTask = self.recognitionTask {
                recognitionTask.cancel()
                self.recognitionTask = nil
            }
            self.recordedMessage = ""
            let audioSession = AVAudioSession.sharedInstance()
            do {
//                try audioSession.setCategory(AVAudioSession.Category.record)
//                try audioSession.setMode(AVAudioSession.Mode.measurement)
//                try audioSession.setActive(true, options: AVAudioSession.SetActiveOptions.notifyOthersOnDeactivation )
                try audioSession.setCategory(.playAndRecord, options: .defaultToSpeaker)
                try audioSession.setMode(.measurement)
                try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
                
            }catch let error as NSError {
                print("EEEEE, błą∂:\(error)")
            }
            
            recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
            
            guard let recognitionRequest = self.recognitionRequest else {
                fatalError("Niemożliwe utworzenie bufora dźwięku") //Unable to create a speech audio buffer
            }
            
            recognitionRequest.shouldReportPartialResults = true
            recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
                
                var isFinal = false
                if let result = result {
                    let sentence = result.bestTranscription.formattedString
                    self.recordedMessage = sentence
                    isFinal = result.isFinal
                }
                
                if error != nil || isFinal {
                    self.audioEngine.stop()
                    self.audioEngine.inputNode.removeTap(onBus: 0)
                    self.recognitionRequest = nil
                    self.recognitionTask = nil
                    self.recordIsEnabled = true
                    //self.recordButton.isEnabled = true
                }
                
            })
            
            let recordingFormat = audioEngine.inputNode.outputFormat(forBus: 0)
            audioEngine.inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
                self.recognitionRequest?.append(buffer)
            }
            
            audioEngine.prepare()
            do{
                try audioEngine.start()
            }catch {
                print(error)
            }
        }
}
