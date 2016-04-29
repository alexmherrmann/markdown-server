import vibe.vibe;
import support;
import std.file;
void renderMd(HTTPServerRequest req, HTTPServerResponse res) {
  string docparam = req.params["doc"];

  string file;
  // HACK: How fast is this?
  if(docparam.length <= 3)
    file = docparam ~ ".md";
  else
    file = "files/" ~ (docparam[$-3..$] == ".md" ? docparam : docparam ~ ".md");
  logInfo("looking for: %s", file);
  // Good to render it!
  //TODO: switch all functions to vibe.d functions
  if (exists(file) && isFile(file) ) {
    const string content = filterMarkdown(readFileUTF8(file));
    res.render!("markdownview.dt", docparam, content);
  } else {
    return404(res);
  }
}
