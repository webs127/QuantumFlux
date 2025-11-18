#include "kyber_wrapper.h"
#include <string.h>

// This C wrapper expects that the PQClean Kyber768 implementation
// provides the following functions with these signatures:
//   int crypto_kem_keypair(unsigned char *pk, unsigned char *sk);
//   int crypto_kem_enc(unsigned char *ct, unsigned char *ss, const unsigned char *pk);
//   int crypto_kem_dec(unsigned char *ss, const unsigned char *ct, const unsigned char *sk);

// We declare them here as extern so the PQClean sources can be linked in.
extern int crypto_kem_keypair(unsigned char *pk, unsigned char *sk);
extern int crypto_kem_enc(unsigned char *ct, unsigned char *ss, const unsigned char *pk);
extern int crypto_kem_dec(unsigned char *ss, const unsigned char *ct, const unsigned char *sk);

int kyber_keypair(uint8_t *pk, uint8_t *sk) {
    if (!pk || !sk) return -1;
    // Zero buffers to be safe
    memset(pk, 0, KYBER_PUBLIC_KEY_BYTES);
    memset(sk, 0, KYBER_PRIVATE_KEY_BYTES);
    int r = crypto_kem_keypair(pk, sk);
    return r;
}

int kyber_enc(uint8_t *ct, uint8_t *ss, const uint8_t *pk) {
    if (!ct || !ss || !pk) return -1;
    memset(ct, 0, KYBER_CIPHERTEXT_BYTES);
    memset(ss, 0, KYBER_SHARED_SECRET_BYTES);
    int r = crypto_kem_enc(ct, ss, pk);
    return r;
}

int kyber_dec(uint8_t *ss, const uint8_t *ct, const uint8_t *sk) {
    if (!ss || !ct || !sk) return -1;
    memset(ss, 0, KYBER_SHARED_SECRET_BYTES);
    int r = crypto_kem_dec(ss, ct, sk);
    return r;
}
