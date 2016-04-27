// import std.stdio;
import std.file;
import std.algorithm;

import vibe.d;
immutable string content_type = "text/html; charset=UTF-8";

void renderMd(HTTPServerRequest req, HTTPServerResponse res) {
  string docparam = req.params["doc"];

  // HACK: How fast is this?
  string file = "files/" ~ (docparam[$-3..$] == ".md" ? docparam : docparam ~ ".md");
  logInfo("looking for: %s", file);
  // Good to render it!
  //TODO: switch all functions to vibe.d functions
  if (exists(file) && isFile(file) ) {
    // string pagename = docparam;
    const string content = filterMarkdown(readFileUTF8(file));
    res.render!("markdownview.dt", docparam, content);
    // res.writeBody(filterMarkdown(readFileUTF8(file)), content_type);
  } else {
    res.statusCode = 404;
    res.writeBody("<h1>404!: %s could not be found</h1>".format(file), content_type);
  }
}

void showMainPage(HTTPServerRequest req, HTTPServerResponse res) {
  shared FileInfo[] infos;
  listDirectory("files", (FileInfo info) {infos ~= info; return true; });
  logInfo("have [%3d] files", infos.length);
  res.render!("basicpage.dt", infos);
}

static this()  {
  auto router = new URLRouter();
  router.get("/", &showMainPage);
  router.get("/md/:doc", &renderMd);
  auto settings = new HTTPServerSettings;
  settings.port = 8081;
  settings.bindAddresses = ["::1", "127.0.0.1"];
  listenHTTP(settings, router);
}
