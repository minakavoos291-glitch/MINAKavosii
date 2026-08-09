# Meta-Ontomics core vocabulary (source-verified, jozve-moghadamat.txt)

Verified via python re.finditer single-word search on `jozve-moghadamat.txt` (search_files multi-word returns 0 — see persian-text-handling). Slot these into prose naturally; they are the jozve's own terms.

| Term | Frequency | Meaning in the jozve |
|---|---|---|
| فرکانس | 78 | The hidden dimension of reality; operations happen here via آگاهی/نیت |
| فیزیک | 39 | «اعتقاد یک متغیر فیزیکی است» — faith = physical enabler; removes نویز فرکانسی |
| DNA | 40 | هدف نهایی (فرکانس): مقصد و برنامه |
| همدوس | 12 | Coherence = highest level of belief; «لیزر» metaphor; doubt disrupts it |
| نویز | 7 | نویز فرکانسی = شک و تردید (engineering metaphor: noise vs signal) |
| نگنتروپی | 7 | Two poles A/B design for continuous energy exchange; از بین رفتن با رکود |
| ضد آنتروپی/رکود | (رکود ×1) | آنتروپی = رکود و انباشتگی؛ برکهی راکد → لجن → مرگ حیات |
| نیت | 6 | Intent like the radio tuning knob (بیرون به درون) |
| کوپلر | 4 | Jahanx=contingent middle matter (مواد زنده/جواهرات) as antenna/amplifier of نیت |
| ایمان | 2 | فصل ۲ «فیزیکِ ایمان» — absolute unwavering connection ⇒ laser-like outputs |
| خروج از سامانه | 3 | Principle Exosystem: بیرون بهدرون; intent «from outside» changes the 4D world |
## Application formula (used in مهری & علی profiles)
- شکنندگی/تردید = نویز فرکانسی → جواب: توکل/اعتقاد ⇒ سیکنال همدوس
- رکه راکد/انباشتن یکطرفه = آنتروپی → جواب: دو قطب + جریان دوسویه = نگنتروپی
- تغییر مسیر = گردانیدن پیچ تنظیم (نیت) از بیرون سامانه = Exosystem
- جسم/سنگ/مادهی باارزش بهعنوان کوپلر نیت (حلقه/تسبیح انار...)
- DNA سهگانه، ۷ کوپلر (الماس، یاقوت کبود، یاقوت سرخ، اوپال، زمرد، فیروزه، توپاز)

## Backup pitfall (hit 2026-08-09)
`GITHUB_TOKEN=$(cat REDACTED/.github_token) script --now` FAILS: file already contains `GITHUB_TOKEN=` prefix → env overrides script extraction → "Invalid username or token". Correct: run script bare: `REDACTED/scripts/hermes-memory-backup.sh --now`. Diagnose BEFORE rotating token: `curl -H "Authorization: token $(grep -m1 '^GITHUB_TOKEN=' REDACTED/.github_token | cut -d= -f2- )" https://api.github.com/user` → 200 = token fine, invocation wrong.