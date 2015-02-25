//
//  GameScene.swift
//  MontyHallProblem
//
//  Created by sine on 2/22/15.
//  Copyright (c) 2015 sine. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    // Scene
    var bgLayer = SKNode()
    var background = SKSpriteNode()
    var unitWidth:CGFloat = 0
    var unitHeight:CGFloat = 0
    
    // Data
    var numberOfRounds = 0
    var numberOfSwitches = 0
    var numberOfStays = 0
    var numberOfWins = 0
    var numberOfLosses = 0
    var percentageOfWins = 0.0
    var numberOfWinsBySwitching = 0
    var numberOfWinsByStaying = 0
    var percentageOfWinsBySwitching = 0.0
    var percentageOfWinsByStaying = 0.0
    var playerDidSwitch:Bool = false
    var playerDidStay:Bool = false
    var playerDoorSelection = 99
    var previousDoorSelection = 99
    var playerPickedDoorPosition = CGPointMake(0, 0)
    var firstGoatPosition:CGPoint = CGPointMake(0, 0)
    var secondGoatPosition:CGPoint = CGPointMake(0, 0)
    var motoPosition:CGPoint = CGPointMake(0, 0)
    var playerFinalTapPosition:CGPoint = CGPointMake(0, 0)
    
    // Labels
    var roundsLabel:SKLabelNode? = nil
    var winsLabel:SKLabelNode? = nil
    var lossesLabel:SKLabelNode? = nil
    var switchesLabel:SKLabelNode? = nil
    var staysLabel:SKLabelNode? = nil
    var winsPercentageLabel:SKLabelNode? = nil
    var switchPercentageLabel:SKLabelNode? = nil
    var stayPercentageLabel:SKLabelNode? = nil
    var instructionsLabel:SKLabelNode? = nil
    
    // Reset button
    var resetButton:SKLabelNode? = nil
    
    // Doors
    var doorOne:SKSpriteNode? = nil
    var doorTwo:SKSpriteNode? = nil
    var doorThree:SKSpriteNode? = nil
    var doorArray:[SKSpriteNode] = []
    var doorPosArray:[CGPoint] = []
    
    // Selection sprite
    var selectionSprite:SKSpriteNode? = nil
    
    // The arrays below are needed to determine final prize reveal
    var doorArrayA:[SKSpriteNode] = []
    var doorPosArrayA:[CGPoint] = []
    var doorArrayB:[SKSpriteNode] = []
    var doorPosArrayB:[CGPoint] = []
    var doorArrayC:[SKSpriteNode] = []
    var doorPosArrayC:[CGPoint] = []
    
    // Prizes
    var motoSprite:SKSpriteNode? = nil
    var goatOneSprite:SKSpriteNode? = nil
    var goatTwoSprite:SKSpriteNode? = nil
    
    // State
    var previousTime:CFTimeInterval = 0
    
    // Bools determine which phase of the round player is in
    var roundBeginning:Bool = true
    var chooseInitialDoor:Bool = false
    var switchOrStay:Bool = false
    var roundOver:Bool = false

    
    
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        self.addChild(bgLayer)
        
        setUpBackground()
        setUpGridSystem()
        setUpLabels()
        roundBeginningFunc()
    }
    
    func resetGame() {
        
        let transition = SKTransition.pushWithDirection(SKTransitionDirection.Up, duration: 1.0)
        let scene = GameScene(size: self.size)
        scene.scaleMode = .AspectFill
        self.view?.presentScene(scene)
    }
    
    func setUpGridSystem() {
        
        unitWidth = background.size.width / 33
        unitHeight = background.size.height / 33
    }
    
    func setUpBackground() {
        
        background = SKSpriteNode(color: UIColor.whiteColor(), size: CGSizeMake(self.size.width, self.size.height))
        background.name = "background"
        bgLayer.addChild(background)
        background.anchorPoint = CGPointZero
        background.zPosition = 0
        background.position = CGPoint(x: self.frame.origin.x, y: self.frame.origin.y)
    }
    
    func setUpLabels() {
        
        makeResetButton()
        
        makeRoundsLabel()
        makeWinsLabel()
        makeLossesLabel()
        makeSwitchesLabel()
        makeStaysLabel()
        makeWinsPercentageLabel()
        makeSwitchPercentageLabel()
        makeStayPercentageLabel()
    }
    
    func makeResetButton() {
        
        resetButton = SKLabelNode(text: "Reset")
        resetButton?.name = "resetButton"
        resetButton?.fontName = "HelveticaNeue-Light"
        resetButton?.fontSize = background.size.width / 20
        resetButton?.fontColor = UIColor.blackColor()
        resetButton?.position = CGPoint(x: background.size.width / 2 - (unitWidth * 15), y: background.size.height - (unitHeight * 7))
        resetButton?.zPosition = 100
        resetButton?.horizontalAlignmentMode = .Left
        background.addChild(resetButton!)
    }
    
    func makeRoundsLabel() {
        
        roundsLabel = SKLabelNode(text: "Rounds: \(numberOfRounds)")
        roundsLabel?.fontName = "HelveticaNeue-Light"
        roundsLabel?.fontSize = background.size.width / 40
        roundsLabel?.fontColor = UIColor.blackColor()
        roundsLabel?.position = CGPoint(x: background.size.width / 2 + (unitWidth * 7), y: background.size.height / 2 + (unitHeight * 6))
        roundsLabel?.zPosition = 25
        roundsLabel?.horizontalAlignmentMode = .Left
        background.addChild(roundsLabel!)
    }
    
    func makeWinsLabel() {
        
        winsLabel = SKLabelNode(text: "Wins: \(numberOfWins)")
        winsLabel?.fontName = "HelveticaNeue-Light"
        winsLabel?.fontSize = background.size.width / 40
        winsLabel?.fontColor = UIColor.blackColor()
        winsLabel?.position = CGPoint(x: background.size.width / 2 + (unitWidth * 7), y: background.size.height / 2 + (unitHeight * 4))
        winsLabel?.zPosition = 25
        winsLabel?.horizontalAlignmentMode = .Left
        background.addChild(winsLabel!)
    }
    
    func makeLossesLabel() {
        
        lossesLabel = SKLabelNode(text: "Losses: \(numberOfLosses)")
        lossesLabel?.fontName = "HelveticaNeue-Light"
        lossesLabel?.fontSize = background.size.width / 40
        lossesLabel?.fontColor = UIColor.blackColor()
        lossesLabel?.position = CGPoint(x: background.size.width / 2 + (unitWidth * 7), y: background.size.height / 2 + (unitHeight * 2))
        lossesLabel?.zPosition = 25
        lossesLabel?.horizontalAlignmentMode = .Left
        background.addChild(lossesLabel!)
    }
    
    func makeSwitchesLabel() {
        
        switchesLabel = SKLabelNode(text: "Switches: \(numberOfSwitches)")
        switchesLabel?.fontName = "HelveticaNeue-Light"
        switchesLabel?.fontSize = background.size.width / 40
        switchesLabel?.fontColor = UIColor.blackColor()
        switchesLabel?.position = CGPoint(x: background.size.width / 2 + (unitWidth * 7), y: background.size.height / 2 + (unitHeight * 0))
        switchesLabel?.zPosition = 25
        switchesLabel?.horizontalAlignmentMode = .Left
        background.addChild(switchesLabel!)
    }
    
    func makeStaysLabel() {
        
        staysLabel = SKLabelNode(text: "Stays: \(numberOfStays)")
        staysLabel?.fontName = "HelveticaNeue-Light"
        staysLabel?.fontSize = background.size.width / 40
        staysLabel?.fontColor = UIColor.blackColor()
        staysLabel?.position = CGPoint(x: background.size.width / 2 + (unitWidth * 7), y: background.size.height / 2 - (unitHeight * 2))
        staysLabel?.zPosition = 25
        staysLabel?.horizontalAlignmentMode = .Left
        background.addChild(staysLabel!)
        
    }
    
    func makeWinsPercentageLabel() {
        
        winsPercentageLabel = SKLabelNode(text: "Win %: \(percentageOfWins)")
        winsPercentageLabel?.fontName = "HelveticaNeue-Light"
        winsPercentageLabel?.fontSize = background.size.width / 40
        winsPercentageLabel?.fontColor = UIColor.blackColor()
        winsPercentageLabel?.position = CGPoint(x: background.size.width / 2 + (unitWidth * 7), y: background.size.height / 2 - (unitHeight * 4))
        winsPercentageLabel?.zPosition = 25
        winsPercentageLabel?.horizontalAlignmentMode = .Left
        background.addChild(winsPercentageLabel!)
        
    }

    
    func makeSwitchPercentageLabel() {
        
        switchPercentageLabel = SKLabelNode(text: "Win % by switch: \(percentageOfWinsByStaying)")
        switchPercentageLabel?.fontName = "HelveticaNeue-Light"
        switchPercentageLabel?.fontSize = background.size.width / 40
        switchPercentageLabel?.fontColor = UIColor.blackColor()
        switchPercentageLabel?.position = CGPoint(x: background.size.width / 2 + (unitWidth * 7), y: background.size.height / 2 - (unitHeight * 6))
        switchPercentageLabel?.zPosition = 25
        switchPercentageLabel?.horizontalAlignmentMode = .Left
        background.addChild(switchPercentageLabel!)
        
    }
    
    func makeStayPercentageLabel() {
     
        stayPercentageLabel = SKLabelNode(text: "Win % by stay: \(percentageOfWinsByStaying)")
        stayPercentageLabel?.fontName = "HelveticaNeue-Light"
        stayPercentageLabel?.fontSize = background.size.width / 40
        stayPercentageLabel?.fontColor = UIColor.blackColor()
        stayPercentageLabel?.position = CGPoint(x: background.size.width / 2 + (unitWidth * 7), y: background.size.height / 2 - (unitHeight * 8))
        stayPercentageLabel?.zPosition = 25
        stayPercentageLabel?.horizontalAlignmentMode = .Left
        background.addChild(stayPercentageLabel!)
    }
    
    func makeDoors() {
        
        // Clear arrays before filling and remove doors before creating
        doorArray.removeAll(keepCapacity: false)
        doorPosArray.removeAll(keepCapacity: false)
        doorOne?.removeFromParent()
        doorTwo?.removeFromParent()
        doorThree?.removeFromParent()
        
        doorArrayA.removeAll(keepCapacity: false)
        doorArrayB.removeAll(keepCapacity: false)
        doorArrayC.removeAll(keepCapacity: false)
        doorPosArrayA.removeAll(keepCapacity: false)
        doorPosArrayB.removeAll(keepCapacity: false)
        doorPosArrayC.removeAll(keepCapacity: false)
        
        // Create doors and assign names
        doorOne = SKSpriteNode(imageNamed: "doorPic.png")
        doorOne?.name = "doorOne"
        doorTwo = SKSpriteNode(imageNamed: "doorPic.png")
        doorTwo?.name = "doorTwo"
        doorThree = SKSpriteNode(imageNamed: "doorPic.png")
        doorThree?.name = "doorThree"
        
        // Add doors to array
        if doorOne != nil && doorTwo != nil && doorThree != nil {
            
            doorArray.append(doorOne!)
            doorArray.append(doorTwo!)
            doorArray.append(doorThree!)
            
            doorArrayA.append(doorOne!)
            doorArrayB.append(doorTwo!)
            doorArrayC.append(doorThree!)
        }
        
        // Create door position array, assign to doors, add to background
        for i in 1...3 {
            var posX = (background.frame.origin.x + (CGFloat(i) * (unitWidth * 7.0))) - (unitWidth * 2)
            var posY = background.size.height / 2 - (unitHeight * 4)
            var position = CGPointMake(posX, posY)
        
            doorPosArray.append(position)
            
            doorArray[i - 1].position = position
            doorArray[i - 1].zPosition = 50
            doorArray[i - 1].setScale(0.4)
            background.addChild(doorArray[i - 1])
        }
        
        doorPosArrayA = doorPosArray
        doorPosArrayB = doorPosArray
        
//        println("doorPosArray = \(doorPosArray)")
    }
    
    func makeInstructionsLabel() {
        
        instructionsLabel?.removeFromParent()
        
        instructionsLabel = SKLabelNode(text: "Tap to start game")
        instructionsLabel?.name = "instructionsLabel"
        instructionsLabel?.fontName = "HelveticaNeue-Light"
        instructionsLabel?.fontColor = UIColor.blackColor()
        instructionsLabel?.fontSize = background.size.width / 20
        instructionsLabel?.zPosition = 100
        instructionsLabel?.position = CGPoint(x: background.size.width / 2, y: background.size.height - (unitHeight * 7))
        if (instructionsLabel != nil) {
            background.addChild(instructionsLabel!)
        }
    }
    
    func roundBeginningFunc() {
        
        makeDoors()
        makeInstructionsLabel()
        removeOrResetPrizes()
        
        roundBeginning = true
        chooseInitialDoor = false
        switchOrStay = false
        roundOver = false
        
        numberOfRounds += 1
        roundsLabel?.text = "Rounds: \(numberOfRounds)"
    }
    
    func chooseInitialDoorFunc() {
        
        instructionsLabel?.text = "Choose a door."
        
        roundBeginning = false
        chooseInitialDoor = true
        switchOrStay = false
        roundOver = false
    }
    
    func switchOrStayFunc() {
        
        instructionsLabel?.text = "Switch door or stay?"
        
        roundBeginning = false
        chooseInitialDoor = false
        switchOrStay = true
        roundOver = false
        
    }
    
    func roundOverFunc() {
    
//        instructionsLabel?.text = "Round complete. Tap to replay."
        
        roundBeginning = false
        chooseInitialDoor = false
        switchOrStay = false
        roundOver = true
        
    }
    
    func removeInitialDoorChoiceFromDoorArrays() {
        
        if playerDoorSelection >= 0 && playerDoorSelection <= 2 {
            
            // Determines the position of player's initial picked door
            playerPickedDoorPosition = doorPosArrayA[playerDoorSelection]
            
            // Remove player's initial pick from the array
            // for first goat pick
            doorPosArrayB = doorPosArrayA
            doorPosArrayB.removeAtIndex(playerDoorSelection)
            
            displayFirstGoat()
        }
    }
    
    func displayFirstGoat() {
        
        let randomPos:Int = Int(arc4random_uniform(2))
        
//        println("doorPosArrayB = \(doorPosArrayB)")
        
        goatOneSprite = SKSpriteNode(imageNamed: "goatPic.jpg")
        goatOneSprite?.name = "goatOneSprite"
        goatOneSprite?.setScale(0.75)
        goatOneSprite?.position = doorPosArrayB[randomPos]
        goatOneSprite?.zPosition = 100
        firstGoatPosition = goatOneSprite!.position
        background.addChild(goatOneSprite!)
        
        // Remove first goat position from doorPosArrayB;
        // Then combine remaining position and player picked position
        // for final array - doorPosArrayC - 
        // That will determine final prize reveal
        
        doorPosArrayB.removeAtIndex(randomPos)
        doorPosArrayC.append(doorPosArrayB[0])
        doorPosArrayC.append(playerPickedDoorPosition)
        
    }
    
    func removeOrResetPrizes() {
        
        goatOneSprite?.removeFromParent()
        goatTwoSprite?.removeFromParent()
        motoSprite?.removeFromParent()
        selectionSprite?.removeFromParent()
        
        playerDoorSelection = 99
        previousDoorSelection = playerDoorSelection
        
        playerDidSwitch = false
        playerDidStay = false
    }
    
    func createOrUpdateSelectionSprite() {
        
        selectionSprite?.removeFromParent()
        
        selectionSprite = SKSpriteNode(imageNamed: "lilCircle.png")
        selectionSprite?.name = "selectionSprite"
        selectionSprite?.setScale(0.5)
        selectionSprite?.position = playerPickedDoorPosition
        selectionSprite?.zPosition = 150
        selectionSprite?.alpha = 0.5
        background.addChild(selectionSprite!)
    }
    
    func didPlayerSwitch() {
        
        if (playerDoorSelection != previousDoorSelection) {
            println("player switched!")
            numberOfSwitches += 1
            playerDidSwitch = true
            switchesLabel?.text = "Switches: \(numberOfSwitches)"
        }
        else {
            println("player stayed!")
            numberOfStays += 1
            playerDidStay = true
            staysLabel?.text = "Stays: \(numberOfStays)"
        }
        
    }


    
    func displayFinalDoors() {
        
        let randomChoice:Int = Int(arc4random_uniform(2))
        
        goatTwoSprite = SKSpriteNode(imageNamed: "goatPic.jpg")
        goatTwoSprite?.name = "goatTwoSprite"
        goatTwoSprite?.setScale(0.75)
        goatTwoSprite?.position = doorPosArrayC[randomChoice]
        goatTwoSprite?.zPosition = 100
        background.addChild(goatTwoSprite!)
        
        doorArray.removeAtIndex(randomChoice)
        
        doorPosArrayC.removeAtIndex(randomChoice)
//        println("doorArray = \(doorArray)")
//        println("doorPosArrayC = \(doorPosArrayC)")
        
        motoSprite = SKSpriteNode(imageNamed: "sv650PicSmall.jpeg")
        motoSprite?.name = "motoSprite"
        motoSprite?.setScale(0.3)
        motoSprite?.position = doorPosArrayC[0]
        motoSprite?.zPosition = 100
        background.addChild(motoSprite!)
        
        // Change name of initial goat to goatTwoSprite to avoid dead tap zone
        goatOneSprite?.name = "goatTwoSprite"
        
        if (CGRectIntersectsRect(selectionSprite!.frame, motoSprite!.frame)) {
            println("win!")
            
            instructionsLabel?.text = "Win! :) Tap to replay."
            
            numberOfWins += 1
            winsLabel?.text = "Wins: \(numberOfWins)"
            
            if (playerDidSwitch == true) {
                numberOfWinsBySwitching += 1
            }
            else if (playerDidStay == true) {
                numberOfWinsByStaying += 1
            }
            
        }
        else {
            println("lose!")
            
            instructionsLabel?.text = "Lose! :( Tap to replay."

            numberOfLosses += 1
            lossesLabel?.text = "Losses: \(numberOfLosses)"
        }
        
        calculatePercentageOfWins()
        calculateSwitchStayWinPercentage()
        
    }
    
    func calculatePercentageOfWins() {
        
        percentageOfWins = Double(numberOfWins) / Double(numberOfRounds)
        
        var winsPercStrFormatted = NSString(format: "Win %%: %.1f", percentageOfWins * 100)
        
        winsPercentageLabel?.text = winsPercStrFormatted
        
    }
    
    func calculateSwitchStayWinPercentage() {
        
//        var winPercBySwitch:Double = (Double(numberOfWinsBySwitching) / Double(numberOfWins)) * (Double(numberOfWins) / Double(numberOfRounds))
//        var winPercByStay:Double = (Double(numberOfWinsByStaying) / Double(numberOfWins)) * (Double(numberOfWins) / Double(numberOfRounds))
        
        var winPercBySwitch:Double = (Double(numberOfWinsBySwitching) / Double(numberOfWins)) * percentageOfWins
        var winPercByStay:Double = (Double(numberOfWinsByStaying) / Double(numberOfWins)) * percentageOfWins
        
        println("winPercBySwitch = \(winPercBySwitch)")
        println("winPercByStay = \(winPercByStay)")
        
        var switchStrFormatted = NSString(format: "Win %% by switch: %.1f", winPercBySwitch * 100)
        var stayStrFormatted = NSString(format: "Win %% by stay: %.1f", winPercByStay * 100)
        
        // Checking for NaN?
        if winPercBySwitch.isNaN == false {
//            switchPercentageLabel?.text = "Win % by switch: \(winPercBySwitch)"
            switchPercentageLabel?.text = switchStrFormatted
        }
        if winPercByStay.isNaN == false {
//            stayPercentageLabel?.text = "Win % by stay: \(winPercByStay)"
            stayPercentageLabel?.text = stayStrFormatted
        }
        
        
    }
    
    override func update(currentTime: CFTimeInterval) {
        
        if (currentTime - previousTime > 2) {
            
//            println("time is \(currentTime)")
            previousTime = currentTime
        }
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            let nodeAtPoint = self.nodeAtPoint(location)
            
            if (nodeAtPoint.name != nil) {
                
                if (nodeAtPoint.name == "resetButton") {
                    
                    resetGame()
                }
                
                if (nodeAtPoint.name == "doorOne") || (nodeAtPoint.name == "doorTwo") || (nodeAtPoint.name == "doorThree") || (nodeAtPoint.name == "goatTwoSprite") || (nodeAtPoint.name == "motoSprite") || (nodeAtPoint.name == "selectionSprite") {
                    
                    if (roundOver == true) {
                        
                        roundBeginningFunc()
                    }
                    
                    if (switchOrStay == true) {
                        
                        if (nodeAtPoint.name == "doorOne") {
                            println("doorOne tapped in switchOrStay")
                            playerDoorSelection = 0
                            playerPickedDoorPosition = location
                            createOrUpdateSelectionSprite()
                            didPlayerSwitch()
                        }
                        else if (nodeAtPoint.name == "doorTwo") {
                            println("doorTwo tapped in switchOrStay")
                            playerDoorSelection = 1
                            playerPickedDoorPosition = location
                            createOrUpdateSelectionSprite()
                            didPlayerSwitch()
                        }
                        else if (nodeAtPoint.name == "doorThree") {
                            println("doorThree tapped in switchOrStay")
                            playerDoorSelection = 2
                            playerPickedDoorPosition = location
                            createOrUpdateSelectionSprite()
                            didPlayerSwitch()
                        }
                        else if (nodeAtPoint.name == "selectionSprite") {
                            didPlayerSwitch()
                        }
                        
                        roundOverFunc()
                        displayFinalDoors()
                        
                    }
                    
                    if (chooseInitialDoor == true) {
                        
                        if (nodeAtPoint.name == "doorOne") {
                            println("doorOne tapped in chooseInitialDoor")
                            playerDoorSelection = 0
                            removeInitialDoorChoiceFromDoorArrays()
                            createOrUpdateSelectionSprite()
                            
                            previousDoorSelection = playerDoorSelection
                            
                        }
                        else if (nodeAtPoint.name == "doorTwo") {
                            println("doorTwo tapped in chooseInitialDoor")
                            playerDoorSelection = 1
                            removeInitialDoorChoiceFromDoorArrays()
                            createOrUpdateSelectionSprite()
                            
                            previousDoorSelection = playerDoorSelection

                        }
                        else if (nodeAtPoint.name == "doorThree") {
                            println("doorThree tapped in chooseInitialDoor")
                            playerDoorSelection = 2
                            removeInitialDoorChoiceFromDoorArrays()
                            createOrUpdateSelectionSprite()
                            
                            previousDoorSelection = playerDoorSelection

                        }
                        
                        switchOrStayFunc()
                    }
                    
                    if (roundBeginning == true) {
                        
                        chooseInitialDoorFunc()
                    }
                }
                
            }
        }
    }
}
