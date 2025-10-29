const db = require("./db");

function seedPostsIfEmpty() {
    const existing = db.listPosts();
    if (existing.length > 0) {
        console.log(`Déjà ${existing.length} article(s). Seed ignoré.`);
        return;
    }

    const now = new Date().toISOString();
    const posts = [
        {
            title: "Bienvenue sur GuessTheGame",
            content:
                "Découvrez l'app, ses fonctionnalités et les prochaines étapes. Merci d'essayer GuessTheGame !",
            author: "Lucas",
            publishedAt: now,
        },
        {
            title: "Nouveautés de la semaine",
            content:
                "Corrections de bugs, amélioration des performances et premières intégrations du blog.",
            author: "Équipe",
            publishedAt: now,
        },
        {
            title: "Astuces et bonnes pratiques",
            content:
                "Quelques conseils pour profiter au mieux de GuessTheGame et contribuer au projet.",
            author: "Équipe",
            publishedAt: now,
        },
    ];

    for (const p of posts) {
        db.createPost(p);
    }
    console.log(`Inséré ${posts.length} article(s) dans la base.`);
}

module.exports = {seedPostsIfEmpty};