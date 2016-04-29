# markdown-server
Created by Alex Herrmann

### Tiny little markdown server
Pretty self explanatory, any markdown file (.md) file in `files` will be rendered to markdown
on the fly and returned on the `/md/:filename` endpoint. All files in `public` will be returned
as is on `public/:filename`. Public will also do some checking, and change content_type.

Here is the mapping for filename extension to content_type:
* .css --> text/css
* TODO: .js --> application/javascript
* images...


### Layout
d source files are inside the `source/` folder.

* app.d is the main entry point
* markdown.d is the markdown function, and contains everything for `/md`
* publicget.d has the function for `/public`
* support.d has some helper functions

### Future
Add a caching system for rendered markdown pages and files in /public! This would probably
use redis, and would use a directory watcher to keep the redis copy always fresh.

One day, it would be cool to have an editor built in to modify these files, and to possibly
switch over to mongodb or sql for the long term document storage. All just for fun and
as a learning experience.

Also, [vuejs](https://vuejs.org) as a frontend for the server, using webpack, etc.
