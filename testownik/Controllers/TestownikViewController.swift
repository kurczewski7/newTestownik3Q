//
//  ViewController.swift
//  Testownik
//
//  Created by Slawek Kurczewski on 14/02/2020.
//  Copyright © 2020 Slawomir Kurczewski. All rights reserved.
//

import UIKit

protocol TestownikViewContDataSource {
    var listening: Listening { get }
    var command: Command { get }
    var gestures: Gestures { get }
}
class TestownikViewController: UIViewController, GesturesDelegate, TestownikDelegate, ListeningDelegate, TestownikViewContDataSource, CommandDelegate, ManagerDelegate  {
    //  TestToDoDelegate
    // MARK: other classes
    let listening = Listening()
    let command   = Command()
    var gestures  = Gestures()
    //var testownik = Testownik()

    //  MARK: variable
    var cornerRadius: CGFloat = 10
    let initalStackSpacing: CGFloat = 30.0
    struct ButtonParam {
        var Tag = 999
        var Color = UIColor.black
        var BackgroundColor = UIColor.yellow
    }
    var lastButton = ButtonParam()
    var tabHigh: [NSLayoutConstraint] = [NSLayoutConstraint]()
    var loremIpsum = """
Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum
"""
  
    let alphaLabel: CGFloat =  0.9
    var isLightStyle = true
    let selectedColor: UIColor   = #colorLiteral(red: 0.9999151826, green: 0.9882825017, blue: 0.4744609594, alpha: 1)
    let unSelectedColor: UIColor = #colorLiteral(red: 0.8469454646, green: 0.9804453254, blue: 0.9018514752, alpha: 1)
    let okBorderedColor: UIColor = #colorLiteral(red: 0.2034551501, green: 0.7804297805, blue: 0.34896487, alpha: 1)
    let borderColor: UIColor     = #colorLiteral(red: 0.7254344821, green: 0.6902328134, blue: 0.5528755784, alpha: 1)
    let otherColor: UIColor      = #colorLiteral(red: 0.8469454646, green: 0.9804453254, blue: 0.9018514752, alpha: 1)
    var pictureSwitchOn: Bool = false {
        didSet {
            if self.pictureSwitchOn == true {
                askLabel.isHidden = true
                askPicture.isHidden = false
            }
            else {
                askLabel.isHidden = false
                askPicture.isHidden = true
            }
        }
    }
    var test: Test? {
        get {
            return testownik.manager?.currentTest
            //return testownik.test
        }
        set {
            testownik.manager?.currentTest = newValue
            //testownik.test = newValue
        }
    }
    
    //  MARK: IBOutlets
    @IBOutlet weak var askLabel: UILabel!
    @IBOutlet weak var askPicture: UIImageView!
    
    @IBOutlet weak var listeningText: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var actionsButtonStackView: UIStackView!
    @IBOutlet weak var labelLeading: NSLayoutConstraint!
    @IBOutlet weak var microphoneButt: UIBarButtonItem!
    
    @IBOutlet weak var highButton1: NSLayoutConstraint!
    @IBOutlet weak var highButton2: NSLayoutConstraint!
    @IBOutlet weak var highButton3: NSLayoutConstraint!
    @IBOutlet weak var highButton4: NSLayoutConstraint!
    @IBOutlet weak var highButton5: NSLayoutConstraint!
    @IBOutlet weak var highButton6: NSLayoutConstraint!
    @IBOutlet weak var highButton7: NSLayoutConstraint!
    @IBOutlet weak var highButton8: NSLayoutConstraint!
    @IBOutlet weak var highButton9: NSLayoutConstraint!
    @IBOutlet weak var highButton10: NSLayoutConstraint!
    
