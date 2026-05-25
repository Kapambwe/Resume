const themeStorageKey = "ak-theme";
const root = document.documentElement;
const themeMeta = document.querySelector('meta[name="theme-color"]');
const themeToggle = document.getElementById("themeToggle");
const themeLabel = themeToggle?.querySelector(".theme-toggle-label");
const progressFill = document.getElementById("pageProgress");
const topbarLinks = Array.from(document.querySelectorAll(".topbar-link"));
const sectionIds = ["profile", "skills", "experience", "projects", "education", "writing"];
const sectionElements = sectionIds
  .map((id) => document.getElementById(id))
  .filter(Boolean);

function readPreferredTheme() {
  try {
    const stored = localStorage.getItem(themeStorageKey);
    if (stored === "dark" || stored === "light") {
      return stored;
    }
  } catch (_) {
    // Ignore storage failures and fall back to system preference.
  }

  return window.matchMedia && window.matchMedia("(prefers-color-scheme: dark)").matches ? "dark" : "light";
}

function applyTheme(theme, persist) {
  root.dataset.theme = theme;
  root.style.colorScheme = theme;

  if (themeMeta) {
    themeMeta.setAttribute("content", theme === "dark" ? "#0b1120" : "#0f766e");
  }

  if (themeToggle) {
    themeToggle.setAttribute("aria-pressed", theme === "dark" ? "true" : "false");
  }

  if (themeLabel) {
    themeLabel.textContent = theme === "dark" ? "Light mode" : "Dark mode";
  }

  if (persist) {
    try {
      localStorage.setItem(themeStorageKey, theme);
    } catch (_) {
      // Ignore storage failures.
    }
  }
}

applyTheme(readPreferredTheme(), false);

if (themeToggle) {
  themeToggle.addEventListener("click", () => {
    applyTheme(root.dataset.theme === "dark" ? "light" : "dark", true);
  });
}

function setActiveSection(id) {
  topbarLinks.forEach((link) => {
    const isActive = link.getAttribute("href") === `#${id}`;
    link.classList.toggle("is-active", isActive);
    if (isActive) {
      link.setAttribute("aria-current", "page");
    } else {
      link.removeAttribute("aria-current");
    }
  });
}

function updateReadingState() {
  const scrollTop = window.scrollY || document.documentElement.scrollTop || 0;
  const maxScroll = Math.max(document.documentElement.scrollHeight - window.innerHeight, 1);
  const progress = Math.min(Math.max(scrollTop / maxScroll, 0), 1);

  if (progressFill) {
    progressFill.style.width = `${progress * 100}%`;
  }

  let activeId = sectionIds[0];
  const activationOffset = 180;

  for (const section of sectionElements) {
    const rect = section.getBoundingClientRect();
    if (rect.top <= activationOffset) {
      activeId = section.id;
    }
  }

  setActiveSection(activeId);
}

const observer = new IntersectionObserver(
  (entries) => {
    entries.forEach((entry) => {
      if (entry.isIntersecting) {
        entry.target.classList.add("is-visible");
        observer.unobserve(entry.target);
      }
    });
  },
  { threshold: 0.12 }
);

document.querySelectorAll(".reveal").forEach((el) => observer.observe(el));

window.addEventListener("scroll", updateReadingState, { passive: true });
window.addEventListener("resize", updateReadingState);
updateReadingState();
