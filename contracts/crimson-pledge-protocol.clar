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

;; ==============================================
;; TALENT PROFILE MANAGEMENT FUNCTIONS
;; ==============================================

;; Update existing talent profile information
(define-public (update-talent-profile 
    (identity-label (string-ascii 100))
    (expertise-domains (list 10 (string-ascii 50)))
    (geographical-presence (string-ascii 100))
    (professional-narrative (string-ascii 500)))
    (let
        (
            (profile-owner tx-sender)
            (existing-profile (map-get? talent-repository profile-owner))
        )
        ;; Verify profile exists
        (if (is-some existing-profile)
            (begin
                ;; Validate required information
                (if (or (is-eq identity-label "")
                        (is-eq geographical-presence "")
                        (is-eq (len expertise-domains) u0)
                        (is-eq professional-narrative ""))
                    (err ERR-VALIDATION-BACKGROUND)
                    (begin
                        ;; Update the talent profile
                        (map-set talent-repository profile-owner
                            {
                                identity-label: identity-label,
                                expertise-domains: expertise-domains,
                                geographical-presence: geographical-presence,
                                professional-narrative: professional-narrative
                            }
                        )
                        (ok "Talent profile successfully updated with new information.")
                    )
                )
            )
            (err ERR-MISSING-RECORD)
        )
    )
)


;; Register a new talent profile in the ecosystem
(define-public (register-talent-profile 
    (identity-label (string-ascii 100))
    (expertise-domains (list 10 (string-ascii 50)))
    (geographical-presence (string-ascii 100))
    (professional-narrative (string-ascii 500)))
    (let
        (
            (profile-owner tx-sender)
            (existing-profile (map-get? talent-repository profile-owner))
        )
        ;; Verify unique registration
        (if (is-none existing-profile)
            (begin
                ;; Validate required information
                (if (or (is-eq identity-label "")
                        (is-eq geographical-presence "")
                        (is-eq (len expertise-domains) u0)
                        (is-eq professional-narrative ""))
                    (err ERR-VALIDATION-BACKGROUND)
                    (begin
                        ;; Create the talent profile
                        (map-set talent-repository profile-owner
                            {
                                identity-label: identity-label,
                                expertise-domains: expertise-domains,
                                geographical-presence: geographical-presence,
                                professional-narrative: professional-narrative
                            }
                        )
                        (ok "Talent profile successfully registered in the ecosystem.")
                    )
                )
            )
            (err ERR-DUPLICATE-REGISTRATION)
        )
    )
)

;; Remove talent profile from ecosystem
(define-public (dissolve-talent-profile)
    (let
        (
            (profile-owner tx-sender)
            (existing-profile (map-get? talent-repository profile-owner))
        )
        ;; Verify profile exists
        (if (is-some existing-profile)
            (begin
                ;; Remove the talent profile
                (map-delete talent-repository profile-owner)
                (ok "Talent profile successfully removed from ecosystem.")
            )
            (err ERR-MISSING-RECORD)
        )
    )
)

;; ==============================================
;; ENTERPRISE PROFILE MANAGEMENT FUNCTIONS
;; ==============================================

;; Register a new enterprise entity in the ecosystem
(define-public (register-enterprise-profile 
    (business-label (string-ascii 100))
    (sector-classification (string-ascii 50))
    (geographical-presence (string-ascii 100)))
    (let
        (
            (enterprise-owner tx-sender)
            (existing-profile (map-get? enterprise-repository enterprise-owner))
        )
        ;; Verify unique registration
        (if (is-none existing-profile)
            (begin
                ;; Validate required fields
                (if (or (is-eq business-label "")
                        (is-eq sector-classification "")
                        (is-eq geographical-presence ""))
                    (err ERR-VALIDATION-GEOGRAPHY)
                    (begin
                        ;; Create enterprise profile
                        (map-set enterprise-repository enterprise-owner
                            {
                                business-label: business-label,
                                sector-classification: sector-classification,
                                geographical-presence: geographical-presence
                            }
                        )
                        (ok "Enterprise profile successfully registered in ecosystem.")
                    )
                )
            )
            (err ERR-DUPLICATE-REGISTRATION)
        )
    )
)

;; Update existing enterprise entity information
(define-public (update-enterprise-profile 
    (business-label (string-ascii 100))
    (sector-classification (string-ascii 50))
    (geographical-presence (string-ascii 100)))
    (let
        (
            (enterprise-owner tx-sender)
            (existing-profile (map-get? enterprise-repository enterprise-owner))
        )
        ;; Verify profile exists
        (if (is-some existing-profile)
            (begin
                ;; Validate required fields
                (if (or (is-eq business-label "")
                        (is-eq sector-classification "")
                        (is-eq geographical-presence ""))
                    (err ERR-VALIDATION-GEOGRAPHY)
                    (begin
                        ;; Update enterprise profile
                        (map-set enterprise-repository enterprise-owner
                            {
                                business-label: business-label,
                                sector-classification: sector-classification,
                                geographical-presence: geographical-presence
                            }
                        )
                        (ok "Enterprise profile successfully updated with new information.")
                    )
                )
            )
            (err ERR-MISSING-RECORD)
        )
    )
)

