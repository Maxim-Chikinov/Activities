//
//  NewsViewModel.swift
//  Activities
//
//  Created by Chikinov Maxim on 11.04.2024.
//

import UIKit
import Alamofire

protocol NewsViewModelNavigation : AnyObject{
    
}

class NewsViewModel {
    
    weak var coordinator: NewsViewModelNavigation?
    
    let managedObjectContext = CoreDataStack.shared.managedObjectContext
    
    var onGroupsUpdate: (() -> Void)?
    
    init() {
        
    }
    
    func getData() {
        var urlRequest = URLRequest(
            url: URL(string: "https://raw.githubusercontent.com/johncodeos-blog/CoreDataNewsExample/main/news.json")!
        )
        urlRequest.cachePolicy = .reloadIgnoringLocalCacheData
        AF.request(urlRequest).responseDecodable(of: NewsModel.self) { response in
            guard let news = response.value else { return }
            for item in news {
                NewsPosts.createOrUpdate(item: item)
            }
            CoreDataStack.shared.saveContext()
            
            DispatchQueue.main.async {
                self.onGroupsUpdate?()
            }
        }
    }
}

typealias NewsModel = [NewsModelItem]

struct NewsModelItem: Decodable {
    let id: Int?
    let title: String?
    let url: String?
    let imageURL: String?
    let date: String?
    let source: String?

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case url
        case imageURL = "image_url"
        case date
        case source
    }
}
