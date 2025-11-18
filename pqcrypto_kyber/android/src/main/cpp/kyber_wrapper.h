#ifndef KYBER_WRAPPER_H
#define KYBER_WRAPPER_H

#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

// Kyber768 sizes
#define KYBER_PUBLIC_KEY_BYTES 1184
#define KYBER_PRIVATE_KEY_BYTES 2400
#define KYBER_CIPHERTEXT_BYTES 1088
#define KYBER_SHARED_SECRET_BYTES 32

// Return 0 on success, non-zero on error
int kyber_keypair(uint8_t *pk, uint8_t *sk);
int kyber_enc(uint8_t *ct, uint8_t *ss, const uint8_t *pk);
int kyber_dec(uint8_t *ss, const uint8_t *ct, const uint8_t *sk);

#ifdef __cplusplus
}
#endif

#endif // KYBER_WRAPPER_H