    @IBAction func microphonePress(_ sender: UIBarButtonItem) {
        microphoneButt.image = (microphoneButt.image == UIImage(systemName: "mic") ? UIImage(systemName: "mic.fill") : UIImage(systemName: "mic"))
    }
    @IBAction func nevButtonSpaceSubPress(_ sender: UIBarButtonItem) {
        stackView.spacing -= 5
    }
    @IBAction func ResizeButtonPlusPress(_ sender: UIBarButtonItem) {
        for buttHight in tabHigh {  buttHight.constant += 2        }
    }
    @IBAction func ResizeButtonMinusPress(_ sender: UIBarButtonItem) {
         askLabel.layer.cornerRadius = 10
        for buttHight in tabHigh {       buttHight.constant -= 2        }
    }
    @IBAction func firstButtonPress(_ sender: UIButton) {
        saveAnswerSelection()
        testownik.first()
    }
    @IBAction func nextButtonPress(_ sender: UIButton) {
        saveAnswerSelection()
        if testownik.filePosition != .last {      testownik.next()        }
    }
    @IBAction func previousButtonPress(_ sender: UIButton) {
        saveAnswerSelection()
        if testownik.filePosition != .first  {       testownik.previous()  }
    }
    @IBAction func checkButtonPress(_ sender: UIButton) {
        guard let currTest = testownik[testownik.currentTestNumber] else {    return        }
        let countTest = currTest.answerOptions.count        //okAnswers.count
        for i in 0..<countTest {
            if let button = stackView.arrangedSubviews[i] as? UIButton {
                button.layer.borderWidth =  currTest.answerOptions[i].isOK ? 3 : 1
                button.layer.borderColor = currTest.answerOptions[i].isOK ? UIColor.systemGreen.cgColor : UIColor.brown.cgColor
            }
        }
    }
    
    // MARK: viewDidLoad - initial method
    override func viewDidLoad() {
        super.viewDidLoad()
        testownik.delegate = self
        testownik.manager?.delegate = self
                
        testownik.first()
        //testownik.manager?.first()
        
        print("TestownikViewController viewDidLoad-testownik.count:\(testownik.count)")
        Settings.shared.saveTestPreferences()
        
        self.view?.tag = 111
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        gesture.numberOfTouchesRequired = 1
        askLabel.isUserInteractionEnabled = true
        askLabel.addGestureRecognizer(gesture)
        Settings.shared.checkResetRequest(forUIViewController: self)
        //listening.linkSpeaking = speech.self
        listening.delegate     = self
        command.delegate       = self
        //testownik.viewContext  = self
        //testownik.delegate     = self
        gestures.delegate      = self
        gestures.setView(forView: view)
        
        listeningText.text = loremIpsum
        listeningText.userAnimation(12.8, type: .push, subType: .fromLeft, timing: .defaultTiming)
        //listeningText.alpha = alphaLabel
        listening.requestAuth()
        print("Test name 2:\(database.selectedTestTable[0]?.toAllRelationship?.user_name ?? "brak")")
        
        var i = 0
        self.title = "Test (001)"
        // MARKT: MAYBY ERROR
        //testownik.loadTestFromDatabase()
        print("Stack count: \(actionsButtonStackView.arrangedSubviews.count)")
        stackView.arrangedSubviews.forEach { (button) in
            if let butt = button as? UIButton {
                butt.backgroundColor = #colorLiteral(red: 0.8469454646, green: 0.9804453254, blue: 0.9018514752, alpha: 1)
                butt.layer.cornerRadius = self.cornerRadius
                butt.layer.borderWidth = 1
                butt.layer.borderColor = UIColor.brown.cgColor
                //butt.addTarget(self, action: #selector(buttonAnswerPress), for: .touchUpInside) //touchUpInside
                gestures.addTapGestureToView(forView: butt)
                gestures.addForcePressGesture(forView: butt)
                gestures.addLongPressGesture(forView: butt)
                 butt.tag = i
                i += 1
            }
        }
        tabHigh.append(highButton1)
        tabHigh.append(highButton2)
        tabHigh.append(highButton3)
        tabHigh.append(highButton4)
        tabHigh.append(highButton5)
        tabHigh.append(highButton6)
        tabHigh.append(highButton7)
        tabHigh.append(highButton8)
        tabHigh.append(highButton9)
        tabHigh.append(highButton10)
        
        addAllRequiredGestures(sender: gestures)
        askLabel.layer.cornerRadius = self.cornerRadius
        
        // TODO: POPRAW
        //testownik.createStartedTest()
        if testownik.manager == nil {
            print("testownik.manager == nil")
        }
        //testownik.first()
        //testownik.manager?.testList.append(Test(code: "AAA", ask: "BBB", pict: nil, fileName: "COS TAM"))
        //testownik.manager?.delegate = self
        testownik.refreshData()
    }
    // MARK: viewWillAppear - initial method
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear viewWillAppear")
        Settings.shared.readCurrentLanguae()
        
