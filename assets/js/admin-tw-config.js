/* ============================================
   Kanisa Hub — Theme (Tailwind config)

   Read by tailwind.config.js when building
   assets/css/tailwind.css — pages no longer load
   this file. Change brand colours here once,
   then run `npm run build:css`.

   The blue / indigo / slate / yellow / amber scales
   are remapped onto the theme so hard-coded
   utility classes (text-blue-900, bg-yellow-50 …)
   follow the palette automatically.
   ============================================ */
(function () {
  const teal = {
    50: '#eef4f2', 100: '#dbe7e3', 200: '#b9cfc8', 300: '#93b2a9', 400: '#6c918a',
    500: '#557770', 600: '#476660', 700: '#3d5650', 800: '#334843', 900: '#2a3b37', 950: '#1b2724',
  };
  const gold = {
    50: '#fdf8e9', 100: '#faefc9', 200: '#f3de93', 300: '#ebc95b', 400: '#e0b63c',
    500: '#d4a72c', 600: '#b88b1f', 700: '#926b1b', 800: '#78561d', 900: '#66481d', 950: '#3a280c',
  };
  const sage = {
    50: '#f5f8f7', 100: '#edf2f0', 200: '#dfe7e4', 300: '#c8d3cf', 400: '#92a29d',
    500: '#6b7c77', 600: '#52625d', 700: '#3f4d49', 800: '#2b3633', 900: '#1c2523', 950: '#111816',
  };

  tailwind.config = {
    darkMode: 'class',
    theme: {
      extend: {
        colors: {
          blue: teal, indigo: teal, slate: sage, gray: sage, yellow: gold, amber: gold,
          teal: teal, gold: gold, sage: sage,

          'primary':                   '#3d5650',
          'primary-container':         '#4d6a63',
          'primary-fixed':             '#dbe7e3',
          'primary-fixed-dim':         '#b9cfc8',
          'on-primary-fixed':          '#1b2724',
          'on-primary-fixed-variant':  '#334843',
          'inverse-surface':           '#2a3b37',
          'inverse-on-surface':        '#eef4f2',
          'on-primary':                '#ffffff',
          'on-primary-container':      '#cfe0db',
          'secondary':                 '#b88b1f',
          'secondary-container':       '#d4a72c',
          'secondary-fixed':           '#f6e7b8',
          'secondary-fixed-dim':       '#e5c867',
          'on-secondary':              '#ffffff',
          'on-secondary-container':    '#3a2c00',
          'on-secondary-fixed':        '#2a1f00',
          'on-secondary-fixed-variant':'#5c4510',
          'tertiary':                  '#1fa89f',
          'card':                      '#ffffff',
          'muted':                     '#6b7c77',
          'border':                    '#e8eeec',
          'background':                '#e6eeeb',
          'surface':                   '#e6eeeb',
          'surface-bright':            '#f4f8f6',
          'surface-dim':               '#cfd9d6',
          'surface-container-lowest':  '#ffffff',
          'surface-container-low':     '#f4f8f6',
          'surface-container':         '#edf2f0',
          'surface-container-high':    '#e3eae7',
          'surface-container-highest': '#dae3e0',
          'surface-variant':           '#dae3e0',
          'on-surface':                '#26332f',
          'on-surface-variant':        '#5f706b',
          'outline':                   '#8a9a95',
          'outline-variant':           '#cfdad6',
          'error':                     '#c0392b',
          'on-error':                  '#ffffff',
          'error-container':           '#fde2df',
          'on-error-container':        '#5c140c',
        },
        fontFamily: {
          headline: ['Nunito Sans', 'sans-serif'],
          body:     ['Nunito Sans', 'sans-serif'],
          label:    ['Nunito Sans', 'sans-serif'],
          sans:     ['Nunito Sans', 'sans-serif'],
        },
        borderRadius: { DEFAULT: '0.375rem', lg: '0.625rem', xl: '1rem', '2xl': '1.25rem', '3xl': '1.75rem', full: '9999px' },
      },
    },
  };
})();
