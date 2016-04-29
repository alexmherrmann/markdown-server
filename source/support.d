import vibe.vibe;

void return404(ref HTTPServerResponse res) {
    res.statusCode = 404;
    res.render!("missing.dt");
}
