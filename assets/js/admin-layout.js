/* ============================================
   Kanisa Hub — Portal Layout chrome (admin, super-admin, member)

   Include right after </aside> on every admin page:
     <script src="../assets/js/admin-layout.js"></script>
   Runs synchronously so the injected [data-user-*]
   nodes exist before auth/router hydrate the page.

   Adds: sidebar profile card + brand line,
         desktop top bar (pages without their own),
         page footer.
   ============================================ */
(function () {
  const sidebar = document.getElementById('sidebar');
  if (!sidebar) return;

  const path = location.pathname;
  const portal = path.includes('/super-admin/') ? 'Super Admin' : path.includes('/member/') ? 'Member' : 'Admin';
  // page titles look like "Manage Admins | Super Admin — Kanisa Hub"
  const pageName = document.title.split(/[|—]/)[0].trim() || 'Dashboard';

  const initialsOf = name => (name || '?').trim().split(/\s+/).slice(0, 2).map(w => w[0]).join('').toUpperCase();

  /* ── Sidebar profile card (replaces the old "Kanisa Hub / Admin Portal" heading) ── */
  [...sidebar.children].forEach(el => {
    if (el.tagName === 'DIV' && el.querySelector('h1')) el.classList.add('kh-old-brand');
  });

  const profile = document.createElement('div');
  profile.className = 'kh-profile';
  profile.innerHTML = `
    <div class="kh-profile__ring">
      <div class="kh-profile__avatar">
        <span data-kh-initials>?</span>
        <img data-user-avatar alt="" hidden>
      </div>
    </div>
    <p class="kh-profile__name" data-user-name>Loading…</p>
    <p class="kh-profile__email" data-user-email></p>
    <span class="kh-profile__role" data-user-role>${portal}</span>`;
  const closeBtn = sidebar.querySelector('.sidebar-close-btn');
  (closeBtn ? closeBtn.nextSibling : sidebar.firstChild)
    ? sidebar.insertBefore(profile, closeBtn ? closeBtn.nextSibling : sidebar.firstChild)
    : sidebar.appendChild(profile);

  const brand = document.createElement('p');
  brand.className = 'kh-sidebar-brand';
  brand.innerHTML = `<b>Kanisa Hub</b> · ${portal}`;
  const bottom = sidebar.querySelector('.mt-auto') || sidebar;
  bottom.appendChild(brand);

  /* ── Top bar + footer: <main> comes after the sidebar, so wait for the DOM ── */
  const buildMainChrome = () => {
    const main = document.querySelector('main.main-responsive');
    const hasOwnHeader = !!document.querySelector('body > header.sticky, main > header.sticky');
    if (main && !hasOwnHeader) {
      const today = new Date().toLocaleDateString('en-GB', { weekday: 'short', day: 'numeric', month: 'short', year: 'numeric' });
      const bar = document.createElement('div');
      bar.className = 'kh-topbar';
      bar.innerHTML = `
        <div class="kh-topbar__crumbs">
          <span>${portal}</span><span class="material-symbols-outlined">chevron_right</span><b>${pageName}</b>
        </div>
        <div class="kh-topbar__right">
          <span class="kh-topbar__date"><span class="material-symbols-outlined">calendar_today</span>${today}</span>
          <a class="kh-topbar__btn" href="../public/index.html" target="_blank" rel="noopener" title="View church website">
            <span class="material-symbols-outlined">public</span>
          </a>
          <a class="kh-topbar__btn" href="./announcements.html" title="Announcements">
            <span class="material-symbols-outlined">notifications</span>
          </a>
          <a class="kh-topbar__user" href="./profile.html">
            <p><span class="n" data-kh-name>Loading…</span><br><span class="r" data-kh-role></span></p>
            <span class="kh-topbar__avatar"><span data-kh-initials>?</span></span>
          </a>
        </div>`;
      main.insertBefore(bar, main.firstChild);

      // the top bar already shows who is signed in — drop the page header's own user chip
      // (nodes are only hidden, page scripts still write into them by id)
      const pageHeader = bar.nextElementSibling;
      if (pageHeader) {
        pageHeader.querySelectorAll('[data-user-name]').forEach(el => {
          (el.closest('.text-right') || el.parentElement).classList.add('kh-dup-user');
        });
        const avatar = pageHeader.querySelector('#header-avatar');
        if (avatar) (avatar.parentElement.classList.contains('rounded-full') ? avatar.parentElement : avatar).classList.add('kh-dup-user');
      }
    }

    /* ── Footer ── */
    if (main) {
      const year = new Date().getFullYear();
      const footer = document.createElement('footer');
      footer.className = 'kh-footer';
      footer.innerHTML = `
        <span>© ${year} <b>Kanisa la Neema</b> · All rights reserved</span>
        <span><span class="kh-footer__dot"></span>Kanisa Hub v1.0 · Powered by <a href="https://www.focustec.co.tz" target="_blank" rel="noopener">FocusTec</a></span>`;
      main.appendChild(footer);
    }
    syncUser();
  };

  /* ── Initials + avatar follow whatever auth/router write into [data-user-name] ── */
  const nameEl = profile.querySelector('[data-user-name]');
  const roleEl = profile.querySelector('[data-user-role]');
  function syncUser() {
    const txt = nameEl.textContent;
    document.querySelectorAll('[data-kh-role]').forEach(el => { el.textContent = roleEl.textContent; });
    if (!txt || /…$/.test(txt)) return;   // still the placeholder ("Loading…" or a translation of it)
    document.querySelectorAll('[data-kh-name]').forEach(el => { el.textContent = txt; });
    document.querySelectorAll('[data-kh-initials]').forEach(el => { el.textContent = initialsOf(txt); });
  }
  const watch = { childList: true, characterData: true, subtree: true };
  new MutationObserver(syncUser).observe(nameEl, watch);
  new MutationObserver(syncUser).observe(roleEl, watch);

  if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', buildMainChrome);
  else buildMainChrome();

  const img = profile.querySelector('img[data-user-avatar]');
  new MutationObserver(() => {
    if (!img.getAttribute('src')) return;
    img.hidden = false;
    profile.querySelector('[data-kh-initials]').hidden = true;
    const top = document.querySelector('.kh-topbar__avatar');
    if (top) top.innerHTML = `<img src="${img.src}" alt="">`;
  }).observe(img, { attributes: true, attributeFilter: ['src'] });
  img.addEventListener('error', () => { img.hidden = true; });

  /* ── Phone layout hooks ──
     admin-theme.css lays these out two per row on phones. Deciding which
     elements qualify is done here, once per content change, because doing it
     in CSS with :has() made every DOM update re-check the whole page.
     Page scripts render rows/cards after data loads, so re-run on changes. */
  const addClass = (el, cls) => { if (!el.classList.contains(cls)) el.classList.add(cls); };
  const hasPadding = el => /(^|\s)p-\d/.test(el.className) || /(^|\s)p-\[/.test(el.className);
  const CARD_GRID = /(^|\s)((sm|md):grid-cols-[234]|(lg|xl):grid-cols-[34])(\s|$)/;

  const decorate = () => {
    const main = document.querySelector('main');
    if (!main) return;

    // tables → labelled row cards
    main.querySelectorAll('table').forEach(table => {
      const heads = [...table.querySelectorAll('thead th')].map(th => th.textContent.trim());
      if (!heads.length) return;
      addClass(table, 'kh-cards');
      const wrap = table.parentElement;
      addClass(wrap, 'kh-table-wrap');
      addClass(wrap, 'kh-table-bare');
      if (/rounded/.test(wrap.className) && /(^|\s)(bg-white|bg-surface-container-lowest)(\s|$)/.test(wrap.className)) addClass(wrap, 'kh-table-card');
      if (wrap.parentElement && wrap.parentElement !== main && wrap.parentElement.tagName === 'DIV') addClass(wrap.parentElement, 'kh-table-bare');
      table.querySelectorAll('tbody tr').forEach(tr => {
        const cells = tr.children;
        for (let i = 0; i < cells.length; i++) {
          const td = cells[i];
          if (td.hasAttribute('colspan')) { addClass(tr, 'kh-span'); continue; }
          if (heads[i] && td.getAttribute('data-label') !== heads[i]) td.setAttribute('data-label', heads[i]);
        }
        const last = tr.lastElementChild;
        if (last && last.querySelector('button, a')) addClass(last, 'kh-actions');
      });
    });

    // single-column card grids → two-up
    main.querySelectorAll('.grid').forEach(grid => {
      if (grid.querySelector('input, select, textarea')) return;
      const kids = [...grid.children];
      if (kids.some(k => /col-span/.test(k.className))) return;
      if (grid.classList.contains('grid-cols-1') && CARD_GRID.test(grid.className)) addClass(grid, 'kh-two-up');
      else if (grid.classList.contains('grid-cols-2') && kids.length && kids.every(hasPadding)) addClass(grid, 'kh-two-up-compact');
    });

    // stacked link/button tiles (dashboard quick actions…) → two-up
    main.querySelectorAll('.flex.flex-col').forEach(col => {
      const tiles = [...col.children].filter(k => (k.tagName === 'A' || k.tagName === 'BUTTON') && /rounded/.test(k.className) && hasPadding(k));
      if (tiles.length >= 2) addClass(col, 'kh-tiles');
    });
  };

  let decorateQueued = false;
  const queueDecorate = () => {
    if (decorateQueued) return;
    decorateQueued = true;
    setTimeout(() => { decorateQueued = false; decorate(); }, 60);
  };
  const startDecorate = () => {
    decorate();
    const main = document.querySelector('main');
    if (main) new MutationObserver(queueDecorate).observe(main, { childList: true, subtree: true });
  };
  if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', startDecorate);
  else startDecorate();
})();
