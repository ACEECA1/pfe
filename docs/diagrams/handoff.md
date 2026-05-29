# Agent Handoff: Presentation Creation  
**Project:** Djezzy Talent Portal (CV Grading System)  
**Date:** 2026-05-13  
**Prepared for:** Presentation-generation agent

## 1) Mission
Create a polished presentation that explains what this project is, how it works end-to-end, what is implemented today, and why it matters for recruitment teams.

Default target: mixed audience (product/business + technical reviewers).  
Default output: 12-15 slides + speaker notes.

---

## 2) Project Summary (Use this story)
This project is an AI-assisted recruitment platform where:
1. HR creates job offers from raw text.
2. Candidates apply by uploading PDF CVs.
3. The system extracts CV data, scores candidate-job fit, and generates interview guidance.
4. HR/admin users review pipelines, scores, and detailed evaluations from a role-based dashboard.

Core value proposition:
- Faster CV screening
- Structured, consistent evaluation
- Better interview preparation (technical + HR questions)

---

## 3) Tech Stack & Architecture
### Frontend
- React 18 + Vite 6 SPA
- Role-based routes/shell (admin, HR, candidate)
- API envelope handling and token refresh logic
- Path: `cv-grading-system-frontend\src\app\`

### Backend
- Spring Boot 3.3.5, Java 17
- Spring Security + JWT + refresh tokens
- JPA/Hibernate + MySQL
- Async workflow/event-driven processing
- Path: `backend\src\main\java\org\djezzy\pfe\`

### Data & Workflow
- MySQL schema with users, job offers, structured JDs, CVs, evaluations, scores, interview questions
- External AI/OCR + n8n integration (or native fallback workflow mode)
- Key schema file: `database\schema.sql`

---

## 4) End-to-End Flows to Explain
## A) Job Offer Creation Flow (HR/Admin)
1. `POST /api/hr/job-offers` creates offer in `DRAFT`
2. Async JD parsing is triggered
3. Parsed structured JD is applied
4. Status becomes `PUBLISHED` (or `FAILED` if parsing fails)
5. Retry path available via `/api/hr/job-offers/{id}/retry`

Evidence:
- `backend\src\main\java\org\djezzy\pfe\controller\job\JobOfferController.java`
- `backend\src\main\java\org\djezzy\pfe\service\job\JobOfferService.java`
- `backend\src\main\java\org\djezzy\pfe\service\job\LlmParsingService.java`

## B) Candidate Application & Evaluation Flow
1. Candidate uploads PDF CV: `POST /api/candidate/job-offers/{jobOfferId}/cv`
2. CV + evaluation records created (`UPLOADED`, `WAITING`)
3. Event listener triggers async processing
4. OCR extraction runs
5. Evaluation workflow runs (n8n or native)
6. Callback writes profile data, match score, technical and HR questions
7. Final statuses become `EVALUATED` + `SCORED`

Evidence:
- `backend\src\main\java\org\djezzy\pfe\service\evaluation\CandidateService.java`
- `backend\src\main\java\org\djezzy\pfe\service\evaluation\EvaluationEventListener.java`
- `backend\src\main\java\org\djezzy\pfe\service\evaluation\AsyncWorkflowService.java`
- `backend\src\main\java\org\djezzy\pfe\service\system\CallbackService.java`

---

## 5) Role-Based Product Surfaces (Current)
### Admin
- Dashboard metrics
- HR approvals
- System health view
- Routes: `/admin/dashboard`, `/admin/approvals`, `/admin/health`, `/admin/jobs`

### HR
- Dashboard
- Create/manage job offers
- Candidate pipeline
- Evaluation detail + CV download
- Routes: `/hr/dashboard`, `/hr/create-job`, `/hr/jobs`, `/hr/pipeline`

### Candidate
- Job board
- Job details + apply modal (PDF upload)
- My applications and score visibility
- Routes: `/candidate/jobs`, `/candidate/applications`

Evidence:
- `cv-grading-system-frontend\src\app\App.tsx`
- `cv-grading-system-frontend\src\app\components\admin-views.tsx`
- `cv-grading-system-frontend\src\app\components\hr-views.tsx`
- `cv-grading-system-frontend\src\app\components\candidate-views.tsx`

---

## 6) AI/Automation Story
Two runtime modes:
1. **n8n mode** (`app.automation.use-n8n=true`): backend dispatches webhook payloads to n8n.
2. **native mode** (`app.automation.use-n8n=false`): backend runs a multi-stage pipeline internally using OpenRouter calls, then directly applies callback mapping.

Mention this as a strategic design decision:
- External orchestration flexibility (n8n)
- Internal fallback resiliency (native mode)

Evidence:
- `backend\src\main\java\org\djezzy\pfe\service\workflow\N8nWorkflowServiceImpl.java`
- `backend\src\main\java\org\djezzy\pfe\service\workflow\NativeWorkflowServiceImpl.java`
- `Project N8N Workflow.json`

---

## 7) Security & Reliability Points
- JWT auth + refresh token flow
- Role-based route security (ADMIN/HR/CANDIDATE)
- Callback endpoints protected by `X-API-KEY` filter
- Standard API envelope + centralized exception handling
- Integration tests cover critical auth, role, callback, and upload flows

Evidence:
- `backend\src\main\java\org\djezzy\pfe\config\SecurityConfig.java`
- `backend\src\main\java\org\djezzy\pfe\filter\ApiKeyAuthenticationFilter.java`
- `backend\src\main\java\org\djezzy\pfe\controller\system\GlobalExceptionHandler.java`
- `backend\src\test\java\org\djezzy\pfe\BackendFlowIntegrationTests.java`

---

## 8) Known Gaps / Honest Framing (Include one slide)
Present as “Current limitations and next iteration priorities”:
- Some UX requirements in design handoff are partially implemented (example: public unauthenticated job-board-first experience and richer admin aggregate stats).
- Candidate submission list currently relies on manual refresh patterns rather than robust polling loop to terminal states.
- External dependencies (OCR/LLM/webhooks) introduce latency and failure scenarios.
- Repository currently contains sensitive config material in environment/workflow artifacts; treat as security debt and redact in all presentation artifacts.

Evidence:
- `backend\UI_UX_DESIGN_HANDOFF.md`
- `cv-grading-system-frontend\src\app\components\candidate-views.tsx`
- `backend\src\main\resources\application.properties`

---

## 9) Branding & Visual Constraints for Slides
Use the same product language:
- Brand color: **#ED1C24** (Djezzy red)
- Clean SaaS style, white/gray neutral background
- Data-dense but minimal layout
- **No profile pictures/avatars**

Evidence:
- `backend\UI_UX_DESIGN_HANDOFF.md`

---

## 10) Recommended Slide Blueprint
| Slide | Title | Key Message | Visual / Asset |
|---|---|---|---|
| 1 | Title | Djezzy Talent Portal: AI-Powered CV Evaluation | Product name + one-line value |
| 2 | Problem | Hiring teams face slow, inconsistent screening | Problem statement diagram |
| 3 | Solution | Unified portal for HR/admin/candidates | 3-role product map |
| 4 | Architecture | Frontend + backend + DB + AI workflow | System architecture diagram |
| 5 | Job Offer AI Flow | Raw JD -> structured JD -> published role | Sequence diagram |
| 6 | Candidate Evaluation Flow | CV upload -> OCR -> scoring -> interview guide | Sequence/status pipeline |
| 7 | Role-Based UX | Admin, HR, candidate workflows | 3-column screenshot collage |
| 8 | AI Intelligence Output | Score, matched/missing skills, recommendations, questions | Evaluation detail screenshot |
| 9 | Security & Governance | JWT, RBAC, callback API key, error envelope | Shield checklist visual |
| 10 | Reliability & Testing | Integration coverage for core flows | Test flow summary |
| 11 | Current Limitations | Transparent view of known gaps | Risk/mitigation table |
| 12 | Roadmap | Next sprint priorities | Prioritized roadmap |
| 13 | Demo Walkthrough (optional) | Click-path through key user journeys | Step-by-step demo map |
| 14 | Closing | Business impact + technical readiness | KPI placeholders + conclusion |

---

## 11) Demo Script (If live demo slide included)
1. Login as HR -> create job offer from raw text.
2. Show status lifecycle (`DRAFT` to `PUBLISHED`) and structured fields.
3. Login as candidate -> apply with PDF CV.
4. Open HR pipeline -> show evaluation entry and score.
5. Open evaluation detail -> matched/missing skills, recommendation, interview questions.
6. Login as admin -> review approvals + system health.

Fallback for unstable external AI dependencies:
- Use mock endpoints and/or pre-existing evaluated records for deterministic demo.
- Mock endpoints: `/api/mock/ocr` and `/api/mock/n8n/evaluate`

---

## 12) Non-Negotiable Content Rules for the Presentation Agent
1. **Do not expose secrets** (API keys, tokens, passwords, raw `.env` values) in slides, notes, or screenshots.
2. Do not claim metrics not directly measured in this repository.
3. Mark roadmap items clearly as proposed/future.
4. Keep technical claims grounded in the source files listed here.
5. Use consistent terminology: CV, evaluation, structured JD, match score, HR approvals.

---

## 13) Source Map (Primary Truth Files)
- Backend API/security/workflow:
  - `backend\src\main\java\org\djezzy\pfe\controller\`
  - `backend\src\main\java\org\djezzy\pfe\service\`
  - `backend\src\main\java\org\djezzy\pfe\config\`
  - `backend\src\main\resources\application.properties`
- Frontend UX/routes:
  - `cv-grading-system-frontend\src\app\App.tsx`
  - `cv-grading-system-frontend\src\app\api.ts`
  - `cv-grading-system-frontend\src\app\components\`
- Workflow/model:
  - `Project N8N Workflow.json`
  - `database\schema.sql`
- Supplemental context:
  - `backend\UI_UX_DESIGN_HANDOFF.md`
  - `backend\IMPLEMENTATION_SUMMARY.md`
  - `backend\src\test\java\org\djezzy\pfe\BackendFlowIntegrationTests.java`

---

## 14) Delivery Checklist for the Presentation Agent
- [ ] Build a 12-15 slide deck with speaker notes.
- [ ] Include at least one architecture diagram and one end-to-end sequence diagram.
- [ ] Include role-based UX evidence (admin/HR/candidate).
- [ ] Include one limitations/roadmap slide with honest framing.
- [ ] Ensure all images/text are secret-safe (fully redacted where needed).
- [ ] Keep visual style aligned with Djezzy branding and no-avatar constraint.

