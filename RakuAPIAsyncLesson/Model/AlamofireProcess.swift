//
//  AlamofireProcess.swift
//  RakuAPIAsyncLesson
//
//  Created by UrataHiroki on 2021/11/22.
//

import Alamofire
import SwiftyJSON

class AlamofireProcess{

    public var getDataResultArray = [GetDataDetailModel]()
    private var keyword:String?
    
    init(getKey:String?){
        
        keyword = getKey
    }
}

extension AlamofireProcess{
    
    public func getItemDetailData(completion: @escaping() -> Void){
        
        guard let key = keyword else { return }
        
        let apiKey = "https://app.rakuten.co.jp/services/api/IchibaItem/Search/20170706?format=json&keyword=\(key.urlEncoded)&アプリID"
        
        AF.request(apiKey, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON {[self] response in
            
            switch response.result{
                
            case .success:
                
                let jsonDetail = JSON(response.data as Any)
                getDataResultArray = []
                
                for dataCount in 0..<jsonDetail["Items"].count{
                    
                    if let getMediumImageURL = jsonDetail["Items"][dataCount]["Item"]["mediumImageUrls"][0]["imageUrl"].string,
                       let getItemName = jsonDetail["Items"][dataCount]["Item"]["itemName"].string,
                       let getItemPrice = jsonDetail["Items"][dataCount]["Item"]["itemPrice"].int,
                       let getItemCaption = jsonDetail["Items"][dataCount]["Item"]["itemCaption"].string{
                        
                        getDataResultArray.append(GetDataDetailModel(mediumImageURL: getMediumImageURL,
                                                                     itemName: getItemName,
                                                                     itemPrice: getItemPrice,
                                                                     itemCaption: getItemCaption))
                    }
                    
                }
                completion()
               
            case .failure:
                
                completion()
            }
        }
    }
}


extension String{

    var urlEncoded:String{

        let charset = CharacterSet.alphanumerics.union(.init(charactersIn: "/?-._~"))
        let remove = removingPercentEncoding ?? self

        return remove.addingPercentEncoding(withAllowedCharacters: charset) ?? remove
    }
}