        print("Test name 3:\(database.selectedTestTable[0]?.toAllRelationship?.user_name ?? "brak")")
//       if database.testToUpgrade {
//            testownik.loadTestFromDatabase()
//       }
        if testownik.isChanged {
            //testownik.refreshData()
            clearView()
        }
        // FIXME: fix testownik.first()
        //testownik.first()
        refreshView()
        self.view.setNeedsUpdateConstraints()
        super.viewWillAppear(animated)
        Timer.scheduledTimer(timeInterval: 30.0, target: self, selector: #selector(startMe), userInfo: nil, repeats: false)
    }

    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        print("OBRÓT from\(fromInterfaceOrientation.rawValue)")
        checkOrientation()
    }
    override func didReceiveMemoryWarning() {
        print("MEMORY WWWWAAAAARRRRRNNNNIIINNNGG")
    }
    func saveAnswerSelection() {
        let isOk = testownik.isAllAnswersOk()
        print("Twoj wybór: \(isOk)")
        
        guard let currTest = testownik[testownik.currentTestNumber] else {    return        }
        let countTest = currTest.answerOptions.count        //okAnswers.count
    }
    func checkOrientation() {
        switch UIDevice.current.orientation {
            case .portrait, .portraitUpsideDown  :
                print("Portret")
                testownik.visableLevel = 4
            case .landscapeLeft, .landscapeRight :
                print("Krajobraz")
                testownik.visableLevel = 0
        default : print("Inna orientacja")
            
        }
    }
    func addCustomGesture(_ gestureType: Gestures.GesteresList, forView aView: UIView?, _ touchNumber: Int) {
    }
    //    func addAllRequiredGestures(sender: Gestures) {
    //
    //    }

    func dddddd() {
        let frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let label = UILabel(frame: frame)
        let button = UIButton(frame: frame)
        button.contentHorizontalAlignment = .center
        let image = UIImage(named: "001.png")
        let uiImageView = UIImageView()
        uiImageView.image = image
        uiImageView.alignmentRect(forFrame: frame)
        
        button.setImage(image, for: .normal)
        button.setBackgroundImage(image, for: .normal)
        button.contentHorizontalAlignment = .center
        button.backgroundImage(for: .normal)
    }
    // MARK: TestToDoDelegate
    func allTestDone() {
        print("allTestDone")
    }
    func progress(forCurrentPosition currentPosition: Int, totalPercent percent: Int) {
        //guard count > 0 else { return }
        //let promil = Int((currentPosition * 1000)/count) ?? 0
        print("progress: currentPosition:\(currentPosition),percent:\(percent)")
        let title = tabBarItem.title
        print("title:\(title)")
        if let items = tabBarController?.tabBar.items, items.count > 3 {
            items[0].badgeValue = "\(currentPosition + 1)"
            items[3].badgeValue = "\(percent) %"
        }
    }
