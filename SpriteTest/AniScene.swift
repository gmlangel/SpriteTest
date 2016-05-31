//
//  AniScene.swift
//  SpriteTest
//
//  Created by guominglong on 16/5/31.
//  Copyright © 2016年 guominglong. All rights reserved.
//

import Foundation
import SpriteKit
class AniScene:SKScene {
    
    
    private var isInited:Bool! = false;
    private var peopleTexts:SKTextureAtlas!;//人物的所有动作文理集合
    private var peopleNode:SKSpriteNode!;//人物节点
    private var peopleNodeScale:CGFloat!=1;//0.7;//人物的缩放比
    private var resourceloadend:Bool! = false;
    private var prevosFangxiang:PeopleMoveFangxiang!;//上一次人物移动的方向
    
    private var fangxiangHandler:SKSpriteNode!;//方向手柄
    private var fangxiangPoint:SKShapeNode!;//手柄上的点
    
    private var upSK:SKAction!;
    private var downSK:SKAction!;
    private var leftSK:SKAction!;
    private var rightSK:SKAction!;
    private var upTexts:[SKTexture]!;
    private var downTexts:[SKTexture]!;
    private var leftTexts:[SKTexture]!;
    private var rightTexts:[SKTexture]!;
    private var moveFrameRate:NSTimeInterval! = 1/8;
    override func didMoveToView(view: SKView) {
        
        if(!isInited)
        {
            sceneInit();
            isInited = true;
        }
        
    }
    
    private func sceneInit()
    {
        self.backgroundColor = UIColor.blackColor();
        self.scaleMode = .ResizeFill;
        
        prevosFangxiang = PeopleMoveFangxiang.normal;
        peopleTexts = SKTextureAtlas(named: "renwu1.atlas");
        peopleTexts.preloadWithCompletionHandler { () -> Void in
            self.resourceloadend = true;
            //初始化人物
            self.peopleNode = SKSpriteNode(texture: self.peopleTexts.textureNamed("a_0.png"));
            self.peopleNode.position = CGPoint(x: CGRectGetMidX((self.view?.frame)!), y: CGRectGetMidY((self.view?.frame)!));
            self.addChild(self.peopleNode);
            self.peopleNode.xScale = self.peopleNodeScale;
            self.peopleNode.yScale = self.peopleNodeScale;
        }
        //初始化方向盘
        fangxiangHandler = SKSpriteNode(color: UIColor.clearColor(), size: CGSize(width: 100, height: 100));
        let fangxiangHandlerbg:SKShapeNode = SKShapeNode(circleOfRadius: 50);
        fangxiangHandlerbg.fillColor = UIColor.grayColor().colorWithAlphaComponent(0.5);
        fangxiangHandlerbg.lineWidth = 0;
        fangxiangHandler.addChild(fangxiangHandlerbg);
        
        fangxiangHandler.position = CGPoint(x: 80, y: 80);
        fangxiangHandler.zPosition = 1000;
        self.addChild(fangxiangHandler);
        
        
        //给方向盘添加边缘检测
        let arcP = CGPathCreateMutable();
        CGPathAddArc(arcP, nil, 0, 0, 50, 0, CGFloat(M_PI)*2, true);
        fangxiangHandler.physicsBody = SKPhysicsBody(edgeLoopFromPath: arcP);
        fangxiangHandler.physicsBody?.usesPreciseCollisionDetection = true;
        
        
        //添加方向盘上的按钮
        fangxiangPoint = SKShapeNode(circleOfRadius: 15);
        fangxiangPoint.fillColor = UIColor.grayColor().colorWithAlphaComponent(0.8);
        fangxiangPoint.lineWidth = 0;
        fangxiangPoint.physicsBody = SKPhysicsBody(circleOfRadius: 15);
        fangxiangPoint.physicsBody?.affectedByGravity = false;
        fangxiangPoint.physicsBody?.usesPreciseCollisionDetection = true;
        fangxiangHandler.addChild(fangxiangPoint);
        
        //初始化移动方向动画
        upTexts = [peopleTexts.textureNamed("a_12.png"),peopleTexts.textureNamed("a_13.png"),peopleTexts.textureNamed("a_14.png"),peopleTexts.textureNamed("a_15.png")];
        downTexts = [peopleTexts.textureNamed("a_0.png"),peopleTexts.textureNamed("a_1.png"),peopleTexts.textureNamed("a_2.png"),peopleTexts.textureNamed("a_3.png")];
        leftTexts = [peopleTexts.textureNamed("a_4.png"),peopleTexts.textureNamed("a_5.png"),peopleTexts.textureNamed("a_6.png"),peopleTexts.textureNamed("a_7.png")];
        rightTexts = [peopleTexts.textureNamed("a_8.png"),peopleTexts.textureNamed("a_9.png"),peopleTexts.textureNamed("a_10.png"),peopleTexts.textureNamed("a_11.png")];
        
        upSK = SKAction.repeatActionForever(SKAction.animateWithTextures(upTexts, timePerFrame: moveFrameRate, resize: true, restore: true));
        leftSK = SKAction.repeatActionForever(SKAction.animateWithTextures(leftTexts, timePerFrame: moveFrameRate, resize: true, restore: true));
        
        rightSK = SKAction.repeatActionForever(SKAction.animateWithTextures(rightTexts, timePerFrame: moveFrameRate, resize: true, restore: true));
        downSK = SKAction.repeatActionForever(SKAction.animateWithTextures(downTexts, timePerFrame: moveFrameRate, resize: true, restore: true));
        
        
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        moveFangXiangPoint(touches);
    }
    
