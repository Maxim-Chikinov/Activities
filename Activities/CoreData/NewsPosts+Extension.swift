//
//  NewsPosts+Extension.swift
//  Activities
//
//  Created by Chikinov Maxim on 13.04.2024.
//

import Foundation
import CoreData

public extension NewsPosts {
    internal class func createOrUpdate(item: NewsModelItem) {
        let stack = CoreDataStack.shared
        
        let newsItemID = item.id ?? 0
        var currentNewsPost: NewsPosts?
        
        let newsPostFetch: NSFetchRequest<NewsPosts> = NewsPosts.fetchRequest()
        let newsItemIDPredicate = NSPredicate(format: "%K == %i", #keyPath(NewsPosts.postID), newsItemID)
        newsPostFetch.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [newsItemIDPredicate])
        
        do {
            let results = try stack.managedObjectContext.fetch(newsPostFetch)
            if results.isEmpty {
                // News post not found, create a new.
                currentNewsPost = NewsPosts(context: stack.managedObjectContext)
                currentNewsPost?.postID = Int32(newsItemID)
            } else {
                // News post found, use it.
                currentNewsPost = results.first
            }
            // Update post info
            currentNewsPost?.title = item.title
            currentNewsPost?.image = item.imageURL
            currentNewsPost?.date = item.date
            currentNewsPost?.source = item.source
            currentNewsPost?.url = item.url
        } catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
        }
    }
}