;; Remove enterprise entity from ecosystem
(define-public (dissolve-enterprise-profile)
    (let
        (
            (enterprise-owner tx-sender)
            (existing-profile (map-get? enterprise-repository enterprise-owner))
        )
        ;; Verify profile exists
        (if (is-some existing-profile)
            (begin
                ;; Remove the enterprise profile
                (map-delete enterprise-repository enterprise-owner)
                (ok "Enterprise profile successfully removed from ecosystem.")
            )
            (err ERR-MISSING-RECORD)
        )
    )
)

;; ==============================================
;; OPPORTUNITY MANAGEMENT FUNCTIONS
;; ==============================================

;; Create a new opportunity listing in the ecosystem
(define-public (broadcast-opportunity 
    (opportunity-headline (string-ascii 100))
    (opportunity-narrative (string-ascii 500))
    (geographical-constraint (string-ascii 100))
    (expertise-prerequisites (list 10 (string-ascii 50))))
    (let
        (
            (opportunity-creator tx-sender)
            (existing-opportunity (map-get? opportunity-repository opportunity-creator))
        )
        ;; Verify no existing opportunity
        (if (is-none existing-opportunity)
            (begin
                ;; Validate required fields
                (if (or (is-eq opportunity-headline "")
                        (is-eq opportunity-narrative "")
                        (is-eq geographical-constraint "")
                        (is-eq (len expertise-prerequisites) u0))
                    (err ERR-VALIDATION-OPPORTUNITY)
                    (begin
                        ;; Create the opportunity listing
                        (map-set opportunity-repository opportunity-creator
                            {
                                opportunity-headline: opportunity-headline,
                                opportunity-narrative: opportunity-narrative,
                                opportunity-architect: opportunity-creator,
                                geographical-constraint: geographical-constraint,
                                expertise-prerequisites: expertise-prerequisites
                            }
                        )
                        (ok "Opportunity successfully broadcast to ecosystem.")
                    )
                )
            )
            (err ERR-DUPLICATE-REGISTRATION)
        )
    )
)

;; Update an existing opportunity in the ecosystem
(define-public (revise-opportunity 
    (opportunity-headline (string-ascii 100))
    (opportunity-narrative (string-ascii 500))
    (geographical-constraint (string-ascii 100))
    (expertise-prerequisites (list 10 (string-ascii 50))))
    (let
        (
            (opportunity-creator tx-sender)
            (existing-opportunity (map-get? opportunity-repository opportunity-creator))
        )
        ;; Verify opportunity exists
        (if (is-some existing-opportunity)
            (begin
                ;; Validate required fields
                (if (or (is-eq opportunity-headline "")
                        (is-eq opportunity-narrative "")
                        (is-eq geographical-constraint "")
                        (is-eq (len expertise-prerequisites) u0))
                    (err ERR-VALIDATION-OPPORTUNITY)
                    (begin
                        ;; Update the opportunity listing
                        (map-set opportunity-repository opportunity-creator
                            {
                                opportunity-headline: opportunity-headline,
                                opportunity-narrative: opportunity-narrative,
                                opportunity-architect: opportunity-creator,
                                geographical-constraint: geographical-constraint,
                                expertise-prerequisites: expertise-prerequisites
                            }
                        )
                        (ok "Opportunity successfully revised in ecosystem.")
                    )
                )
            )
            (err ERR-MISSING-RECORD)
        )
    )
)

;; Remove an existing opportunity from the ecosystem
(define-public (withdraw-opportunity)
    (let
        (
            (opportunity-creator tx-sender)
            (existing-opportunity (map-get? opportunity-repository opportunity-creator))
        )
        ;; Verify opportunity exists
        (if (is-some existing-opportunity)
            (begin
                ;; Remove the opportunity listing
                (map-delete opportunity-repository opportunity-creator)
                (ok "Opportunity successfully withdrawn from ecosystem.")
            )
            (err ERR-MISSING-RECORD)
        )
    )
)

;; ==============================================
;; DATA RETRIEVAL FUNCTIONS
;; ==============================================

;; Retrieve specific opportunity details
(define-read-only (query-opportunity-details (opportunity-id principal))
    (match (map-get? opportunity-repository opportunity-id)
        opportunity-data (ok opportunity-data)
        ERR-ENTITY-NOT-DISCOVERABLE
    )
)

;; Additional data functions could be added here to extend functionality
;; For instance:
;; - Filtering opportunities by expertise domain
;; - Filtering talents by geographical presence
;; - Searching enterprises by sector-classification
;; - And more advanced ecosystem mechanics


