---
name: personality-assessment-protocol
description: "Use when profiling a real person or personality assessment."
version: 1.0.0
author: Hermes Agent
license: MIT
platforms: [linux, macos, windows]
metadata:
  hermes:
    tags: [psychology, assessment, ethics, counseling, persian]
---

# Personality Assessment Protocol (پروتکل ارزیابی شخصیت)

## Context
Mina Kavoosi (Telegram, Persian-speaking) runs psychology × Meta-Ontomics integration work. A recurring class of task: "بررسی شخصیت فلانی" (analyze/assess a real person's personality). **Respond in Persian.**

## THE cardinal rule (ethical guardrail)
NEVER fabricate a personality profile of a real person from minimal identifiers (name, birthdate) alone. That is invented data about a real human — harmful in a counseling context, and it violates the jozve's own rules (رازداری، پرهیز از کنجکاوی بیجا). The «دیدن» (seeing/checking) ability in the Meta-Ontomics training is a trained human skill the assistant does NOT possess. State this honestly and immediately, then offer concrete alternatives — do not silently produce a profile.

## Offer these 4 alternatives (user picks)
1. **Analysis from real data**: user provides interview answers / filled questionnaires (with the person's consent) → build full profile from real evidence.
2. **Clearly-labeled hypothetical case**: for practice/exam purposes, mark explicitly «فرضی».
3. **Assessment protocol + presentation template**: structured protocol + 12-slide deck with amber badges «در انتظار داده واقعی» on every data-dependent section (this was Mina's chosen path).
4. **Interview questionnaire only**: structured questions based on the training method.

## Structured assessment pipeline (from «آموزش دیدن» jozve, جلسه ۲)
1. **Ethics first**: consent (رضایت آگاهانه), confidentiality (رازداری/امانتداری), start with توکل/بسم الله, no judgment, no خودسرزنشگری.
2. **Data collection**: structured interview + validated instruments (RSE self-esteem, GSES self-efficacy, NEO-PI-R/FFI Big Five, MAAS mindfulness, SWLS life satisfaction, SCS self-compassion, attachment style).
3. **Dimensions to cover** (jozve list): confidence, decision-making, communication, social/financial/emotional status, inner temperament, attraction/influence, views of self/others, financial success, obstacles, life history, positive/negative material & organic factors.
4. **Root-cause analysis**: 5-Whys per pattern → origins (تربیتی/تجربی/الگویی/ادراکی).
5. **Synthesis**: 4 axes — دروننگری، بروننگری، زماننگری، معنا.
6. **Prioritization**: impact/urgency matrix ("چه چیزی برای بهتر شدن آینده مهمتر است؟").
7. **Two future scenarios**: if person acts vs not (respect their choice; maybe they don't need change).
8. **Triangulation**: 3 viewpoints — خود شخص، اطرافیان، ارزیاب.
9. **Action plan**: short/mid/long-term steps + tracking tools.
10. **Closing**: confidentiality, alignment with official therapy, referral for clinical cases.

## Presentation pattern (12 slides, dark+gold theme)
Title (بسم الله) → ethics/method → verified identifiers (only what is documented) → strengths checklist → weaknesses checklist → root-cause → synthesis → prioritization → two scenarios → 3 viewpoints → action plan → closing with motto. Any section lacking real data gets an amber badge: «در انتظار داده واقعی». Full mapping table: `references/amozesh-didan-16-steps.md`.

## Pitfalls
- Do NOT invent قوتها/ضعفها/ریشهها for a real named person — fill only from supplied data.
- Do NOT give clinical diagnoses; refer to licensed professionals for clinical cases.
- First-look note-taking (jozve: record the first thing seen, like a test answer); don't re-check the same person repeatedly (گيجکننده); never check when tired.
- Same-name/similar-face confusion doesn't matter — follow the protocol.
- If stuck: «بسمالله» and restart the step.

## Verified example artifacts (جلسه ۲)
- Protocol doc: `/data/workspace/meta-ontomics/protokol-arz-yabi-didan.md`
- Deck: `/data/workspace/meta-ontomics/barresi-shakhsiyat-mahnaz.pptx` (+ .pdf) — 12 slides, مهناز (۱۳۶۷), structure verified via pdftotext keyword counts.
