/**
 * Lightweight browser API polyfill for Chrome/Firefox compatibility
 * Makes chrome.* API work on Firefox and vice versa
 */

(function() {
  // If browser API exists (Firefox), create chrome alias
  if (typeof browser !== 'undefined' && !self.chrome) {
    self.chrome = browser;
  }

  // If chrome API exists but not browser (Chrome), create browser alias
  if (typeof chrome !== 'undefined' && !self.browser) {
    self.browser = chrome;
  }
})();
