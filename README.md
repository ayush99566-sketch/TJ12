# Tournival Journeys

Single-page site for tournivaljourneys.com (static `index.html` + `assets/`), with a Vercel serverless function (`api/instagram.js`) that feeds the homepage Instagram strip.

## Deploy (Vercel)
1. Import this repo in Vercel (framework preset: **Other**, no build command, output directory: root).
2. Add the environment variable `INSTAGRAM_ACCESS_TOKEN` (see `docs-instagram.md`). Never commit it.
3. Add the custom domain under Project -> Settings -> Domains.

Every push to `main` redeploys automatically.
