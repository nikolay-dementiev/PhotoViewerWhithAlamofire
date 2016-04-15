//
//  JSONWork.swift
//  PhotoViewerWhithAlamofire
//
//  Created by mc373 on 13.04.16.
//  Copyright © 2016 mc373. All rights reserved.
//

import Alamofire

class JSONWork {
    
    //    static func setRouter(imageSize:Five100px.ImageSize) -> (URLString: URLStringConvertible, parameters: [String : AnyObject]) {
    //
    //        let URL = NSURL(string: GeneralValues.urlOf500px+"/photos")!
    ////        let request = NSMutableURLRequest(URL: URL)
    //
    //       let parameters:[String : AnyObject] = ["consumer_key": GeneralValues.consumer_keyFor500px, "image_size":String(imageSize.rawValue), "page": "\(GeneralValues.pageToLoad)", "feature":GeneralValues.feature]
    ////        let encoding = Alamofire.ParameterEncoding.URL
    ////
    ////        return encoding.encode(request, parameters: parameters)
    //        return (URL, parameters)
    //    }
    
    
    
    
    //    static func getJSONDataFromURl (imageSize:Five100px.ImageSize, callback: ((data:[PhotoInfo]) -> Void)) {
    //
    //        Alamofire.request(.GET, GeneralValues.urlOf500px+"/photos", parameters: ["consumer_key": GeneralValues.consumer_keyFor500px, "image_size":String(imageSize.rawValue), "page": "\(GeneralValues.pageToLoad)", "feature":GeneralValues.feature]).responseJSON() {
    //
    //            response in switch response.result {
    //            case .Success(let JSONData):
    //                // print("Success with JSON: \(JSONData)")
    //
    //                let JSON = JSONData as! NSDictionary
    //
    //                let photoInfos = (JSON.valueForKey("photos") as! [NSDictionary]).filter({
    //                    ($0["nsfw"] as! Bool) == false
    //                }).map {
    //                    PhotoInfo(id: $0["id"] as! Int, url: $0["image_url"] as! String)
    //                }
    //
    //                callback(data: photoInfos)
    //
    //            case .Failure(let error):
    //                print("Request failed with error: \(error)")
    //            }
    //        }
    //    }
    
    
    static func getJSONDataFromURl (Router:Router500px, callback: ((data:[PhotoInfo]) -> Void)) {
        
        Alamofire.request(.GET, Router.urlToConnect, parameters: Router.parametersToConnect).responseJSON() {
            
            response in switch response.result {
            case .Success(let JSONData):
                // print("Success with JSON: \(JSONData)")
//                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
                
                    let JSON = JSONData as! NSDictionary
                    let photoInfos = getPhotoInfoArrayFromData (JSON)
                    
                    callback(data: photoInfos)
//                }
            case .Failure(let error):
                print("Request failed with error: \(error)")
            }
        }
    }
    
    static func getPhotoInfoArrayFromData (JSON:NSDictionary) -> [PhotoInfo]{
        
        var photoInfos:[PhotoInfo] = []
        
        let valueForOne     = JSON.valueForKey("photo")
        let valueFoArray    = JSON.valueForKey("photos")
        
        if valueFoArray != nil {
            
            photoInfos = (valueFoArray as! [NSDictionary]).filter({
                ($0["nsfw"] as! Bool) == false
            }).map {
                PhotoInfo(id: $0["id"] as! Int, url: $0["image_url"] as! String)
            }
        } else {
            let photoInfoElement = PhotoInfo(id: valueForOne!["id"] as! Int, url: valueForOne!["image_url"] as! String)
            photoInfos.append(photoInfoElement)
        }
        
        
        return photoInfos
    }
    
    static func getImageFromJSONData (imageURL:String, callBack: ((Image: UIImage) -> Void)) {
        
        Alamofire.request(.GET, imageURL).responseData	() {
            response in switch response.result {
            case .Success(let URLData):
                
                let image = UIImage(data: URLData)
                
                callBack(Image: image!)
            case .Failure(let error):
                print("Request failed with error: \(error)")
            }
        }
    }
    
    static func getImageFromJSONData (Router:Router500px, callBack: ((Image: UIImage) -> Void)) {
        
         getJSONDataFromURl(Router) {(photoInfos) -> Void in
            if photoInfos.count > 0 {
                
                let firstElem = photoInfos[0]
                
                getImageFromJSONData (firstElem.url, callBack: callBack)
            }
        }
    }
    
    
}