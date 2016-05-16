module publicget;
import vibe.vibe;
import std.file : exists, read, isFile;
import support;

/**
 Get a file from under the /public directory

 */
void getPublic(HTTPServerRequest req, HTTPServerResponse res) {
  string fileparam = req.params["filename"];
  logInfo("have filename: %s", fileparam);

  auto filename = "public/%s".format(fileparam);
  if(exists(filename) && isFile(filename) && isSafe(filename)) {
    string contents = cast(string) read(filename);

    string mime = guessMime(filename);
    res.writeBody(contents, mime);

    res.writeBody(contents);
  }
  else
    return404(res);
}

import std.algorithm;
string guessMime(string filename) {

  auto ending = filename.find(".");
  if(ending.length < 2) {
    return "text/plain";
  }

  switch(ending[1..$]) {
    case "css":
      return "text/css";
    case "js":
      return "application/javascript";
    default:
      return "text/plain";
  }
}

unittest {
  assert(guessMime("ayy.css") == "text/css");
  assert(guessMime("ayy.js") == "application/javascript");
  assert(guessMime("ayy.j") == "text/plain");
  assert(guessMime("ayy.") == "text/plain");
}
