// Przełącznik języka treści w formularzach panelu (taby PL/EN/DE).
// Formularz ma klasę lang-pl|lang-en|lang-de; CSS pokazuje pola danego języka.
// Działa z Turbo Drive (delegacja na document + inicjalizacja na turbo:load).
const LANGS = [ "pl", "en", "de" ];

function setLang(form, lang) {
  LANGS.forEach((l) => form.classList.toggle(`lang-${l}`, l === lang));
  form.querySelectorAll("[data-lang-tab]").forEach((btn) => {
    const on = btn.dataset.langTab === lang;
    btn.classList.toggle("active", on);
    btn.setAttribute("aria-selected", on ? "true" : "false");
  });
}

document.addEventListener("click", (e) => {
  const btn = e.target.closest("[data-lang-tab]");
  if (!btn) return;
  e.preventDefault();
  const form = btn.closest("form");
  if (form) setLang(form, btn.dataset.langTab);
});

function init() {
  document.querySelectorAll("form .lang-tabs").forEach((tabs) => {
    const form = tabs.closest("form");
    if (!form) return;
    const current = LANGS.find((l) => form.classList.contains(`lang-${l}`)) || "pl";
    setLang(form, current);
  });
}

document.addEventListener("turbo:load", init);
document.addEventListener("DOMContentLoaded", init);
