module publicget;
import vibe.vibe;
import std.file : exists, read, isFile;
import support;

void getPublic(HTTPServerRequest req, HTTPServerResponse res) {
  string fileparam = req.params["filename"];
  logInfo("have filename: %s", fileparam);

  auto filename = "public/%s".format(fileparam);
  if(exists(filename) && isFile(filename)) {
    string contents = cast(string) read(filename);

    if(filename.length > 4 && filename[$-4..$] == ".css"){
      logInfo("this is CSS");
      res.writeBody(contents, "text/css");
      return;
    }

    res.writeBody(contents);
  }
  else
    return404(res);
}
