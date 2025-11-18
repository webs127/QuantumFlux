#include "kyber_wrapper.h"
#include <string.h>

// Declarations of PQClean API to be linked in
extern "C" {
    int crypto_kem_keypair(unsigned char *pk, unsigned char *sk);
    int crypto_kem_enc(unsigned char *ct, unsigned char *ss, const unsigned char *pk);
    int crypto_kem_dec(unsigned char *ss, const unsigned char *ct, const unsigned char *sk);
}

int kyber_keypair(uint8_t *pk, uint8_t *sk) {
    if (!pk || !sk) return -1;
    memset(pk, 0, KYBER_PUBLIC_KEY_BYTES);
    memset(sk, 0, KYBER_PRIVATE_KEY_BYTES);
    return crypto_kem_keypair(pk, sk);
}

int kyber_enc(uint8_t *ct, uint8_t *ss, const uint8_t *pk) {
    if (!ct || !ss || !pk) return -1;
    memset(ct, 0, KYBER_CIPHERTEXT_BYTES);
    memset(ss, 0, KYBER_SHARED_SECRET_BYTES);
    return crypto_kem_enc(ct, ss, pk);
}

int kyber_dec(uint8_t *ss, const uint8_t *ct, const uint8_t *sk) {
    if (!ss || !ct || !sk) return -1;
    memset(ss, 0, KYBER_SHARED_SECRET_BYTES);
    return crypto_kem_dec(ss, ct, sk);
}
