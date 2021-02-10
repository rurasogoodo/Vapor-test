import Vapor
import Fluent

struct BlogCategoryApiController: ListContentController,
                                  GetContentController,
                                  CreateContentController,
                                  UpdateContentController,
                                  PatchContentController,
                                  DeleteContentController
{
    typealias Model = BlogCategoryModel
    
    func get(_ req: Request) throws -> EventLoopFuture<BlogCategoryModel.GetContent> {
        try find(req).flatMap { category in
            BlogPostModel.query(on: req.db)
                .filter(\.$category.$id == category.id!)
                .all()
                .map { posts in
                    var details = category.getContent
                    details.posts = posts.map(\.listContent)
                    return details
                }
        }
    }
    
}
