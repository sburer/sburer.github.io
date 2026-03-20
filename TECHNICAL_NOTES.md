# Technical Modernization Notes

## CSS Architecture Changes

### Before (main.css - 2425 bytes)
```css
/* Float-based layout, absolute positioning */
#frame { position: absolute; left: 50%; width: 800px; margin-left: -400px; }
.content-left { width: 499px; float: left; }
.content-right-tallest { width: 280px; float: right; }
/* Many fixed pixel values, no responsive design */
```

### After (main.css - 10,747 bytes)
```css
/* Modern CSS Grid/Flexbox with responsive breakpoints */
:root { /* CSS custom properties for theming */ }

#frame { 
  display: flex; 
  flex-direction: column; 
  min-height: 100vh; 
  max-width: 100%; 
}

.content { 
  display: grid; 
  grid-template-columns: 1fr;
  max-width: 1200px;
  margin: 0 auto;
  padding: 2rem 1rem;
}

@media (max-width: 1024px) { /* Tablet */ }
@media (max-width: 768px) { /* Mobile */ }
@media (max-width: 480px) { /* Small mobile */ }
```

## Key Improvements

### 1. Flexbox Navigation
- **Before:** Float-based (float: left, float: right)
- **After:** `display: flex; justify-content: center; gap: 0;`
- Result: Better alignment, simpler code, responsive stacking

### 2. Profile Section
- **Before:** Two divs with float-left (499px) and float-right (280px)
- **After:** CSS Grid with `grid-template-columns: 1fr 1fr`
- Result: True two-column on desktop, single column on mobile

### 3. Typography Scales
- **Before:** Fixed font sizes (2.0em, 1.5em for nav)
- **After:** REM units with media query overrides
  - Desktop: h1=2.5rem
  - Tablet: h1=2rem
  - Mobile: h1=1.6rem
  - Small: h1=1.3rem

### 4. Spacing System
- **Before:** Hardcoded pixel margins (10px, 15px)
- **After:** REM-based spacing (2rem, 1.5rem, 1rem) with media query adjustments

### 5. Theme Support
- **Before:** Hardcoded colors (#30466E, #CC5200, #FFFFFF)
- **After:** CSS custom properties with dark mode variants
  ```css
  :root {
    --primary-dark: #30466E;
    --accent-orange: #CC5200;
    --text-dark: #1a1a1a;
    --bg-light: #FFFFFF;
  }
  @media (prefers-color-scheme: dark) {
    :root { --text-dark: #e0e0e0; --bg-light: #0d1117; }
  }
  ```

## HTML Structure Modernization

### Before
```html
<html>
  <head>
    <title>...</title>
    <meta http-equiv="Content-Type" content="..."/>
    <link href="styles/main.css" rel="stylesheet" type="text/css">
  </head>
  <body>
    <div id="frame">
      <div id="header"> ... </div>
      <div class="nav"> ... </div>
      <div class="content">
        <div class="content-left"> ... </div>
        <div class="content-right-tallest"> ... </div>
      </div>
    </div>
  </body>
</html>
```

### After
```html
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="theme-color" content="#30466E">
    <link href="https://fonts.googleapis.com/css2?family=Dosis...&display=swap" rel="stylesheet">
    <link href="/styles/main.css" rel="stylesheet" type="text/css">
  </head>
  <body>
    <div id="frame">
      <header id="header">
        <div id="header-left">...</div>
        <div id="header-right">...</div>
      </header>
      <nav class="nav">
        <div id="navbtn_current">...</div>
        <div class="navbtn">...</div>
      </nav>
      <main class="content">
        <section class="hero-section">
          <div class="hero-left">...</div>
          <div class="hero-right">...</div>
        </section>
        <section class="content-left-tallest">...</section>
      </main>
      <footer id="footer">...</footer>
    </div>
  </body>
</html>
```

**Improvements:**
- Semantic HTML5 (`<header>`, `<nav>`, `<main>`, `<section>`, `<footer>`)
- DOCTYPE declaration
- Proper viewport meta tag (critical for mobile)
- Language attribute (en)
- Character encoding (UTF-8)
- Preconnect hints for Google Fonts
- Theme color meta tag

## Performance Considerations

- No build tools required (plain CSS)
- Single CSS file loads once
- Google Fonts loaded with preconnect (faster)
- CSS custom properties (no preprocessing needed)
- Minimal JavaScript (dark mode preference detection only)

## Browser Support

- ✅ Chrome 90+
- ✅ Firefox 88+
- ✅ Safari 14+
- ✅ Edge 90+
- ✅ Mobile browsers (iOS Safari 14+, Chrome Mobile)

Note: CSS Grid and Flexbox have ~95%+ global support. Dark mode media query has ~90%+ support.

## Maintenance Notes

1. **Colors:** Update CSS custom properties in `:root`
2. **Typography:** Modify font-size scales in media queries
3. **Spacing:** Adjust padding/margins in responsive units
4. **Dark mode:** Update custom properties in `@media (prefers-color-scheme: dark)`

All changes are well-commented in the CSS file for future developers.
