import vibe.vibe;

import std.array;
import std.algorithm;
import std.path;
import std.file : getcwd;
import std.conv: to;

void return404(ref HTTPServerResponse res) {
    res.statusCode = 404;
    res.render!("otherpages/missing.dt");
}

bool isUnder(string path, string under = getcwd()) {
  auto length = under.length;

  if(path.length <= under.length) return false;
  if(asAbsolutePath(path)[0..length].to!string != under[0..length]) return false;

  // fall through
  return true;
}

unittest {
  assert(isUnder("support.d"));
  assert(isUnder("markdown.d"));
  assert(isUnder("markdown."));

  assert(!isUnder("../public/main.css"));
  assert(!isUnder("/public/main.css"));

}

// TODO: Ugh... do I even need this when it's URL slugs?
bool isSafe(string path, string under = getcwd()) {
  if(path[0] == '/' || path[0] == '~') {
    return false;
  }

  // un-uh, none of that in here
  if(path.canFind("..")) {
    return false;
  }

  if(isUnder(path, under)) {
    return false;
  }

  // finally, is it a valid path?
  return isValidPath(path);
}

unittest {
  //non-safe
  assert(!isSafe("/home/alex/secret.txt"));
  assert(!isSafe("//home/alex/secret.txt"));
  assert(!isSafe("../secret.txt"));

  // safe
  assert(isSafe("secret.txt"));
  assert(isSafe("home/alex/secret.txt"));
}
