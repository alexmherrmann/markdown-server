// import std.stdio;
import std.file;
import std.algorithm;

import vibe.d;
immutable string content_type = "text/html; charset=UTF-8";

import publicget;
import markdown;
import support;

void showMainPage(HTTPServerRequest req, HTTPServerResponse res) {
  // TODO: use std.file
  shared FileInfo[] infos;
  listDirectory("files", (FileInfo info) {infos ~= info; return true; });
  logInfo("have [%3d] files", infos.length);
  res.render!("basicpage.dt", infos);
}

static this()  {
  auto router = new URLRouter();
  router.get("/", &showMainPage);
  router.get("/md/:doc", &renderMd);
  router.get("/public/:filename", &getPublic);
  auto settings = new HTTPServerSettings;
  settings.port = 8081;
  settings.bindAddresses = ["::1", "127.0.0.1"];
  listenHTTP(settings, router);
}
