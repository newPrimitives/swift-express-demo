//
//  main.swift
//
//  Copyright © 2015-2016 Daniel Leping (dileping). All rights reserved.
//

import Express
import BrightFutures

let app = express()

app.views.register(StencilViewEngine())

app.get("/assets/:file+", action: StaticAction(path: "public", param:"file"))

app.get("/") { (request:Request<AnyContent>) -> Future<Action<AnyContent>, AnyError> in
    return HomeController.fetchData().map { posts in
        Action.render("index", context: ["posts": posts])
    }
}

app.listen(9999).onSuccess { server in
    print("Express was successfully launched on port", server.port)
}

app.run()