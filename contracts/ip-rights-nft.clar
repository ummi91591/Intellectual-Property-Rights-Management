;; IP Rights NFT Contract

(define-non-fungible-token ip-rights uint)

(define-map ip-metadata
  { token-id: uint }
  {
    owner: principal,
    ip-type: (string-ascii 20),
    title: (string-utf8 100),
    description: (string-utf8 500),
    registration-number: (string-ascii 50),
    creation-date: uint,
    expiration-date: uint
  }
)

(define-data-var last-token-id uint u0)

(define-public (mint (ip-type (string-ascii 20)) (title (string-utf8 100)) (description (string-utf8 500)) (registration-number (string-ascii 50)) (expiration-date uint))
  (let
    (
      (token-id (+ (var-get last-token-id) u1))
    )
    (try! (nft-mint? ip-rights token-id tx-sender))
    (map-set ip-metadata
      { token-id: token-id }
      {
        owner: tx-sender,
        ip-type: ip-type,
        title: title,
        description: description,
        registration-number: registration-number,
        creation-date: block-height,
        expiration-date: expiration-date
      }
    )
    (var-set last-token-id token-id)
    (ok token-id)
  )
)

(define-read-only (get-ip-metadata (token-id uint))
  (ok (unwrap! (map-get? ip-metadata { token-id: token-id }) (err u404)))
)

(define-public (transfer (token-id uint) (recipient principal))
  (begin
    (try! (nft-transfer? ip-rights token-id tx-sender recipient))
    (let
      (
        (metadata (unwrap! (map-get? ip-metadata { token-id: token-id }) (err u404)))
      )
      (map-set ip-metadata
        { token-id: token-id }
        (merge metadata { owner: recipient })
      )
      (ok true)
    )
  )
)

