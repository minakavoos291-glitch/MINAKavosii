---
name: exam-design
description: "Use when creating an exam and answer key from material."
version: 1.0.0
author: Hermes Agent
license: MIT
platforms: [linux, macos, windows]
metadata:
  hermes:
    tags: [exam, assessment, quiz, training, answer-key]
---

# Exam Design from Source Material

Used in staged training flows ("learn this booklet, test me, then next
stage"): read the source fully, then produce a graded exam that proves
mastery and gates advancement.

## Workflow
1. Read the ENTIRE source (extract PDF → text file, read in chunks). Map every
   chapter/section; no chapter may be absent from the exam.
2. Design 4 sections with increasing depth:
   - MCQ (1 pt each) — factual recall from the text.
   - Short-answer (2 pt) — explain concepts in 2-4 sentences.
   - Analytical (3 pt) — synthesis/critique; require both-sides answers
     (e.g. "explain X" + "is this explanation or reframing?").
   - Applied (3 pt) — scenario/case questions using the material's own terms.
3. Score bands: e.g. 62 total → ≥50 pass / 35-49 review / <35 restudy.
4. Write TWO files: `azmoon-<topic>.md` (exam, no answers) and
   `kelid-<topic>.md` (answer key, separate). Keep them in the project folder.

## Critical pitfall: answer distribution
The first draft keyed almost every MCQ to option "B" (concept-heavy items
naturally land on the same option). Distributing answers is mandatory:
   - Vary correct positions deliberately (A/B/C/D mix).
   - Make distractors plausible and text-derived, not strawmen.
   - Include at least one "negative" item (which is NOT...).
   - The ONE correct-answer-per-question invariant still holds; a uniform
     key is a design flaw, not a guarantee.

## Answer key style
- Table for MCQs with a short justification in parentheses.
- Model answers for short questions with the source's key phrases (partial
  credit).
- Analytical: list grading criteria (depth + fidelity to source + seeing both
  sides), and accept well-argued disagreement.
- Applied: enumerate the checklist items the source itself requires
  (ethics, procedures, boundaries).
- If the user is the exam-taker, the key is for the teacher/grader — mark it
  clearly and keep the files separate.

## Follow-up
Offer both the full exam and a quick self-quiz; on pass, tee up the next
stage. If the source is a religious/spiritual curriculum, keep analysis
respectful but rigorous: the exam should test comprehension of the material
as written, not endorsement of it.
