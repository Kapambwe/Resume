# Profile Website Look-and-Feel Enhancement Plan

## 1. Current-site assessment

### Overall direction

The site currently presents Abraham Kapambwe as a senior software, data, and DevOps engineer through a single-page profile. It has a deliberate editorial/technical visual language:

- Fraunces is used for the oversized display name and Space Grotesk for interface/body text.
- The page uses teal, amber, blue, and slate accents across a soft gradient background.
- A fixed glass navigation bar provides section links and reading progress.
- Light/dark themes are persisted with `localStorage` and respect the user’s system preference.
- Sections are revealed on scroll and the active section is highlighted in the navigation.
- The profile includes experience, skills, applied projects, certifications, external writing, and direct contact links.
- Print-specific styling already exists for producing a compact CV-style output.

### Strengths to preserve

- Clear positioning around the intersection of software engineering, data platforms, and automation.
- Strong content depth and credible technical breadth.
- Distinctive visual identity rather than a generic portfolio template.
- Useful proof points in the hero: 14+ years, 20+ payment providers, and three cloud platforms.
- Project cards already include an impact statement, tags, and live-demo links.
- Theme switching, smooth scrolling, focus-visible states, responsive layout rules, and print support are good foundations.

### Current friction points

1. **The visual system is slightly over-layered.** Multiple gradients, grid overlays, blur effects, shadows, rounded cards, badges, chips, and decorative pseudo-elements compete for attention. The result is visually rich but can make the page feel busy and reduce emphasis on the strongest content.

2. **The hero is informative but not yet strongly conversion-oriented.** It presents many labels and statistics, but there is no primary action such as “View selected work,” “Download CV,” or “Start a conversation.” Contact links are visually secondary inside the right-hand card.

3. **The content hierarchy is very uniform.** Most sections use the same section heading pattern and card treatment. Experience, projects, skills, education, and writing would benefit from more differentiated visual patterns.

4. **Projects are text-heavy.** The four projects are compelling, but the page does not show screenshots, diagrams, architecture snippets, metrics, or a clear “problem → approach → outcome” structure. The projects therefore read more like descriptions than case studies.

5. **Experience is detailed but dense.** The timeline contains many bullets with similar visual weight. The most important outcomes and technologies are not immediately scannable.

6. **Mobile navigation has a potential usability trade-off.** At small widths, the top bar becomes sticky with horizontally scrollable navigation plus reading progress. This is functional, but it consumes vertical space and may not make the active destination obvious enough.

7. **Accessibility and resilience can be tightened.** The site should add a skip link, explicit external-link behavior, reduced-motion handling, stronger semantic grouping, and checks for contrast and focus visibility in both themes.

8. **There is a source/build consistency concern.** `index.html` references `style.min.css` and `script.min.js`, while the editable sources are `style.css` and `script.js`. Any future design change must run `build.ps1`; otherwise local source changes will not be reflected in the deployed page.

9. **There is an unused image source reference.** The headshot `<picture>` includes `assets/headshot.jpg`, but the current asset inventory contains SVG and PNG versions only. The fallback works, but the unused source should either be added or removed.

## 2. Recommended design direction

Move toward a **calm, premium engineering profile**: preserve the distinctive editorial typography and teal/amber identity, but create more restraint, clearer emphasis, and stronger evidence of impact.

### Suggested visual principles

- Use one primary accent (teal) and one supporting accent (amber) rather than applying several equal-strength accents everywhere.
- Keep gradients mainly for the hero and featured project; use flatter surfaces for supporting content.
- Reduce shadow size and blur on most cards so the page feels lighter and more intentional.
- Use a stronger spacing rhythm based on a small set of tokens: 8, 12, 16, 24, 32, 48, and 72px.
- Reserve the largest type scale for the name, section titles, and featured project headline.
- Prefer visual proof and outcome statements over additional decorative elements.
- Keep the dark theme, but make it feel like the same brand system rather than a separate visual design.

## 3. Phased enhancement plan

### Phase 1 — Clarify hierarchy and conversion

