---
name: persian-narrative-deliverables
description: "Use for Persian flowing-narrative analysis or reports."
version: 1.0.0
author: Hermes Agent
license: MIT
platforms: [linux, macos, windows]
metadata:
  hermes:
    tags: [persian, narrative, style, delivery, mina]
---

# Persian Narrative Deliverables (تحویلِ رواییِ فارسی)

For Mina Kavoosi's person-profile analyses and similar Persian reports. The
user rejected header/bullet style multiple times; the governing style rule is:

## Style mandate (multiple explicit corrections)
- **BODY = one continuous flowing multi-page Persian narrative.** ZERO
  headers, ZERO bullet lists, ZERO bolded section labels inside the analysis.
- **The chat delivery message itself must BE the full interpretation** — every
  section fully narrated in flowing prose from the very first message. NEVER
  give a title list first and explain afterwards (correction: «از همان اول
  تفسیر جامع بده» — "from the start give the full interpretation").
- Structure exists in the FILE as `#` headers (باطن، موقعیتهای درونی،
  ارتباطات، هفتگانهها، روحیات، سه دیدگاه، مالی/موانع/سکوها، سیر گذشته،
  دو مسیر، ریشههای علمی، راهکارها، طرحوارهها و تروماها، نقشه راه ۹۰ روزه،
  جمعبندی جامع) — but in CHAT the same content is narrated section by section
  without those titles.
- Opening: بسم الله الرحمن الرحیم — یا علی. Closing of delivery:
  «نفر بعدی را بفرمایید، یا علی 🌸» (or التماس دعا، یا علی 🌸 for topic
  analyses).
- Every analysis ends with a poetic closing («واپسین نگاه») and the final
  summary is its own flowing-prose section (7 perspectives + mirror).
- Honest method note inside the opening: «بررسیِ الگوییِ دقیقِ چارچوب است نه
  خبرِ قطعی؛ هر جا تأیید یا اصلاح کنی، خاصه دقیقتر میشود.»

## Deep-first principle
The user's standing instruction: each new person must be deeper and richer
than the last («هر سری کاملتر و جامعتر از سری قبل»). Always integrate:
19-dimension framework, 16-step دیدن method, schemas+traumas layer
(طفولیت→امروز + راهکار), 90-day roadmap, plain-language version, and both
Meta-Ontomics terms (نویز شک، فیزیک ایمان، نگنتروپی، کوپلر، فرکانس صفر،
خروج از سامانه) fused INTO sentences — not as labels.

## Corrections log (style)
- 2026-08-10: summary page rejected as تیتروار → rewrote as flowing prose.
- 2026-08-11: delivery explained after a title list → user demanded full
  interpretation from the start. Patch the meta-ontomics-assistant skill
  (user-owned) or follow this skill for the delivery style.

## Pitfalls
- If the user asks to explain all sections, DON'T re-print the title list and
  then explain — interpret each section in narrative flow directly.
- Name/concept ambiguity: a Persian word in the request can be a person's
  NAME (حدیث = wife's name, not the hadith). When a word is also a common
  noun, treat it as a person first; ask one clarifying question if needed.
- Only claim a file was written/backed up when the tool call actually
  returned success.
- Write long files in 3–5KB chunks via execute_code with per-chunk regex
  validation (see persian-content-handling skill).
