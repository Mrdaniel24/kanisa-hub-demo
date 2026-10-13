# Kanisa Hub by FocusTec — Demo

Mfumo wa usimamizi wa kanisa (Church Management System) — toleo la **demo** kwa ajili ya wateja wa FocusTec.
Kanisa ndani ya demo ni la mfano: **Kanisa la Neema**. Data zote ni za kubuni.

## Akaunti za demo
Password ya zote: `Demo@2026`

| Nafasi | Email |
|---|---|
| Super Admin | superadmin@kanisahub.demo |
| Admin (Kwaya Kuu) | admin@kanisahub.demo |
| Mshirika (Vijana) | member@kanisahub.demo |

## Muundo
- Frontend: HTML/CSS/JS tupu — `public/`, `member/`, `admin/`, `super-admin/`. Vercel haijengi chochote.
- CSS ya Tailwind imejengwa tayari: `assets/css/tailwind.css` (imo kwenye git). Ukibadilisha au kuongeza class za Tailwind kwenye ukurasa wowote, au rangi kwenye `assets/js/admin-tw-config.js`, ijenge upya kisha u-commit:
  ```
  npm install
  npm run build:css
  ```
- Lugha (SW/EN): `assets/js/i18n.js` — ongeza maneno mapya kwenye kamusi `EN2SW`.
- Backend: Supabase project `kanisa-hub-demo` (ref `ztafklfgtsaolyvaybop`) — tofauti kabisa na project ya BLB
- Hosting: Vercel (`vercel.json`)

## Haifanyi kazi kwenye demo
- Malipo ya mtandaoni (Snippe) na chatbot ya AI — zinahitaji edge functions na API keys ambazo hazijawekwa kwenye demo.
