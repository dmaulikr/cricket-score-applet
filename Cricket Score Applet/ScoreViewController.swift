//
//  ScoreViewController.swift
//  Cricket Score Applet
//
//  Created by Adhithyan Vijayakumar on 19/03/16.
//  Copyright © 2016 Adhithyan Vijayakumar. All rights reserved.
//

import Cocoa

class ScoreViewController: NSViewController, NSXMLParserDelegate {
    @IBOutlet var scoreCard: NSTextField!
    

    var parser = NSXMLParser()
    var posts = NSMutableArray()
    var content = NSMutableString()
    var currentItem = ""
    var itemCount = 0
    var appendCount = 0
    var currentScoreIndex: Int = 0{
        didSet{
            updateScore()
        }
    }
    //let scores = Score.all
    //viewdidload is available only on 10.10 and later
    override func viewDidLoad() {
        if #available(OSX 10.10, *) {
            super.viewDidLoad()
            
        } else {
            // Fallback on earlier versions
        }
        self.beginParsing()
        updateScore()
    }
    
    
    func beginParsing(){
        posts = []
        parser = NSXMLParser(contentsOfURL: NSURL(string:"http://live-feeds.cricbuzz.com/CricbuzzFeed?format=xml")!)!
        parser.delegate = self
        parser.parse()
    }
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
    
        if(elementName == "item"){
            itemCount++;
            content = NSMutableString()
        }
        
        switch(elementName){
            case "title":
                currentItem = "title"
                break
            case "description":
                currentItem = "description"
                break
            case "link":
                currentItem = "link"
                break
            default:
                break
        }
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        if(elementName == "item"){
            itemCount--;
            currentItem = ""
            appendCount = 0
            posts.addObject(content)
        }
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        
        if(itemCount == 1){
            if(currentItem == "title" || currentItem == "description"){
                
                if(appendCount < 3){
                    content.appendString(string)
                }
                appendCount++;
            }
        }
    }
    
    func updateScore(){
        scoreCard.stringValue = String(posts[currentScoreIndex])
    }
    
    func removeHtml(string: String){
        
    }
}

extension ScoreViewController{
    @IBAction func goLeft(sender: NSButton){
        currentScoreIndex = (currentScoreIndex - 1 + posts.count) % (posts.count)
    }
    
    @IBAction func goRight(sender: NSButton){
        currentScoreIndex = (currentScoreIndex + 1) % (posts.count)
    }
    
    @IBAction func refresh(sender: NSButton){
        beginParsing()
        updateScore()
    }
}



