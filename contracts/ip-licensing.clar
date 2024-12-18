;; IP Licensing and Royalty Distribution Contract

(define-map licenses
  { license-id: uint }
  {
    ip-id: uint,
    licensee: principal,
    start-date: uint,
    end-date: uint,
    royalty-rate: uint,
    total-paid: uint
  }
)

(define-map royalties
  { ip-id: uint }
  { total-royalties: uint }
)

(define-data-var last-license-id uint u0)

(define-public (create-license (ip-id uint) (licensee principal) (duration uint) (royalty-rate uint))
  (let
    (
      (license-id (+ (var-get last-license-id) u1))
    )
    (map-set licenses
      { license-id: license-id }
      {
        ip-id: ip-id,
        licensee: licensee,
        start-date: block-height,
        end-date: (+ block-height duration),
        royalty-rate: royalty-rate,
        total-paid: u0
      }
    )
    (var-set last-license-id license-id)
    (ok license-id)
  )
)

(define-public (pay-royalty (license-id uint) (amount uint))
  (let
    (
      (license (unwrap! (map-get? licenses { license-id: license-id }) (err u404)))
      (ip-id (get ip-id license))
      (royalty-amount (/ (* amount (get royalty-rate license)) u100))
    )
    (map-set licenses
      { license-id: license-id }
      (merge license { total-paid: (+ (get total-paid license) royalty-amount) })
    )
    (map-set royalties
      { ip-id: ip-id }
      { total-royalties: (+ (default-to u0 (get total-royalties (map-get? royalties { ip-id: ip-id }))) royalty-amount) }
    )
    (ok royalty-amount)
  )
)

(define-read-only (get-license (license-id uint))
  (ok (unwrap! (map-get? licenses { license-id: license-id }) (err u404)))
)

(define-read-only (get-royalties (ip-id uint))
  (ok (default-to { total-royalties: u0 } (map-get? royalties { ip-id: ip-id })))
)