//    func refreshFilePosition(newFilePosition filePosition: TestToDo.FilePosition) {
//        print("refreshFilePosition: \(filePosition)")
//    }

    // MARK: addAllRequiredestures
    func addAllRequiredGestures(sender: Gestures) {
        guard  gestures.view != nil  else { return   }
        sender.addSwipeGestureToView(direction: .right)
        sender.addSwipeGestureToView(direction: .left)
        sender.addSwipeGestureToView(direction: .up)
        sender.addSwipeGestureToView(direction: .down)
        sender.addPinchGestureToView()
        sender.addScreenEdgeGesture()
        sender.addTapGestureToView()
        //gestures.addLongPressGesture()
        //gestures.addForcePressGesture()
    }
    //Timer.scheduledTimer(timeInterval: 30.0, target: self, selector: #selector(startMe), userInfo: nil, repeats: false)
    // MARK: GesturesDelegate  protocol metods
    func tapRefreshUI(sender: UITapGestureRecognizer) {
        if Setup.animationEnded {
            gestures.disabledOtherGestures = false
        }
        if let nr = sender.view?.tag {
            if nr == 2021 {
                sender.view?.window?.rootViewController?.dismiss(animated: true, completion: {
                    Setup.animationEnded = true
                    self.gestures.disabledOtherGestures = false
                    sender.view?.removeFromSuperview()
                    print("TO JUZ JEST  KONIEC")
                    //print("NR 0:\(self.lastButton.Tag)")
                    if  (0...9).contains(self.lastButton.Tag) {
                        if let oldButton = self.stackView.arrangedSubviews[self.lastButton.Tag] as? UIButton {
                            Setup.popUpStrong.frame = sender.view?.frame
                            UIView.animate(withDuration: 2.0, delay: 0.2, options: []) {
                                oldButton.tintColor = self.lastButton.Color
                                oldButton.backgroundColor = self.lastButton.BackgroundColor
                            }
                        }
                        print("NR 1:\(self.lastButton.Tag)")
                    }
                    //                            UIView.animate(withDuration: 2.5, delay: 0.3, options: []) {
                    //                                oldButton.tintColor = self.lastButton.Color
                    //                            }, completion: nil)
                    //Setup.setTextColor(forToastType: .toast, backgroundColor: UIColor.brown)
                })
           }
            if (0...9).contains(nr) {
                if let aTest = test, let button = sender.view as? UIButton {
                    testownik.switchYourAnsfer(selectedOptionForTest: nr)
                    markSelected(forButton: button, optionNr: nr)
                }
            }
            //(forCurrentTest test: Test, forButton: button, optionNr: nr)
            //let mark =  testownik[0]?.answerOptions[nr].lastYourCheck ?? false //button.layer.borderWidth == 1
            // let txtLabel = button.titleLabel?.text
//                    self.lastButton.Tag = nr
//                    self.lastButton.Color = button.tintColor
            //let currTest = testownik[testownik.currentTest]
            //button.tintColor = UIColor.purple
            //currTest.answerOptions[nr].isOK ? 3 : 1
            //currTest.answerOptions[nr].isOK ? UIColor.systemGreen.cgColor : UIColor.brown.cgColor
            //let xxx = testownik.isAnswersOk(selectedOptionForTest: nr)

            print("tapRefreshUI NOWY zz:\(sender.view?.tag ?? 0)")
        }
    }
    func markSelected(forButton button: UIButton, optionNr nr: Int) {
        guard let option = testownik.manager?.getSelectedOption(forOptionNumber: nr) else { return }
        let isMark = option.lastYourCheck
        button.layer.borderWidth = isMark ? 3 : 1
        button.layer.borderColor = isMark ? UIColor.systemYellow.cgColor : UIColor.brown.cgColor

        
        //guard nr < test.answerOptions.count else {     return     }
        //let isMark =  test.answerOptions[nr].lastYourCheck ?? false
        //        let curElem = testownik.currentElement
        //guard let option = testownik.manager?.currentHistory?.answerOptions else { return }
        //button.layer.borderColor = button.layer.borderColor == UIColor.brown.cgColor ? UIColor.systemYellow.cgColor : UIColor.brown.cgColor
        //  button.layer.borderWidth == 1
    }

    func pinchRefreshUI(sender: UIPinchGestureRecognizer) {
        print("Pinch touches:\(sender.numberOfTouches),\(sender.scale) ")
        stackView.spacing = initalStackSpacing * sender.scale
        //view.transform = CGAffineTransform(scaleX: sender.scale, y: sender.scale)
    }
    func eadgePanRefreshUI() {
        print("Edge gesture")
//        let xx = UILabel()
//        let yy = xx.intrinsicContentSize.width
    }
    //======================
    func longPressRefreshUI(sender: UILongPressGestureRecognizer) {
        if let nr = sender.view?.tag {
            if (0...9).contains(nr) {
                    self.lastButton.Tag = nr
                    print("Tag:\(nr)")
                    if let button = sender.view as? UIButton, let txtLabel = button.titleLabel?.text {
                        print("BUTTON \(nr):\(txtLabel)")
                        self.lastButton.Color = button.tintColor
                        self.lastButton.BackgroundColor = button.backgroundColor ?? .orange
                        button.tintColor = UIColor.purple
                        button.backgroundColor = .yellow
                        gestures.disabledOtherGestures = true
                        Setup.popUpBlink(context: self, msg: txtLabel, numberLines: 5, height: 150) {
                            button.tintColor = self.lastButton.Color
                            button.backgroundColor = self.lastButton.BackgroundColor
                            self.gestures.disabledOtherGestures = false
                        }
                        //button.backgroundColor = .magenta
                    }
                }
                if nr == 2021 {
                     print("TAG:\(nr)")
                 }
            //buttons[nr].titleLabel?.scrollLeft()
        }
        print("longPressRefreshUI End:\(sender.view?.tag ?? 0),")
    }
    //==================
    func forcePressRefreshUI(sender: ForcePressGestureRecognizer) {
        if let nr = sender.view?.tag {
            if (0...9).contains(nr) {
                print("Tag:\(nr)")
                gestures.disabledOtherGestures = true
                if let button = sender.view as? UIButton, let txtLabel = button.titleLabel?.text {
                    print("Label:\(txtLabel)")
                    self.lastButton.Tag = nr
                    self.lastButton.Color = button.tintColor
                    self.lastButton.BackgroundColor = button.backgroundColor ?? .orange
                    button.tintColor = .purple
                    button.backgroundColor = .yellow
                    
                    let label = Setup.popUpStrong(context: self, msg: txtLabel, numberLines: 5, height: 150)
                    label.frame = Setup.popUpStrong.frame!
                    //Setup.popUpStrong.frame = label.frame
                    gestures.addTapGestureToView(forView: label, touchNumber: 1)
                    gestures.addSwipeGestureToView(direction: .down, forView: label)
                    gestures.addSwipeGestureToView(direction: .up, forView: label)
                    //label.gestureRecognizers?.removeAll()
                }
            }
            print("forcePressRefreshUI,\(sender.numberOfTouches),\(sender.view?.tag ?? 0)")
        }
    }
    func swipeRefreshLabel(sender: UISwipeGestureRecognizer, directions: [UISwipeGestureRecognizer.Direction]) {        
        if let tag = sender.view?.tag, tag == 2021 {
            if directions.count == 2 && (directions[0] == .down || directions[0] == .up ){
                var frame = sender.view?.frame
                if sender.direction == .up {
                    print("MOVE UP:\(sender.location(in: sender.view).y)")
                    frame?.origin.y -= sender.location(in: sender.view).y
                }
                else if sender.direction == .down {
                    print("MOVE DOWN:\(sender.location(in: sender.view).y)")
                    frame?.origin.y += sender.location(in: sender.view).y
                }
                UIView.animate(withDuration: 0.15) {
                    sender.view?.frame = frame!
                }
                //Setup.popUpStrong.frame = frame!
            }
            print("swipeRefreshLabel:\(tag),\(sender.direction.rawValue)")            
        }
    }
    func swipeRefreshUI(direction: UISwipeGestureRecognizer.Direction) {
        print("=====\nA currentTest: \(testownik.currentTestNumber)")
        //if let tag =
        switch direction {
            case .right:
                //if testownik.count > 1 {
                    testownik.previous()
                    //testownik.currentTest -=  testownik.filePosition != .first  ? 1 : 0
                //}
                print("Swipe to right")
            case .left:
                //if testownik.count > 0 {
                    testownik.next()
                    //testownik.currentTest +=  testownik.filePosition != .last  ? 1 : 0
                //}
                print("Swipe  & left ")
            case .up:
                print("Swipe up")
                testownik.visableLevel +=  testownik.visableLevel < 4 ? 1 : 0
            case .down:
                print("Swipe down")
                testownik.visableLevel -= testownik.visableLevel > 0 ? 1 : 0
            default:
                print("Swipe unrecognized")
            }
         print("Y pos: \(testownik.currentTestNumber)")
    }
    
    // MARK: TestownikDelegate protocol "refreshUI" metods
