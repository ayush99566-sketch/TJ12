# Live Instagram feed setup (one-time)

The homepage strip calls /api/instagram (api/instagram.js). It needs one secret:
INSTAGRAM_ACCESS_TOKEN, set in Vercel -> Project -> Settings -> Environment Variables (then Redeploy).
Never paste the token into the website files or share it in chat.

How to get the token (Instagram account must be Business or Creator):
1. developers.facebook.com -> My Apps -> Create App -> type "Business" (or "Other").
2. Add the product "Instagram" -> "API setup with Instagram login".
3. Add your Instagram account (@tourrnivaljourrneys) as an Instagram tester / professional account and accept the invite in the Instagram app (Settings -> Website permissions).
4. In "Generate access tokens" click Generate for your account and copy the token (a long-lived token lasts 60 days).
5. Paste it in Vercel as INSTAGRAM_ACCESS_TOKEN and redeploy.

Refreshing: long-lived tokens expire after 60 days. Refresh before then with
  https://graph.instagram.com/refresh_access_token?grant_type=ig_refresh_token&access_token=YOUR_TOKEN
and update the Vercel variable. Set a calendar reminder every ~50 days.

Until the token is set (or if Instagram is unreachable) the site shows the built-in photos.
New posts appear within about 10 minutes (edge cache).
