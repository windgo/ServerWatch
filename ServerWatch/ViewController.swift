//
//  ViewController.swift
//  ServerWatch
//
//  Created by qi on 16/1/7.
//  Copyright © 2016年 im.windgo. All rights reserved.
//

import Cocoa
enum WWServerStatus:Int {
    case Unkown
    case Ok
    case Error
}
class ViewController: NSViewController {
    
    @IBOutlet weak var stateLabel: NSTextField!
    
    
    var serverStatus = WWServerStatus.Unkown
    var timer:NSTimer!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        showStatus()
        
        timer=NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: "requestStatus:", userInfo: nil, repeats: true)
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    func showStatus(){
        let statusMessage = [WWServerStatus.Unkown:"服务器状态：未知",
            WWServerStatus.Ok:"服务器状态：正常",
            WWServerStatus.Error:"服务器状态：错误",
        ]
        
        let statusColor = [WWServerStatus.Unkown:NSColor.blackColor(),
            WWServerStatus.Ok:NSColor.greenColor(),
            WWServerStatus.Error:NSColor.redColor()
        ]
        
        stateLabel.textColor=statusColor[self.serverStatus]
        stateLabel.stringValue = statusMessage[self.serverStatus]!
        
    }
    
    func requestStatus(sender:AnyObject!){
         let session=NSURLSession(configuration: NSURLSessionConfiguration.ephemeralSessionConfiguration())
         // 设置自己的测试用链接
        let request=NSURLRequest(URL: NSURL(string:"http://apitest.hahaha.com/homepage")!)
        let task=session.downloadTaskWithRequest(request) { (url:NSURL?, response:NSURLResponse?, error:NSError?) -> Void in
            if error != nil || (response as! NSHTTPURLResponse).statusCode != 200 {
                if self.serverStatus != WWServerStatus.Error {
                    let notice=NSUserNotification()
                    notice.title="错误：apitest"
                    NSUserNotificationCenter.defaultUserNotificationCenter().deliverNotification(notice)
                }
                self.serverStatus=WWServerStatus.Error
            }
            else{
                if self.serverStatus != WWServerStatus.Ok {
                    let notice=NSUserNotification()
                    notice.title="正常：apitest"
                    NSUserNotificationCenter.defaultUserNotificationCenter().deliverNotification(notice)
                }

                self.serverStatus=WWServerStatus.Ok
            }
            self.showStatus()
        }
        task.resume()
    }


}