    private var tempPAng:CGFloat! = 0;
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        moveFangXiangPoint(touches);
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        fangxiangPoint.position.x = 0;
        fangxiangPoint.position.y = 0;
        beginPeopleAni(gGetFangxiang());
    }
    
    //手柄上的控制点跟随手指移动
    private func moveFangXiangPoint(touches: Set<UITouch>)
    {
        let p = (touches.first?.locationInNode(fangxiangHandler))!;
        // NSLog("\(atan2(p.y, p.x) * 180 / CGFloat(M_PI))");
        if(sqrt(pow(p.x, 2) + pow(p.y, 2)) > 35){
            tempPAng = atan2(p.y, p.x);
            fangxiangPoint.position.x = cos(tempPAng) * 35;
            fangxiangPoint.position.y = sin(tempPAng) * 35;
        }else{
            fangxiangPoint.position = p;
        }
        
        beginPeopleAni(gGetFangxiang());
    }
    
    /**
     通过弧度获取移动方向
     */
    private func gGetFangxiang()-> PeopleMoveFangxiang
    {
        if(fangxiangPoint.position == CGPointZero)
        {
            return .normal;
        }else{
            tempPAng = atan2(fangxiangPoint.position.y, fangxiangPoint.position.x) * 180 / CGFloat(M_PI)
            if(tempPAng >= -45 && tempPAng < 45)
            {
                return .right;
            }else if(tempPAng >= 45 && tempPAng < 135)
            {
                return .up;
            }else if(tempPAng >= -135 && tempPAng < -45)
            {
                return .down;
            }else{
                return .left;
            }
        }
        
    }
    
    /**
     移动人物
     */
    private func beginPeopleAni(fangxiang:PeopleMoveFangxiang)
    {
        //如果方向没有发生变化，则不停止当前的动画
        if(prevosFangxiang == fangxiang)
        {
            return ;
        }
        peopleNode.removeActionForKey("peopleMove");
        switch(fangxiang)
        {
        case .up:
            peopleNode.runAction(upSK, withKey: "peopleMove");
            break;
        case .down:
            peopleNode.runAction(downSK, withKey: "peopleMove");
            break;
        case .left:
            peopleNode.runAction(leftSK, withKey: "peopleMove");
            break;
        case .right:
            peopleNode.runAction(rightSK, withKey: "peopleMove");
            break;
        default:
            peopleNode.texture = getTextureByFangxiang(prevosFangxiang);
            peopleNode.size.width = peopleNode.texture!.size().width * peopleNodeScale;
            peopleNode.size.height = peopleNode.texture!.size().height * peopleNodeScale;
            break;
        }
        prevosFangxiang = fangxiang;
    }
    
    private func getTextureByFangxiang(fangxiang:PeopleMoveFangxiang)->SKTexture
    {
        if(fangxiang == .up)
        {
            return upTexts[0];
        }else if(fangxiang == .right)
        {
            return rightTexts[0];
        }else if(fangxiang == .left)
        {
            return leftTexts[0];
        }else{
            return downTexts[0];
        }
    }
    
    
    override func update(currentTime: NSTimeInterval) {
        
    }
}

enum PeopleMoveFangxiang:Int{
    case normal = 0
    case up = 1
    case left = 2
    case down = 3
    case right = 4
}