// JavaScript
const fs = require("fs");
const path = require("path");
const Database = require("better-sqlite3");

const dbPath = process.env.DB_PATH || path.join(__dirname, "..", "data", "data.db");
const dataDir = path.dirname(dbPath);
if (!fs.existsSync(dataDir)) fs.mkdirSync(dataDir, {recursive: true});

const db = new Database(dbPath);
db.pragma("journal_mode = WAL");
db.pragma("foreign_keys = ON");

db.exec(`
  -- Items
  CREATE TABLE IF NOT EXISTS items (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    description TEXT DEFAULT '',
    updated_at TEXT NOT NULL
  );
  CREATE INDEX IF NOT EXISTS idx_items_updated_at ON items(updated_at DESC);

  -- Posts (articles de blog)
  CREATE TABLE IF NOT EXISTS posts (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL,
    content TEXT NOT NULL,
    author TEXT DEFAULT '',
    published_at TEXT NOT NULL,
    updated_at TEXT NOT NULL
  );
  CREATE INDEX IF NOT EXISTS idx_posts_published_at ON posts(published_at DESC);
`);

/* Items statements */
const stmtItemList = db.prepare("SELECT * FROM items ORDER BY id DESC");
const stmtItemGet = db.prepare("SELECT * FROM items WHERE id = ?");
const stmtItemInsert = db.prepare("INSERT INTO items (name, description, updated_at) VALUES (?, ?, ?)");
const stmtItemUpdate = db.prepare(`
    UPDATE items
    SET name        = COALESCE(?, name),
        description = COALESCE(?, description),
        updated_at  = ?
    WHERE id = ?
`);
const stmtItemDelete = db.prepare("DELETE FROM items WHERE id = ?");

const listItems = () => stmtItemList.all();
const getItem = (id) => stmtItemGet.get(id);
const createItem = ({name, description = ""}) => {
    const now = new Date().toISOString();
    const info = stmtItemInsert.run(name, description, now);
    return getItem(info.lastInsertRowid);
};
const updateItem = (id, patch) => {
    const now = new Date().toISOString();
    const res = stmtItemUpdate.run(
        patch.name ?? null,
        patch.description ?? null,
        now,
        id,
    );
    if (res.changes === 0) return null;
    return getItem(id);
};
const deleteItem = (id) => stmtItemDelete.run(id).changes > 0;

/* Posts statements */
const stmtPostList = db.prepare("SELECT * FROM posts ORDER BY published_at DESC, id DESC");
const stmtPostGet = db.prepare("SELECT * FROM posts WHERE id = ?");
const stmtPostInsert = db.prepare(`
    INSERT INTO posts (title, content, author, published_at, updated_at)
    VALUES (?, ?, ?, ?, ?)
`);
const stmtPostUpdate = db.prepare(`
    UPDATE posts
    SET title      = COALESCE(?, title),
        content    = COALESCE(?, content),
        author     = COALESCE(?, author),
        updated_at = ?
    WHERE id = ?
`);
const stmtPostDelete = db.prepare("DELETE FROM posts WHERE id = ?");

const listPosts = () => stmtPostList.all();
const getPost = (id) => stmtPostGet.get(id);
const createPost = ({title, content, author = "", publishedAt}) => {
    const now = new Date().toISOString();
    const published = publishedAt ?? now;
    const info = stmtPostInsert.run(title, content, author, published, now);
    return getPost(info.lastInsertRowid);
};
const updatePost = (id, patch) => {
    const now = new Date().toISOString();
    const res = stmtPostUpdate.run(
        patch.title ?? null,
        patch.content ?? null,
        patch.author ?? null,
        now,
        id,
    );
    if (res.changes === 0) return null;
    return getPost(id);
};
const deletePost = (id) => stmtPostDelete.run(id).changes > 0;

module.exports = {
    // items
    listItems, getItem, createItem, updateItem, deleteItem,
    // posts
    listPosts, getPost, createPost, updatePost, deletePost,
};