**Goal:** Make the first screen communicate who Abraham is, what he does, and what the visitor should do next.

#### Hero

- Rewrite the hero into a sharper positioning statement, for example: “I build cloud-native systems and data platforms that turn complex operations into measurable outcomes.”
- Keep the three proof points, but shorten their labels and align them visually as a compact evidence strip.
- Add a primary CTA: **View selected work** linking to `#projects`.
- Add a secondary CTA: **Download CV** linking to `Abraham_Kapambwe_CV.pdf`.
- Keep email as the most prominent contact action; move phone and other profiles into a quieter secondary row.
- Add a small availability/status label only if it is accurate and maintained.
- Consider using the headshot as a larger portrait with a subtle frame or offset panel, rather than a small circular avatar.

#### Navigation

- Keep the desktop floating navigation, but reduce its visual weight and show a clearer active indicator.
- On mobile, collapse the links into a compact menu or a simpler horizontal section rail; avoid showing too many controls at once.
- Add a “Skip to content” link before the navigation.
- Give the navigation and main content explicit landmarks (`header`, `nav`, `main`, and `footer`).

#### Expected outcome

Visitors should understand the profile within five seconds and have an obvious path to either inspect work or make contact.

### Phase 2 — Make experience and projects more visual

**Goal:** Turn the strongest content into easy-to-scan evidence of capability.

#### Experience

- Introduce a compact role header with company, title, dates, location if relevant, and a short one-line outcome.
- Group bullets under small labels such as `Impact`, `Systems`, and `Delivery`, or reduce each role to three high-value bullets.
- Bold measurable details and technologies within bullets where useful.
- Highlight the current Derivco role more strongly and visually compress older roles.
- Add a “Career snapshot” strip above the timeline with domains such as payments, fintech, telecom, public sector, and analytics.

#### Projects

- Keep the financial crime platform as the featured case study.
- Add a visual thumbnail, architecture diagram, or cropped product screenshot to each project. Use optimized local assets where possible.
- Reframe each project card around:
  - Problem
  - Approach
  - Outcome or intended value
  - Stack
  - Demo / code link
- Use clearer buttons for demos rather than inline “Live demo:” text.
- Add lightweight metadata such as `Prototype`, `Live demo`, or `Exploration` so visitors understand project maturity.
- Where exact metrics are unavailable, use honest scope indicators such as data sources, processing style, platform, or user group.

#### Expected outcome

The site should feel like a portfolio of systems and decisions, not only a written résumé.

### Phase 3 — Refine the visual system

**Goal:** Reduce visual noise and create a consistent premium finish.

- Define CSS custom properties for spacing, radii, border opacity, and shadow levels.
- Reduce the body grid overlay opacity, especially on light mode.
- Use one card radius for large surfaces and one smaller radius for controls.
- Replace some card shadows with borders and tonal contrast.
- Reduce the number of independent pseudo-element decorations.
- Standardize hover motion to a subtle 2–4px lift with no layout shift.
- Use a consistent icon style for email, LinkedIn, GitHub, phone, external links, and theme switching. Inline SVG icons are preferable to text symbols such as `◐`, `◑`, and `↗`.
- Ensure the dark theme uses the same hierarchy and accent roles as light mode rather than requiring many one-off overrides.
- Consider a slightly wider reading measure for the professional summary and project descriptions while keeping line length comfortable.

### Phase 4 — Improve accessibility, responsiveness, and quality

**Goal:** Make the polished design reliable across devices and user preferences.

- Add `@media (prefers-reduced-motion: reduce)` to disable reveal, smooth scrolling, and hover transforms where appropriate.
- Confirm all interactive elements have visible focus styles in both themes.
- Test color contrast for muted text, chips, metadata, and links.
- Add `target="_blank"` and `rel="noopener noreferrer"` to external links if opening them in a new tab is the intended behavior; otherwise keep same-tab behavior consistently.
- Add descriptive `aria-label` text where link text is visually abbreviated.
- Replace the unused `assets/headshot.jpg` source or remove it from the `<picture>` element.
- Add a visible error-safe fallback for the headshot if an asset fails to load.
- Ensure the sticky mobile navigation does not cover anchored headings; use `scroll-margin-top` on sections.
- Test at minimum 320px, 375px, 768px, 1024px, and wide desktop widths.
- Validate the minified files after every source change by running `build.ps1`.

