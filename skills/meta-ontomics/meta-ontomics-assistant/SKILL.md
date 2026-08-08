---
name: meta-ontomics-assistant
description: "Use when analyzing Meta-Ontomics training PDFs or exams."
version: 1.0.0
author: Hermes Agent
license: MIT
platforms: [linux, macos, windows]
metadata:
  hermes:
    tags: [meta-ontomics, psychology, persian, training, exam]
---

# Meta-Ontomics Assistant (دستیار متاآنتومیک)

## Context
This chat belongs to **Mina Kavoosi** (Telegram). Role: her assistant for integrating **psychology** and **Meta-Ontomics** (علم متاآنتومیک). Two instructors (Mohammadreza Hojjatpanah, Sajjad Parsa) send educational PDFs that must be deeply analyzed, learned, and turned into exams/presentations. **Always respond in Persian.**

## Workflow (established standard — repeat exactly)

1. **Receive PDF** → copy from `REDACTED/cache/documents/` to a safe path, extract text with pymupdf (pip install pymupdf if missing; write extractor script to `/tmp` to avoid terminal null-byte errors on Persian filenames).
2. **Read ALL text** in chunks (read_file with offset pagination; ~1500 lines per 58-page jozve).
3. **Store artifacts** in `/data/workspace/meta-ontomics/`:
   - `jozve-<name>.txt` — extracted text
   - `kholase-jame.md` — comprehensive summary (8 sections: intro, dead-ends, pillars, training path, applications, two views, vision, analysis)
   - `azmoon-jame-<level>.md` — exam (15 MCQ + 10 short + 6 analytical + 3 applied = 62 pts)
   - `kelid-azmoon.md` — answer key (verified against source text)
4. **Verify mastery**: cross-check every exam answer against the actual source text with search_files (grep) before claiming accuracy.
5. **Value assessment (ارزش‌گذاری)**: take the exam yourself, self-grade honestly, note that self-grading needs independent confirmation.
6. **Presentations** (ارائه): build .pptx with pptxgenjs (node), Persian font Tahoma, dark-deep-space theme with gold accent (#0F1226 bg, #E8B64C gold, #8B7CF6 violet, #3ECFB2 teal); QA via LibreOffice→PDF→pdftoppm→pixel checks; verify Persian text with pdftotext keyword counts.
7. **Backup**: run `REDACTED/scripts/hermes-memory-backup.sh --now` after completing work; cron runs every 3h (no_agent, silent unless changed/error).

## Person-Profile Deliverable (شخصیت) — THE STANDARD (no reminder needed)
For every person requested (name + birth year), produce the FULL package, always integrating the **19-dimension framework** (dimension → description → root → solution for each):
1) اعتماد به نفس 2) قدرت تصمیم 3) روحیات درونی 4) ترس پنهان 5) نوع ارتباط 6) سبک ارتباطی 7) نقش خانوادگی 8) نقطه ضعف 9) مالی 10) عاطفی 11) شخصی 12) رفتاری 13) خانوادگی (مبدأ) 14) دید دیگران به او 15) دید او به دیگران 16) دید او به خودش 17) ریشه قوت‌ها 18) ریشه ضعف‌ها 19) راهکارها.
Plus: کلیات/تصویر کلان، نسل‌شناسی، ۱۶ مرحله دیدن (آماده‌سازی، ذکر شخص، ریزبینی قوت/ضعف، ریشه‌یابی ۵ لایه، ۱۲ بُعد، خاصه، اولویت‌بندی، دو فردا، ۳ دیدگاه)، خوانش روان‌شناختی (پنج عامل، اریکسون/لِوینسون، دلبستگی، طرحواره‌های یانگ، تحریف‌ها)، خوانش متاآنتومیک (فرکانس، نیت، نویز شک، کوپلر، نگنتروپی، فرکانس صفر، DNA سه‌گانه، خروج از سامانه)، راهکار دوگانه (روان‌شناختی + متاآنتومیک) با نقشه راه ۹۰ روزه، نشانه‌های هشدار، راهنمای ارتباط خانواده، بانک جمله‌های آماده، سنجه‌های پیشرفت، نسخه زبان ساده. Always open with بسم الله + یا علی. Save to `/data/workspace/meta-ontomics/tahlil-<name>.md`. Each new person must be deeper/richer than the last.

## Backup
run `REDACTED/scripts/hermes-memory-backup.sh --now` after completing work; cron runs every 3h (no_agent, silent unless changed/error).
## Pitfalls
- Persian filenames in terminal commands → "embedded null byte" error; copy to ASCII path first (`cp "file" /tmp/jozve.pdf`).
- pymupdf not installed by default → `pip install pymupdf`.
- Persian text in memory tool → U+200C (ZWNJ) blocks writes; use English or remove ZWNJ.
- GitHub push protection blocks secrets in state.db → sanitize with REDACTED (already in backup script).
- `read_file` cannot show images; use pixel analysis via PIL for visual QA.
- Fonts: install `fonts-noto-core fonts-noto-extra` for Arabic/Persian rendering; LibreOffice (soffice) + poppler-utils needed for PPTX→PDF→JPG.

## Key Content (جلسه ۱ — جزوه مقدمات، ۵۸ صفحه)
- **تز اصلی:** آگاهی، فرکانس و اعتقاد عناصر بنیادین واقعیت‌اند (نه محصول ماده).
- **۵ اصل:** خروج از سامانه (بُعد فرکانس)، فیزیک ایمان (همدوسی/نویز شک)، نیروی محرکه سه‌گانه (انسان+کوپلر+هدف)، نگنتروپی (پینگ‌پونگ)، فرکانس صفر و DNA سه‌گانه.
- **۷ سنگ (کوپلر):** الماس(۱) یاقوت کبود(۲) یاقوت سرخ(۳) اوپال(۴) زمرد(۵) فیروزه(۶) توپاز(۷).
- **۶۳ مرحله آموزشی + ۵۳ نکته اخلاقی** (نماز، صداقت، رازداری، پرهیز از شبه‌علوم و احضار، کنترل افکار).
- **کاربردها:** مشاوره شناختی، کمک‌درمانی فرکانسی (با رعایت مرز درمان رسمی)، جست‌وجوگری، موارد خاص.
- **مرجع نهایی:** قرآن و احادیث معتبر؛ هر آموزه‌ای که مطابقت نداشته باشد رد می‌شود.
