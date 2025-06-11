;; Talent Ecosystem Engine
;; A distributed talent ecosystem connecting skilled professionals with innovation opportunities

;; ==============================================
;; ERROR CODES AND SYSTEM CONSTANTS
;; ==============================================

(define-constant ERR-ENTITY-NOT-DISCOVERABLE (err u404))
(define-constant ERR-DUPLICATE-REGISTRATION (err u409))
(define-constant ERR-VALIDATION-IDENTITY (err u400))
(define-constant ERR-VALIDATION-GEOGRAPHY (err u401))
(define-constant ERR-VALIDATION-BACKGROUND (err u402))
(define-constant ERR-VALIDATION-OPPORTUNITY (err u403))
(define-constant ERR-MISSING-RECORD (err u404))

;; ==============================================
;; DATA VAULT STRUCTURES
;; ==============================================

;; Talent repository - stores professional profiles and their expertise
(define-map talent-repository
    principal
    {
        identity-label: (string-ascii 100),
        expertise-domains: (list 10 (string-ascii 50)),
        geographical-presence: (string-ascii 100),
        professional-narrative: (string-ascii 500)
    }
)

;; Enterprise repository - stores business entity information
(define-map enterprise-repository
    principal
    {
        business-label: (string-ascii 100),
        sector-classification: (string-ascii 50),
        geographical-presence: (string-ascii 100)
    }
)

;; Opportunity repository - stores project and collaboration listings
(define-map opportunity-repository
    principal
    {
        opportunity-headline: (string-ascii 100),
        opportunity-narrative: (string-ascii 500),
        opportunity-architect: principal,
        geographical-constraint: (string-ascii 100),
        expertise-prerequisites: (list 10 (string-ascii 50))
    }
)