### Phase 5 — Add trust and content polish

**Goal:** Make the profile feel current, specific, and easy to act on.

- Add a concise “What I’m exploring now” block for Microsoft Fabric, intelligent automation, or another current focus.
- Add publication dates or year labels to the writing cards if available.
- Add a simple “Last updated” date to signal freshness.
- Add a dedicated contact/footer CTA with email and LinkedIn rather than relying only on the hero contact grid.
- Review all claims and labels for consistency, especially “MVP Track,” cloud platform counts, and years of experience.
- Consider adding a short testimonial, recommendation, or selected client/domain list if permission and accurate source material are available.

## 4. Suggested page structure after enhancement

1. Floating navigation
2. Hero with positioning, proof points, primary/secondary CTAs, portrait, and contact actions
3. Selected work / featured case study
4. Career impact timeline
5. Capabilities by outcome or discipline
6. Additional projects
7. Certifications and continuous learning
8. Writing and publications
9. Closing contact CTA and footer

This order puts evidence of capability closer to the top while preserving the existing résumé depth for visitors who want to go further.

## 5. File-level implementation map

### `index.html`

- Add semantic landmarks and skip link.
- Add hero CTA buttons and a closing CTA.
- Refine project markup for screenshots, metadata, and structured case-study content.
- Add external-link attributes and improve accessible labels.
- Remove or provide the missing JPG headshot source.

### `style.css`

- Introduce design tokens for spacing, radius, borders, and shadows.
- Simplify background decoration and card treatments.
- Add CTA, project media, career snapshot, and improved mobile navigation styles.
- Add reduced-motion and anchor-offset rules.
- Rebalance type sizes and section spacing after testing at target breakpoints.

### `script.js`

- Preserve theme persistence and section tracking.
- Add mobile navigation behavior if a collapsible menu is chosen.
- Add active-state handling that remains usable with keyboard navigation.
- Respect reduced-motion preferences for reveal behavior.

### `build.ps1`

- Continue treating `style.css` and `script.js` as the source of truth.
- Run the build after every design change so `style.min.css` and `script.min.js` remain synchronized.

### `assets/`

- Add optimized project thumbnails or diagrams in WebP/AVIF where GitHub Pages/browser support permits.
- Keep the existing favicon and social preview assets, updating the social preview if the visual identity changes substantially.

## 6. Validation checklist

### Visual

- The hero communicates role, specialty, proof, and next action without scrolling.
- The featured project is clearly the visual focal point after the hero.
- Supporting cards do not all look equally prominent.
- Light and dark themes share the same hierarchy.
- Typography remains legible over gradients and decorative backgrounds.

### Responsive

- No horizontal page overflow at 320px.
- Mobile navigation does not obscure content or dominate the viewport.
- Project media and featured cards collapse cleanly to one column.
- CTAs remain visible and comfortably tappable.

### Accessibility

- Keyboard users can skip navigation and reach every interactive element.
- Focus indicators are visible in both themes.
- Reduced-motion users do not receive distracting transitions.
- Text and controls meet practical contrast requirements.
- Headings follow a logical hierarchy.

### Technical

- `style.min.css` and `script.min.js` are regenerated from source.
- All local assets resolve.
- External links are reviewed for correctness.
- Print output remains useful as a CV summary.
- The page is checked in at least one Chromium-based browser and one mobile viewport.

## 7. Priority order

1. Hero hierarchy, CTAs, and navigation simplification.
2. Project case-study treatment and visual proof.
3. Experience scannability and outcome emphasis.
4. Card, gradient, shadow, and spacing refinement.
5. Accessibility and reduced-motion improvements.
6. Content freshness, publication metadata, and closing contact CTA.

The first three priorities will have the largest effect on perceived quality and visitor action. The remaining work will turn the visual upgrade into a durable, accessible, and maintainable design system.
