//
//  GameScene.swift
//  SpriteTest
//
//  Created by guominglong on 16/5/30.
//  Copyright (c) 2016年 guominglong. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    private var isInited:Bool! = false;
    private var feiji:SKSpriteNode!;
    private var feijiText:SKTexture!;
    private var feijiRunLoopZidan:SKAction!;//使用粒子作为子弹
    private var feijiRunLoopZidan2:SKAction!;//使用Sprite作为子弹
    private var zidanAlphaAc:SKAction!;
    
    private var zidanText:SKTexture!;
    private var zidanfeixing:SKAction!;
    private var zidancolors:[UIColor]!;
    private var zidanSourcePosition:[CGPoint]!;
    override func didMoveToView(view: SKView) {
        if(!isInited)
        {
            gmlinit();
        }
    }
    
    private func gmlinit()
    {
        self.scaleMode = .ResizeFill;//设置缩放模式
        //self.backgroundColor = SKColor(red: CGFloat(arc4random()%255)/255, green: CGFloat(arc4random()%255)/255, blue: CGFloat(arc4random()%255)/255, alpha: 1);//设置背景颜色
        self.backgroundColor = SKColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1);//设置背景颜色
        //self.physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame);//设置边框检测
        
        feijiText = SKTexture(imageNamed:"Spaceship");
        feiji = SKSpriteNode(texture: feijiText,normalMap: feijiText.textureByGeneratingNormalMapWithSmoothness(1, contrast: 1));
        feiji.physicsBody = SKPhysicsBody(texture: feijiText, size: feijiText.size());
        feiji.physicsBody?.affectedByGravity = false;//关闭重力
        feiji.xScale = 0.5;
        feiji.yScale = 0.5;
        feiji.position = CGPoint(x: 50, y: 100);
        feiji.zPosition = 2;
        self.addChild(feiji);
        feijiRunLoopZidan = SKAction.repeatActionForever(SKAction.sequence([
            SKAction.performSelector(Selector("createZiDan"), onTarget: self),
            SKAction.waitForDuration(0.1)
            ]))
        
        feijiRunLoopZidan2 = SKAction.repeatActionForever(SKAction.sequence([
            SKAction.performSelector(Selector("createZiDan2"), onTarget: self),
            SKAction.waitForDuration(0.06)
            ]))
        
        zidanAlphaAc = SKAction.fadeOutWithDuration(0.2);
        
        zidanText = SKTexture(image: UIImage(contentsOfFile: NSBundle.mainBundle().pathForResource("gmlassets/zidan", ofType: "png")!)!);
        
        zidanfeixing = SKAction.repeatActionForever(SKAction.moveByX(0, y: 20, duration: 0.03));
        
        zidancolors = [UIColor.greenColor().colorWithAlphaComponent(0.4),UIColor.greenColor().colorWithAlphaComponent(0.8),UIColor.redColor(),UIColor.greenColor().colorWithAlphaComponent(0.8),UIColor.greenColor().colorWithAlphaComponent(0.4)];
        zidanSourcePosition = [CGPoint(x: -feiji.size.width / 2 + 5, y: 0),CGPoint(x: -feiji.size.width / 4 + 5, y: 30),CGPoint(x: 0, y: feiji.size.height / 2),CGPoint(x: feiji.size.width / 4 - 5, y: 30),CGPoint(x: feiji.size.width / 2 - 5, y: 0)]
        isInited = true;
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
        beginActive();//开抢
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if(touches.first == nil)
        {
            return ;
        }
        feiji.position = touches.first!.locationInNode(self);
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        stopActive();//停止开抢
    }
    
    private func beginActive()
    {
        //self.runAction(feijiRunLoopZidan, withKey: "runloopZiDan");
        self.runAction(feijiRunLoopZidan2,  withKey: "runloopZiDan");
    }
    
    private func stopActive()
    {
        self.removeActionForKey("runloopZiDan");
        
    }
    
    func createZiDan()
    {
        
        let zidanNode = SKNode();
        let zidanAni = SKAction.moveTo(CGPoint(x:feiji.position.x,y:self.frame.height + 100), duration: 0.5);
        zidanAni.timingMode = .EaseOut;
        func onzidanUpdate(a:Float)->Float
        {
          
            let xiaoguo = SKEmitterNode(fileNamed: "fejizidan");
            xiaoguo!.position = zidanNode.position;
            self.addChild(xiaoguo!);
            
            xiaoguo!.runAction(zidanAlphaAc, completion: {
                xiaoguo!.removeAllActions();
                xiaoguo!.removeFromParent();
            })
            return a;
        }
        zidanAni.timingFunction = onzidanUpdate;
        zidanNode.position = CGPoint(x: feiji.position.x, y: feiji.position.y + feiji.frame.height / 2);
        self.addChild(zidanNode);
        zidanNode.runAction(zidanAni) {
            zidanNode.removeAllActions();
            zidanNode.removeFromParent();
            
        }
    }
    
    func createZiDan2()
    {
        
        for(var i:Int = 0 ;i<5;i++)	
        {
            let xiaoguo = SKSpriteNode(texture: zidanText);
            xiaoguo.position = feiji.position;
            xiaoguo.position.x = xiaoguo.position.x + zidanSourcePosition[i].x;
            xiaoguo.position.y = xiaoguo.position.y + zidanSourcePosition[i].y;
            xiaoguo.colorBlendFactor = 1;
            xiaoguo.color = zidancolors[i];
            self.addChild(xiaoguo);
            xiaoguo.name = "zidan";
            xiaoguo.runAction(zidanfeixing);
        }
    }


    
    
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        //这是个优化后的算法
        while(self["zidan"].count > 0 && self["zidan"][0].position.y > self.frame.height)
        {
            //self["zidan"][0].removeAllActions();
            self["zidan"][0].removeFromParent();
        }
        
        
        
    }
    
    
}
