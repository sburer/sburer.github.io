// Theme Toggle - Dark Mode Support
// This script enables dark mode toggle functionality

(function() {
  'use strict';

  const THEME_KEY = 'sb-theme-preference';
  const DARK_MODE_CLASS = 'dark-mode';

  /**
   * Get the user's theme preference
   */
  function getThemePreference() {
    const saved = localStorage.getItem(THEME_KEY);
    if (saved) {
      return saved;
    }
    // Check system preference
    if (window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches) {
      return 'dark';
    }
    return 'light';
  }

  /**
   * Apply theme to the page
   */
  function applyTheme(theme) {
    const root = document.documentElement;
    
    if (theme === 'dark') {
      root.classList.add(DARK_MODE_CLASS);
      localStorage.setItem(THEME_KEY, 'dark');
    } else {
      root.classList.remove(DARK_MODE_CLASS);
      localStorage.setItem(THEME_KEY, 'light');
    }

    // Update meta theme-color
    const themeColor = theme === 'dark' ? '#0d1117' : '#30466E';
    let metaTheme = document.querySelector('meta[name="theme-color"]');
    if (metaTheme) {
      metaTheme.setAttribute('content', themeColor);
    }
  }

  /**
   * Initialize theme on page load
   */
  function initializeTheme() {
    const preference = getThemePreference();
    applyTheme(preference);
  }

  /**
   * Listen for system theme preference changes
   */
  if (window.matchMedia) {
    window.matchMedia('(prefers-color-scheme: dark)').addEventListener('change', (e) => {
      const saved = localStorage.getItem(THEME_KEY);
      if (!saved) {
        // Only auto-apply if user hasn't manually set a preference
        applyTheme(e.matches ? 'dark' : 'light');
      }
    });
  }

  // Initialize on DOM ready
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initializeTheme);
  } else {
    initializeTheme();
  }

  // Expose toggle function globally for optional UI button
  window.toggleTheme = function() {
    const current = getThemePreference();
    const newTheme = current === 'dark' ? 'light' : 'dark';
    applyTheme(newTheme);
  };

})();
