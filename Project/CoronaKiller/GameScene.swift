//
//  GameScene.swift
//  CoronaKiller
//
//  Created by Bhavesh Sharma on 22/05/21.
//

import UIKit
import SpriteKit
import GameplayKit


class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var starBg:SKEmitterNode!
    
    var player:SKSpriteNode!
    var logoutBtn: SKLabelNode!
    var replayBtn: SKLabelNode!
    var playBtn: SKLabelNode!
    var yourScoreLbl: SKLabelNode!
    var topPlayerScoreLbl: SKLabelNode!
    
    var scoreLabel:SKLabelNode!
    var topScoreLabel:SKLabelNode!
    
    var score:Int = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var topScore:Int = 0 {
        didSet {
            topScoreLabel.text = "Top Score: \(topScore)"
        }
    }
    
    var coronaTimer:Timer!
    
    let coronaCategory:UInt32 = 8
    let injectionCategory:UInt32 = 16
    let playerCategory:UInt32 = 32
    
    var isPlayerDead = false
    var isGameStart = false
    
    override func didMove(to view: SKView) {
        
        addPlayButton()
        addSwipeGesture()
        
    }
    
    func addSwipeGesture(){
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(swiped(gesture:)))
        
        swipeUp.direction = UISwipeGestureRecognizer.Direction.up
        self.view?.addGestureRecognizer(swipeUp)
    }
    
    @objc func swiped(gesture: UIGestureRecognizer){
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer{
            
            switch swipeGesture.direction {
            
            case .up:
                print("swipe up")
                
                let jumpUpAction = SKAction.moveBy(x: 0, y: size.height/3, duration: 0.6)
                
                let jumpDownAction = SKAction.moveBy(x: 0, y: -size.height/3, duration: 0.6)
                
                let jumpSequence = SKAction.sequence([jumpUpAction, jumpDownAction])
                
                player.run(jumpSequence)
                break
                
            default:
                break
            }
        }
    }
    
    func startGame(){
        starBg = SKEmitterNode(fileNamed: "StarBg")
        starBg.position = CGPoint(x: size.width/2, y: size.height)
        
        starBg.advanceSimulationTime(10)
        self.addChild(starBg)
        
        starBg.zPosition = -1
        
        addPlayer()
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsWorld.contactDelegate = self
        
        scoreLabel = SKLabelNode(text: "Score: 0")
        if let i = SessionManager.i.localData.currentUserIndex{
            topScoreLabel = SKLabelNode(text: "Top Score: \(SessionManager.i.localData.users[i].score ?? 0)")
            topScore = SessionManager.i.localData.users[i].score
        }else{
            topScoreLabel = SKLabelNode(text: "Top Score: 0")
        }
        
        let exitLbl = SKLabelNode(text: "Exit")
        exitLbl.name = "exit"
        exitLbl.fontSize = 36
        exitLbl.fontColor = UIColor.white
        exitLbl.position = CGPoint(x: size.width - 120, y: self.frame.size.height - 120)
        
        scoreLabel.position = CGPoint(x: size.width/4.7, y: self.frame.size.height - 80)
        topScoreLabel.position = CGPoint(x: size.width/4.4, y: self.frame.size.height - 120)
        scoreLabel.fontSize = 36
        scoreLabel.fontColor = UIColor.white
        score = 0
        
        self.addChild(exitLbl)
        self.addChild(scoreLabel)
        self.addChild(topScoreLabel)
        
        coronaTimer = Timer.scheduledTimer(timeInterval: 0.70, target: self, selector: #selector(addCorona), userInfo: nil, repeats: true)
    }
    
    func addMenuButton(){
        addLogoutButton()
        addReplayButton()
    }
    
    func removeMenuButton(){
        if(logoutBtn != nil){
            logoutBtn.removeFromParent()
        }
        if(replayBtn != nil){
            replayBtn.removeFromParent()
        }
        if(yourScoreLbl != nil){
            yourScoreLbl.removeFromParent()
        }
        if(topPlayerScoreLbl != nil){
            topPlayerScoreLbl.removeFromParent()
        }
    }
    
    func addPlayButton(){
        playBtn = SKLabelNode(text: "      ")
        playBtn.name = "play"
        playBtn.fontSize = 36
        playBtn.fontColor = UIColor.white
        playBtn.position = CGPoint(x: frame.midX - 100, y: frame.midY+60)
        
        let background = SKSpriteNode(imageNamed: "play")
        background.size = CGSize(width: 150, height: 150)
        background.position = CGPoint(x: 100, y: 50)
        background.zPosition = -1
        
        playBtn.addChild(background)
        addChild(playBtn)
    }
    
    func addLogoutButton(btnPosition: CGPoint? = nil){
        
        logoutBtn = SKLabelNode(text: "      ")
        logoutBtn.name = "exit"
        logoutBtn.fontSize = 36
        logoutBtn.fontColor = UIColor.white
        logoutBtn.position = CGPoint(x: frame.midX - 100, y: frame.midY)
        
        let background = SKSpriteNode(imageNamed: "exit")
        background.size = CGSize(width: 150, height: 150)
        background.position = CGPoint(x: 100, y: 100)
        background.zPosition = -1
        
        logoutBtn.addChild(background)
        addChild(logoutBtn)
        
    }
    
    func addReplayButton(){
        replayBtn = SKLabelNode(text: "      ")
        replayBtn.name = "replay"
        replayBtn.fontSize = 36
        replayBtn.fontColor = UIColor.white
        replayBtn.position = CGPoint(x: frame.midX-100, y: frame.midY)
        
        let background = SKSpriteNode(imageNamed: "reload")
        background.size = CGSize(width: 150, height: 150)
        background.position = CGPoint(x: 100, y: -100)
        background.zPosition = -1
        replayBtn.addChild(background)
        
        addChild(replayBtn)
    }
    
    func addyourScoreLbl(){
        yourScoreLbl = SKLabelNode(text: "Your Score: \(self.score)")
        yourScoreLbl.fontSize = 32
        yourScoreLbl.fontName = "AvenirNext-Bold"
        yourScoreLbl.fontColor = UIColor.white
        yourScoreLbl.zPosition = 999
        yourScoreLbl.position = CGPoint(x: frame.midX, y: frame.midY+250)
        
        let background = SKSpriteNode(color: Colors.darkBlue, size: CGSize(width: CGFloat(yourScoreLbl.frame.size.width+40), height:CGFloat(yourScoreLbl.frame.size.height+40)))
        
        background.position = CGPoint(x: 0, y: 12)
        background.zPosition = -1
        yourScoreLbl.addChild(background)
        
        addChild(yourScoreLbl)
    }
    
    func getTopPlayers() -> String{
        let ld = SessionManager.i.localData.users
        let sorted = ld.sorted(by: {$0.score > $1.score})
        
        var str = "Top 3 Players:\n\n"
        for i in 0..<sorted.count{
            if(i < 3){
                str += sorted[i].username + ": \(sorted[i].score!)" + (i < 2 ? "\n\n" : "")
            }
        }
        print(str)
        return str
    }
    
    func addtopPlayerScoreLbl(){
        
        let text = "\(getTopPlayers())"
        let lbl = SKLabelNode()
        lbl.fontSize = 32 // Fill the screen
        lbl.fontName = "AvenirNext-Bold"
        lbl.verticalAlignmentMode = .center // Keep the origin in the center
        lbl.text = text
        let message = lbl.multilined()
        message.position = CGPoint(x: frame.midX, y: frame.midY-350)
        message.zPosition = 999  // On top of all other nodes
        
        let background = SKSpriteNode(color: Colors.darkBlue, size: CGSize(width: CGFloat(size.width/1.4), height:CGFloat(280)))
        background.position = CGPoint(x: 0, y: 0)
        background.zPosition = -1
        
        topPlayerScoreLbl = message
        message.addChild(background)
        addChild(message)
    }
    
    func addPlayer(){
        player = SKSpriteNode(imageNamed: "player")
        player.size = CGSize(width: 150, height: 100)
        player.position = CGPoint(x: self.frame.size.width / 2, y: player.size.height / 2 + 20)
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.height / 2)
        player.physicsBody?.categoryBitMask = playerCategory
        player.physicsBody?.contactTestBitMask = coronaCategory
        player.physicsBody?.collisionBitMask = coronaCategory | 0
        
        self.addChild(player)
    }
    
    func randomInRange(lo: Int, hi : Int) -> Int {
        return lo + Int(arc4random_uniform(UInt32(hi - lo + 1)))
    }
    
    @objc func addCorona () {
        let coronaList = ["corona1", "corona2", "corona3", "corona4"]
        let corona = SKSpriteNode(imageNamed: coronaList.shuffled()[0])
        
        let randomPosition = GKRandomDistribution(lowestValue: 0, highestValue: 414)
        let position = CGFloat(randomPosition.nextInt())
        
        let randomX = CGFloat(randomInRange(lo: Int(self.frame.minX), hi: Int(self.frame.maxX)))
        
        //        print(randomX)
        
        corona.position = CGPoint(x: randomX, y: self.frame.size.height + corona.size.height)
        corona.size = CGSize(width: 100, height: 100)
        corona.physicsBody = SKPhysicsBody(rectangleOf: corona.size)
        corona.physicsBody?.isDynamic = true
        
        corona.physicsBody?.categoryBitMask = coronaCategory
        corona.physicsBody?.contactTestBitMask = injectionCategory
        corona.physicsBody?.collisionBitMask = injectionCategory
        
        self.addChild(corona)
        
        var skActions: [SKAction] = []
        
        skActions.append(SKAction.move(to: CGPoint(x: position, y: -corona.size.height), duration: 6))
        skActions.append(SKAction.removeFromParent())
        
        corona.run(SKAction.sequence(skActions))
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches{
            if (touch == touches.first){
                enumerateChildNodes(withName: "//*") { node, stop in
                    if let name = node.name{
                        //                        print(name)
                        if(name == "exit"){
                            if(node.contains(touch.location(in: self))){
                                print("exit 1 btn tapped")
                                SessionManager.i.localData.isLoggedIn = false
                                SessionManager.i.save()
                                self.removeMenuButton()
                                self.goBack()
                            }
                        }else if(name == "replay"){
                            if(node.contains(touch.location(in: self))){
                                print("replay 1 btn tapped")
                                self.isPlayerDead = false
                                self.isGameStart = true
                                self.addPlayer()
                                self.coronaTimer = Timer.scheduledTimer(timeInterval: 0.80, target: self, selector: #selector(self.addCorona), userInfo: nil, repeats: true)
                                self.removeMenuButton()
                            }
                        }else if(name == "play"){
                            if(node.contains(touch.location(in: self))){
                                self.isGameStart = true
                                self.startGame()
                                self.playBtn.removeFromParent()
                            }
                        }
                    }
                }
            }
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        var isMenuBtnTap = false
        for touch in touches{
            if (touch == touches.first){
                enumerateChildNodes(withName: "//*") { node, stop in
                    if(node.name == "exit" || node.name == "play" || node.name == "replay"){
                        if(node.contains(touch.location(in: self))){
                            isMenuBtnTap = true
                        }
                    }
                }
            }
        }
        if(!isPlayerDead && !isMenuBtnTap && isGameStart){
            shootInjection()
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let loc = touch.location(in: self)
            player.position.x = loc.x
        }
    }
    
    func shootInjection() {
        self.run(SKAction.playSoundFileNamed("shoot.wav", waitForCompletion: false))
        
        let injectionNode = SKSpriteNode(imageNamed: "injection")
        injectionNode.size = CGSize(width: 50, height: 100)
        injectionNode.name = "injection"
        injectionNode.position = player.position
        injectionNode.position.y += 5
        
        injectionNode.physicsBody = SKPhysicsBody(circleOfRadius: injectionNode.size.width / 2)
        injectionNode.physicsBody?.isDynamic = true
        
        injectionNode.physicsBody?.categoryBitMask = injectionCategory
        injectionNode.physicsBody?.contactTestBitMask = coronaCategory
        injectionNode.physicsBody?.collisionBitMask = coronaCategory
        injectionNode.physicsBody?.usesPreciseCollisionDetection = true
        
        self.addChild(injectionNode)
        
        var skActions: [SKAction] = []
        
        skActions.append(SKAction.move(to: CGPoint(x: player.position.x, y: self.frame.size.height + 10), duration: 0.8))
        skActions.append(SKAction.removeFromParent())
        
        injectionNode.run(SKAction.sequence(skActions))
        
    }
    
    
    func collideInjectionWithCorona (node:SKNode?) {
        
        let spark = SKEmitterNode(fileNamed: "spark")!
        if(node != nil){
            spark.position = node!.position
        }
        spark.particlePositionRange = CGVector(dx: 10, dy: 10)
        self.addChild(spark)
        
        self.run(SKAction.playSoundFileNamed("blast.mp3", waitForCompletion: false))
        
        node?.removeFromParent()
        self.run(SKAction.wait(forDuration: 0.4)) {
            spark.removeFromParent()
        }
        
        score += 1
        
        //level up
        if(score == 50){
            self.coronaTimer.invalidate()
            self.coronaTimer = Timer.scheduledTimer(timeInterval: 0.50, target: self, selector: #selector(self.addCorona), userInfo: nil, repeats: true)
        }else if(score == 100){
            self.coronaTimer.invalidate()
            self.coronaTimer = Timer.scheduledTimer(timeInterval: 0.30, target: self, selector: #selector(self.addCorona), userInfo: nil, repeats: true)
        }
        
    }
    
    func goBack(){
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "GameViewController") as! GameViewController
        self.view?.window?.rootViewController = vc
        self.view?.window?.makeKeyAndVisible()
        self.view?.window?.rootViewController?.present(vc, animated: true, completion: nil)
        
    }
    
    func onPlayerKilled(){
        //removing player
        isPlayerDead = true
        isGameStart = false
        self.run(SKAction.playSoundFileNamed("scream.mp3", waitForCompletion: false))
        player.removeFromParent()
        let ld = SessionManager.i.localData
        guard let index = ld.currentUserIndex else { self.goBack(); return; }
        self.coronaTimer.invalidate()
        
        //updating score
        ld.users[index].score = self.score > ld.users[index].score ? self.score : ld.users[index].score
        self.topScore = ld.users[index].score
        SessionManager.i.save()
        
        //showing scores
        addyourScoreLbl()
        addtopPlayerScoreLbl()
        
        self.score = 0
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        //injection and corona collision
        if(contact.bodyA.categoryBitMask == injectionCategory && contact.bodyB.categoryBitMask == coronaCategory){
            collideInjectionWithCorona(node: contact.bodyB.node)
            contact.bodyA.node?.removeFromParent()
        }
        //injection and corona collision
        if(contact.bodyA.categoryBitMask == coronaCategory && contact.bodyB.categoryBitMask == injectionCategory){
            let node = contact.bodyA.node
            collideInjectionWithCorona(node: node)
            contact.bodyB.node?.removeFromParent()
        }
        
        // corona and player collision
        if(contact.bodyA.categoryBitMask == coronaCategory && contact.bodyB.categoryBitMask == playerCategory){
            onPlayerKilled()
            addMenuButton()
        }
        // corona and player collision
        if(contact.bodyA.categoryBitMask == playerCategory && contact.bodyB.categoryBitMask == coronaCategory){
            onPlayerKilled()
            addMenuButton()
        }
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
