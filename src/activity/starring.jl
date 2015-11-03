
# Interface -------

function stargazers(owner, repo; auth = AnonymousAuth(), options...)
    stargazers(auth, owner, repo; options...)
end

function stargazers(auth::Authorization, owner, repo; per_page = 30, headers = Dict(), result_limit = -1, options...)
    authenticate_headers!(headers, auth)
    query = Compat.@compat Dict("per_page" => per_page)
    uri = api_uri("/repos/$owner/$repo/stargazers")
    pages = get_pages(uri, result_limit, per_page; headers = headers, query = query, options...)
    items = get_items_from_pages(pages)
    return User[User(i) for i in items]
end


function starred(user; auth = AnonymousAuth(), options...)
    starred(auth, user; options...)
end

function starred(auth::Authorization, user; headers = Dict(),
                                            query = Dict(),
                                            sort = nothing,
                                            direction = nothing,
                                            result_limit = -1,
                                            options...)
    authenticate_headers!(headers, auth)

    sort != nothing && (query["sort"] = sort)
    direction != nothing && (query["direction"] = direction)

    uri = api_uri("/users/$user/starred")
    pages = get_pages(uri, result_limit; query = query, headers = headers, options...)
    items = get_items_from_pages(pages)
    return Repo[Repo(i) for i in items]
end


function star(owner, repo; auth = AnonymousAuth(), options...)
    star(auth, owner, repo; options...)
end

function star(auth::Authorization, owner, repo; headers = Dict(), options...)
    authenticate_headers!(headers, auth)
    uri = api_uri("/user/starred/$owner/$repo")
    r = Requests.put(uri; headers = headers, data = "{}", options...)
    handle_error(r)
end


function unstar(owner, repo; auth = AnonymousAuth(), options...)
    unstar(auth, owner, repo; options...)
end

function unstar(auth::Authorization, owner, repo; headers = Dict(), options...)
    authenticate_headers!(headers, auth)
    uri = api_uri("/user/starred/$owner/$repo")
    r = Requests.delete(uri; headers = headers, options...)
    handle_error(r)
end
