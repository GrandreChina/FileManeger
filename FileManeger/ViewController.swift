//
//  ViewController.swift
//  FileManeger
//
//  Created by Grandre on 16/3/17.
//  Copyright © 2016年 革码者. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let fileManager = NSFileManager.defaultManager()
    let fileManager2 = NSFileManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDocumentPath()
        getLibraryPath()
        getCachePath()
        getTempPath()
        creatDirectory()
        creatFile()
        fileIsExist()
        item操作()
        readFile()
        
    }
 
    /**
     NSSearchPathDirectory.DocumentDirectory 查找Documents文件夹
     NSSearchPathDomainMask.UserDomainMask 在用户的应用程序下查找
     true 展开路径   false 当前应用的根路径 == “~”
     */
    func getDocumentPath(){
// 第一种获取路径方式
        let HomePath = NSHomeDirectory()
        print(HomePath)
        
        let docPATH = HomePath + "/Documents"  //cache 和library也可这样拼接
        print(docPATH)
// 第二种获取路径方式
        let pathArr =  NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let documentPath = pathArr[0] as String
        print(documentPath)
// 第三种获取路径方式
        let urls = fileManager.URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask) as [NSURL]
        if urls.count > 0{
            print("--------\(urls[0])")
            print("--------\(urls)")
        }
// 第四种获取路径方式
        do{
        let url = try fileManager.URLForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomain: NSSearchPathDomainMask.UserDomainMask, appropriateForURL: nil, create: false)
        print("--------\(url)")
        }catch{
            
        }
    }

    func getLibraryPath(){
        let libtraryPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.LibraryDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] as String
        print(libtraryPath)
    }
    
    func getCachePath(){
        let cachePath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] as String
        print(cachePath)
    }
    
    func getTempPath(){
        let tempPath = NSTemporaryDirectory()
        print(tempPath)
        
        let homePath = NSHomeDirectory()
        let tempPath1 = homePath + "/tmp/"
        print(tempPath1)
    }
    
    func creatDirectory()->String{
        let documentPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] as String
//如果转成string，则可以直接用 + “/grandre”
        let documentPathGrandre = (documentPath as NSString).stringByAppendingPathComponent("/grandre")
        
        let documentPath2 = documentPath + "/grandre1/grandre2"
        
//withIntermediateDirectories 设置为true， 代表中间所有的路径目录如果不存在，都会创建
        do{
            try NSFileManager.defaultManager().createDirectoryAtPath(documentPathGrandre, withIntermediateDirectories: true, attributes: nil)
            try NSFileManager.defaultManager().createDirectoryAtPath(documentPath2, withIntermediateDirectories: true, attributes: nil)
            
        }catch{
            print("创建目录出错")
        }
        return documentPath2
    }
    
    func creatFile(){
// 创建file第一种方式。通过写入content来创建新文件。
        let filePath = creatDirectory() + "/gr.text"
        let content = "hello grandre"
        do{
          try content.writeToFile(filePath, atomically: true, encoding: NSUTF8StringEncoding)
        }catch{
            print("创建文件失败")
        }
// 创建file第二种方式。
        let filePath2 = creatDirectory() + "/gr2.text"
       let result = NSFileManager.defaultManager().createFileAtPath(filePath2, contents: nil, attributes: nil)
        if result{
            print("success creat file ")
        }else{
            print("error creat file")
        }
        
    }
    
    func fileIsExist(){
//用来判断文件或者目录是否存在
        if fileManager.fileExistsAtPath(creatDirectory() + "/gr2.text"){
            print("存在/gr2.text")
        }
        if fileManager.fileExistsAtPath(creatDirectory()){
            print("存在目录\(creatDirectory())")
        }
    }
    
    func item操作(){
//移动目录，dest路径中必须包含目录名，当然顺便可以更改目录名。
        let documentsUrl = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        let destUrl = documentsUrl as String + "/grandre2"
        
        do{
           try fileManager.moveItemAtPath(creatDirectory(), toPath: destUrl)
        }catch{
          print("move directory error")
        }
        
//移动文件，dest路径中必须包含目录名，当然顺便可以更改文件名。
        do{
            try fileManager.moveItemAtPath(destUrl+"/gr.text", toPath: documentsUrl as String + "/grandre1/gr1.text")
        }catch{
            print("move file error")
        }
//复制文件，也可更名
        do{
            try fileManager.copyItemAtPath(documentsUrl as String + "/grandre1/gr1.text", toPath: documentsUrl as String + "/grandre/gr1.text")
        }catch{
            print("copy file error")
        }
//复制目录，也可更名
        do{
            try fileManager.copyItemAtPath(documentsUrl as String + "/grandre1", toPath: documentsUrl as String + "/grandre3")
        }catch{
            print("copy directory error")
        }
        do{
            try fileManager.copyItemAtPath(documentsUrl as String + "/grandre1", toPath: documentsUrl as String + "/grandre3/grandre1")
        }catch{
            print("copy directory error")
        }
//获取指定路径下的所有目录和文件，递归，深度。也即是下一级的子目录子文件也会被列出来。
        let itemGetArr1 = fileManager.subpathsAtPath(documentsUrl)
        print(itemGetArr1)
        
        let itemGetArr2 = try? fileManager.subpathsOfDirectoryAtPath(documentsUrl)
        print(itemGetArr2)
//只获取指定目录下的目录。而且非递归。浅度。
        let itemGetArr3 = try? fileManager.contentsOfDirectoryAtPath(documentsUrl)
        print(itemGetArr3)
//获取指定目录下的所有文件和目录，递归，深度。返回的是NSDirectoryEnumerator。
        let itemGetArr4 = fileManager.enumeratorAtPath(documentsUrl)
        for i in itemGetArr4!{
            print(i)
        }
//获取指定item(目录或者文件)的属性。
        let itemAttributes = try?fileManager.attributesOfItemAtPath(documentsUrl)
        print(itemAttributes)
        
        let itemAttributes1 = try?fileManager.attributesOfItemAtPath(documentsUrl+"/grandre/gr1.text")
        print(itemAttributes1)
//删除指定item(目录或者文件)
        try?fileManager.removeItemAtPath(documentsUrl+"/grandre3/grandre1")
        
//比较两个文件是否相同
        if fileManager.contentsEqualAtPath(documentsUrl+"/grandre1/gr1.text", andPath: documentsUrl+"/grandre3/gr1.text"){
            print("two files are the same")
            NSLog("two files are the same")
        }
    }
    
    func readFile(){
//只能读取文件的内容，不能读取目录的内容
//第一种读取方式
        let documentsUrl = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        do{
            let content = try?NSString(contentsOfFile: documentsUrl + "/grandre1/gr1.text", encoding: NSUTF8StringEncoding)
            print(content)
        }catch{
            print("read file error")
        }
//第二种读取方式
        let content1 = fileManager.contentsAtPath(documentsUrl + "/grandre1/gr1.text")
        let result1 = NSString(data: content1!, encoding: NSUTF8StringEncoding)
        print(result1)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
// Dispose of any resources that can be recreated.
    }


}