//    func refreshContent(forFileNumber fileNumber: Int) {
//        refreshView()
//    }
    func refreshButtonUI(forFilePosition filePosition: Manager.FilePosition) {
        print("filePosition=\(filePosition)")
        //testownik.filePosition = filePosition
        if filePosition == .first {
            hideButton(forButtonNumber: 0)
            hideButton(forButtonNumber: 1)
            hideButton(forButtonNumber: 3, isHide: false)
        }
        else if filePosition == .last {
            hideButton(forButtonNumber: 0, isHide: false)
            hideButton(forButtonNumber: 1, isHide: false)
            hideButton(forButtonNumber: 3)
        }
        else {
            hideButton(forButtonNumber: 0, isHide: false)
            hideButton(forButtonNumber: 1, isHide: false)
            hideButton(forButtonNumber: 3, isHide: false)
        }
//        if testownik.visableLevel < 3 {
//            for i in 0...3 {
//                hideButton(forButtonNumber: i)
//            }
//        }
        refreshView()
    }

    // MARK: ListeningDelegate method
    func updateGUI(messae recordedMessage: String) {
        listeningText.text = recordedMessage
    }
    func listenigStartStop(statusOn: Bool) {
        microphoneButt.image = (statusOn ?  UIImage(systemName: "mic.fill") : UIImage(systemName: "mic") )
    }
    @objc func startMe() {
        //listening.didTapRecordButton()
        listeningText.text = "🔴  Start listening  🎤 👄"
        //listeningText.text =
        

        //let yy = command.findCommand(forText: text)
        //findText(forText: text, patern: "lewo")
    }
    func tapNumberButton(forCommand cmd: Command.CommandList) {
        if Setup.animationEnded {
            gestures.disabledOtherGestures = false
            let butt = UIButton()
            butt.tag = cmd.rawValue
            buttonAnswerPress(sender: UIButton())
            print("TAG:\(butt.tag)")
        }
        else {
           print("Gestures disabled")
        }
    }
    func executeCommand(forCommand cmd: Command.CommandList) {
        print("COMMAND executeCommand:\(cmd.rawValue):\(command.vocabularyEn[cmd.rawValue][0])")
        print("stackView.arrangedSubviews.coun:\(stackView.arrangedSubviews.count)")
    
        print("One:\(String(describing: (stackView.arrangedSubviews[0] as! UIButton).titleLabel?.text))")
        switch cmd {
            case .start:        firstButtonPress(UIButton())
            case .previous:     previousButtonPress(UIButton())
            case .check:        checkButtonPress(UIButton())
            case .next:         nextButtonPress(UIButton())
            case .reduceScr:    testownik.visableLevel +=  (testownik.visableLevel < 4 ? 1 : 0)
            case .incScreen:    testownik.visableLevel -= (testownik.visableLevel > 0 ? 1 : 0)
            case .left:         firstButtonPress(UIButton())
            case .righi:        print("CMD")
            case .fullScreen:   print("CMD")
            case  .one,
                  .two,
                  .three,
                  .four,
                  .five,
                  .six,
                  .seven,
                  .eight,
                  .nine,
                  .ten: tapNumberButton(forCommand: cmd)
                        let butt = UIButton()
                        butt.tag = cmd.rawValue
                        buttonAnswerPress(sender: UIButton())
            case .end:          print("CMD")
            case .exit:         print("CMD")
            case .listen:       print("CMD")
            case .readOn:       print("CMD")
            case .showResult:   print("CMD")
            case .empty:        print("CMD")
        }
//        for curButt in stackView.arrangedSubviews     {
//            if let butt = curButt as? UIButton {
//                butt.isHidden =  false
//                butt.setTitle("\(Setup.placeHolderButtons) \(i)", for: .normal)
//                i += 1
//            }
//        }
    }
    // MARK: IBAction
    @IBAction func navButtSpaseAddPress(_ sender: UIBarButtonItem) {
        stackView.spacing += 5
//        stackView.
//        UIView.animateWithDuration(0.25) { () -> Void in
//            newView.hidden = false
//            scroll.contentOffset = offset
//        }
    }
    @objc func tapAction(sender :UITapGestureRecognizer) {
        print("TAP AAAAAAAA")
        sender.view?.removeFromSuperview()
        //self.view.removeFromSuperview(sender.view)
        //sender.view?.window?.rootViewController?.dismiss(animated: true, completion: {
            print("KONIEC")
    }
        //window?.rootViewController?.dismiss(animated: <#T##Bool#>, completion: <#T##(() -> Void)?##(() -> Void)?##() -> Void#>)
    //}
    //--------------------------------
    // TODO: Check content
    func resizeView() {
        //self.view.setNeedsUpdateConstraints()
        //self.view.layoutIfNeeded()
        //viewWillAppear(true)
        //self.view.setNeedsDisplay()
        //delegateView.setNeedsDisplay()
        //delegateView.layoutIfNeeded()
        //delegate.setNeedsUpdateConstraints()
    }
    @objc func restart() {
        listeningText.alpha = alphaLabel
    }
    
    // MARK: TestownikDelegate
    func refreshTabbarUI(visableLevel: Int) {
        print("refreshTabbarUI(),visableLevel:\(visableLevel)")
        switch visableLevel
            {
            case 4:
                listeningText.isHidden = false
                self.listeningText.alpha = alphaLabel
                buttonNaviHide(isHide: false)
                self.tabBarController?.tabBar.isHidden = false
                self.navigationController?.isNavigationBarHidden = false
                resizeView()
                // setNeedsUpdateConstraints
            case 3:
                self.listeningText.alpha = alphaLabel
                listeningText.isHidden = false
                buttonNaviHide(isHide: false)
                self.tabBarController?.tabBar.isHidden = false
                self.navigationController?.isNavigationBarHidden = true
                resizeView()
                //viewWillAppear(true)
                //viewDidLoad()
            case 2:
                self.listeningText.alpha = alphaLabel
                listeningText.isHidden = true
                buttonNaviHide(isHide: false)
                self.tabBarController?.tabBar.isHidden = false
                self.navigationController?.isNavigationBarHidden = true
                resizeView()
            case 1:
                listeningText.isHidden = true
                //listeningText.layer.animation(forKey: <#T##String#>)
                buttonNaviHide(isHide: true)
                self.tabBarController?.tabBar.isHidden = false
                self.navigationController?.isNavigationBarHidden = true

                UIView.animate(withDuration: 10.0, delay: 0.2,
                    options: .curveEaseOut, animations: {
                    self.listeningText.alpha = 0.0
                    }, completion: {(isCompleted) in   print("Animation finished")})
                Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(restart), userInfo: nil, repeats: true)
                
                //listeningText.layer.removeAllAnimations()
                //self.listeningText.alpha = 1.0
                
            case 0:
                listeningText.isHidden = true
                buttonNaviHide(isHide: true)
                self.tabBarController?.tabBar.isHidden = true
                self.navigationController?.isNavigationBarHidden = true

                self.listeningText.alpha = alphaLabel
                let xx = UILabel()
                xx.font = UIFont(name: "Helvetica Neue", size: 20)
                xx.textColor = .red
                xx.tintColor = .blue
            default: print("ERROR")
        }
    }
    // MARK: Shake event method
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            tabBarController?.overrideUserInterfaceStyle = isLightStyle ? .dark : .light
            isLightStyle.toggle()
            print("Shake")
        }
    }
    func buttonNaviHide(isHide: Bool) {
        actionsButtonStackView.isHidden = isHide
//        for elem in actionsButtonStackView.arrangedSubviews {
//            //elem.layer.zPosition = isHide ? -1 : 0
//            elem.isHidden = isHide
//        }
    }
    func resizeView(toMaximalize: Bool? = nil) {
        if let toAddSize = toMaximalize {
            stackView.spacing += toAddSize ? 1 : -1
        }
    }
    // MARK: Method to press answer button
    @objc func buttonAnswerPress(sender: UIButton) {
        let bgColorSelelect:   UIColor =  selectedColor
        let bgColorUnSelelect: UIColor =  unSelectedColor
        let youSelectedNumber: Int = sender.tag
        var isChecked:Bool = false
        
        print("buttonAnswerPress:\(youSelectedNumber)")
        guard testownik.currentTestNumber < testownik.count else {  return   }
        isChecked = testownik[testownik.currentTestNumber]?.youAnswer2.contains(youSelectedNumber) ?? false
        if isChecked {
            testownik[testownik.currentTestNumber]?.youAnswer2.remove(youSelectedNumber)
            isChecked = false
        } else  {
            testownik[testownik.currentTestNumber]?.youAnswer2.insert(youSelectedNumber)
            isChecked = true
        }
        //#colorLiteral(red: 0.9995340705, green: 0.988355577, blue: 0.4726552367, alpha: 1)
        //#colorLiteral(red: 0.4513868093, green: 0.9930960536, blue: 1, alpha: 1)
        
        if let button = stackView.arrangedSubviews[youSelectedNumber] as? UIButton {
            button.layer.borderWidth = 3
            //button.layer.borderColor = okAnswer ? UIColor.green.cgColor : UIColor.red.cgColor
            button.layer.backgroundColor = isChecked ?  bgColorSelelect.cgColor : bgColorUnSelelect.cgColor
        }
        //--------------------
//        var found = false
//
//        let okAnswer = isAnswerOk(selectedOptionForTest: youSelectedNumber)
//
//        for elem in testownik[testownik.currentTest].youAnswers {
//            if elem == testownik.currentTest {   found = true     }
//        }
//        if !found {
//            testownik[testownik.currentTest].youAnswers.append(youSelectedNumber)
//        }
//        if let button = stackView.arrangedSubviews[youSelectedNumber] as? UIButton {
//            button.layer.borderWidth = 3
//            button.layer.borderColor = okAnswer ? UIColor.green.cgColor : UIColor.red.cgColor
//        }
        print("aswers:\(testownik[testownik.currentTestNumber]?.youAnswers5)")
        print("aswers2:\(testownik[testownik.currentTestNumber]?.youAnswer2.sorted())")
    }
    func isAnswerOk(selectedOptionForTest selectedOption: Int) -> Bool {
         var value = false
        if  selectedOption < testownik[testownik.currentTestNumber]?.answerOptions.count ?? 0 {
            value = testownik[testownik.currentTestNumber]?.answerOptions[selectedOption].isOK ?? false
        }
        return value
    }
    func findValue<T: Comparable>(currentList: [T], valueToFind: T) -> Int {
        var found = -1
        for i in 0..<currentList.count {
            if (currentList[i] == valueToFind)  {   found = i     }
        }
        return found
    }
    func hideButton(forButtonNumber buttonNumber: Int, isHide: Bool = true) {
        guard buttonNumber < actionsButtonStackView.arrangedSubviews.count else { return }
        if let button = actionsButtonStackView.arrangedSubviews[buttonNumber] as? UIButton {
            button.isHidden = isHide 
        }
    }
    func clearView() {
        var i = 0
        askLabel.text = "\(Setup.placeHolderTitle)"
        for curButt in stackView.arrangedSubviews     {
            if let aTest = test, let butt = curButt as? UIButton {
                butt.isHidden =  false
                markSelected(forButton: butt, optionNr: i)
                butt.setTitle("\(Setup.placeHolderButtons) \(i)", for: .normal)
                i += 1
            }
        }
    }
    func refreshView() {
//        test?.answerOptions[0].lastYourCheck
//        test?.answerOptions[1].isOK
        guard var aTest = test else { return }
        //aTest.answerOptions[0].lastYourCheck = true
        print("COUNT:: \(testownik.manager?.testList.count)")
        print("refreshView")
        print("__ refreshView:\(testownik.currentTestNumber)")
        
        var i = 0
        let image = UIImage(named: "002.png")
        let set = Set([6,8,9])
        let txtFile = aTest.fileName
        
        self.title = "Test \(txtFile)"
        // TODO: check it
        aTest.youAnswer2.removeAll()
        let totalQuest = aTest.answerOptions.count
        aTest.youAnswers5.removeAll()
        askLabel.text = aTest.ask
        
        if  let currPict = aTest.pict {
            askPicture.image = currPict
            pictureSwitchOn = true
        }
        else {
            pictureSwitchOn = false
        }
        for curButt in stackView.arrangedSubviews     {
            if let butt = curButt as? UIButton {
                butt.contentHorizontalAlignment =  (Setup.isNumericQuestions ? .left : .center)
                butt.isHidden = (i < totalQuest) ? false : true
                guard testownik.isCurrentValid else {   return     }
                butt.setTitle((i < totalQuest) ? Setup.getNumericPict(number: i) + aTest.answerOptions[i].answerOption : "", for: .normal)
                butt.layer.borderWidth = 1
                butt.layer.borderColor = UIColor.brown.cgColor
                let isSelect = aTest.youAnswer2.contains(i) 
                butt.layer.backgroundColor = isSelect ? selectedColor.cgColor: unSelectedColor.cgColor
                markSelected(forButton: butt, optionNr: i)
                // MARK: ggggg ffffff
                if set.contains(i)  {
                    butt.setTitle(" \(i+1)", for: .normal)
                    butt.setImage(image, for: .normal)
                    butt.contentHorizontalAlignment = Setup.currentAligmentButton
                    //butt.alpha = 0.60
                    //butt.backgroundColor?.withAlphaComponent(0.1)
                }
            }
            i += 1
        }
//        actionsButtonStackView.arrangedSubviews[0].isHidden = (testownik.filePosition == .first)
//        actionsButtonStackView.arrangedSubviews[1].isHidden = (testownik.filePosition == .first)
//        actionsButtonStackView.arrangedSubviews[3].isHidden = (testownik.filePosition == .last)
    }
    func getText(fileName: String, encodingSystem encoding: String.Encoding = .utf8) -> [String] {  //windowsCP1250
        var texts: [String] = ["brak"]
        if let path = Bundle.main.path(forResource: fileName, ofType: "txt") {
            do {
//                let charSetFileType = NSHFSTypeOfFile(path)
//                print("File char set: \(charSetFileType)")
                //let xx = String("ąćśżź")
                //xx.encode(to: <#T##Encoder#>)
                //stringWithContentsOfFile;: aaa, usedEncoding:error: )
                let data = try String(contentsOfFile: path ,encoding: encoding)
                let myStrings = data.components(separatedBy: .newlines)
                texts = myStrings
            }
            catch {
                print(error)
            }
        }
        return texts
    }
    func getAnswer(_ codeAnswer: String) -> [Bool] {
        var answer = [Bool]()
        let myLenght=codeAnswer.count
        //print("myLenght:\(myLenght)")
        for i in 1..<myLenght {
            answer.append(codeAnswer.suffix(codeAnswer.count)[i]=="1" ? true : false)
        }
        //print("answer,\(answer)")
        return answer
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        listening.stopRecording()
        //speech.stopSpeak()
    }
    
        //    let button = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 50))
        //    button.backgroundColor = .greenColor()
        //    button.setTitle("Test Button", forState: .Normal)
        //    button.addTarget(self, action: #selector(buttonAction), forControlEvents: .TouchUpInside)
        //
}

