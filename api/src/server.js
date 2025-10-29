const express = require("express");
const cors = require("cors");
const morgan = require("morgan");
const db = require("./db");
const {seedPostsIfEmpty} = require("./seed_posts");

const app = express();
const PORT = process.env.PORT || 4000;

app.use(cors());
app.use(express.json());
app.use(morgan("dev"));

app.get("/health", (_req, res) => res.json({status: "ok"}));

/* Items */
app.get("/items", (_req, res) => res.json(db.listItems()));
app.get("/items/:id", (req, res) => {
    const item = db.getItem(Number(req.params.id));
    if (!item) return res.status(404)
                         .json({error: "Not found"});
    res.json(item);
});
app.post("/items", (req, res) => {
    const {name, description = ""} = req.body || {};
    if (!name || typeof name !== "string") {
        return res.status(400)
                  .json({error: "name requis (string)"});
    }
    const created = db.createItem({name, description});
    res.status(201)
       .json(created);
});
app.put("/items/:id", (req, res) => {
    const id = Number(req.params.id);
    const {name, description} = req.body || {};
    if (name !== undefined && typeof name !== "string") {
        return res.status(400)
                  .json({error: "name doit être une string"});
    }
    if (description !== undefined && typeof description !== "string") {
        return res.status(400)
                  .json({error: "description doit être une string"});
    }
    const updated = db.updateItem(id, {name, description});
    if (!updated) return res.status(404)
                            .json({error: "Not found"});
    res.json(updated);
});
app.delete("/items/:id", (req, res) => {
    const ok = db.deleteItem(Number(req.params.id));
    if (!ok) return res.status(404)
                       .json({error: "Not found"});
    res.status(204)
       .send();

    /* Posts (blog) */
});
app.get("/posts", (_req, res) => res.json(db.listPosts()));
app.get("/posts/:id", (req, res) => {
    const post = db.getPost(Number(req.params.id));
    if (!post) return res.status(404)
                         .json({error: "Not found"});
    res.json(post);
});
app.post("/posts", (req, res) => {
    const {title, content, author = "", published_at} = req.body || {};
    if (!title || typeof title !== "string") {
        return res.status(400)
                  .json({error: "title requis (string)"});
    }
    if (!content || typeof content !== "string") {
        return res.status(400)
                  .json({error: "content requis (string)"});
    }
    if (author !== undefined && typeof author !== "string") {
        return res.status(400)
                  .json({error: "author doit être une string"});
    }
    const created = db.createPost({
        title,
        content,
        author,
        publishedAt: typeof published_at === "string" ? published_at : undefined,
    });
    res.status(201)
       .json(created);
});
app.put("/posts/:id", (req, res) => {
    const id = Number(req.params.id);
    const {title, content, author} = req.body || {};
    if (title !== undefined && typeof title !== "string") {
        return res.status(400)
                  .json({error: "title doit être une string"});
    }
    if (content !== undefined && typeof content !== "string") {
        return res.status(400)
                  .json({error: "content doit être une string"});
    }
    if (author !== undefined && typeof author !== "string") {
        return res.status(400)
                  .json({error: "author doit être une string"});
    }
    const updated = db.updatePost(id, {title, content, author});
    if (!updated) return res.status(404)
                            .json({error: "Not found"});
    res.json(updated);
});
app.delete("/posts/:id", (req, res) => {
    const ok = db.deletePost(Number(req.params.id));
    if (!ok) return res.status(404)
                       .json({error: "Not found"});
    res.status(204)
       .send();
});

app.use((_req, res) => res.status(404)
                          .json({error: "Route inconnue"}));

// Seed au démarrage (idempotent)
seedPostsIfEmpty();

app.listen(PORT, () => {
    console.log(`API démarrée sur http://localhost:${PORT} - DB: ${process.env.DB_PATH || "data/data.db"}`);
});