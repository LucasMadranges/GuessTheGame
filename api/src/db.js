const fs = require('fs');
const path = require('path');
const Database = require('better-sqlite3');

const dbPath = process.env.DB_PATH || path.join(__dirname, '..', 'data', 'data.db');
const dataDir = path.dirname(dbPath);
if (!fs.existsSync(dataDir)) fs.mkdirSync(dataDir, { recursive: true });

const db = new Database(dbPath);
db.pragma('journal_mode = WAL');
db.pragma('foreign_keys = ON');

db.exec(`
  CREATE TABLE IF NOT EXISTS items (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    description TEXT DEFAULT '',
    updated_at TEXT NOT NULL
  );
  CREATE INDEX IF NOT EXISTS idx_items_updated_at ON items(updated_at DESC);
`);

const stmtList = db.prepare('SELECT * FROM items ORDER BY id DESC');
const stmtGet = db.prepare('SELECT * FROM items WHERE id = ?');
const stmtInsert = db.prepare('INSERT INTO items (name, description, updated_at) VALUES (?, ?, ?)');
const stmtUpdate = db.prepare(`
  UPDATE items
  SET name = COALESCE(?, name),
      description = COALESCE(?, description),
      updated_at = ?
  WHERE id = ?
`);
const stmtDelete = db.prepare('DELETE FROM items WHERE id = ?');

const listItems = () => stmtList.all();
const getItem = (id) => stmtGet.get(id);
const createItem = ({ name, description = '' }) => {
    const now = new Date().toISOString();
    const info = stmtInsert.run(name, description, now);
    return getItem(info.lastInsertRowid);
};
const updateItem = (id, patch) => {
    const now = new Date().toISOString();
    const res = stmtUpdate.run(
        patch.name ?? null,
        patch.description ?? null,
        now,
        id
    );
    if (res.changes === 0) return null;
    return getItem(id);
};
const deleteItem = (id) => stmtDelete.run(id).changes > 0;

module.exports = { listItems, getItem, createItem, updateItem, deleteItem };
