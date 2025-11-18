cmake_minimum_required(VERSION 3.10)
project(pqcrypto_kyber_native)

set(CMAKE_C_STANDARD 11)

# Collect PQClean portable 'clean' implementation sources for ml-kem-768 (Kyber768)
file(GLOB_RECURSE PQCLEAN_SOURCES RELATIVE ${CMAKE_CURRENT_SOURCE_DIR}
    "pqclean/ml-kem-768/clean/*.c"
)

# Also collect common implementation sources (fips202, randombytes, keccak helpers)
file(GLOB_RECURSE PQCLEAN_COMMON_SOURCES RELATIVE ${CMAKE_CURRENT_SOURCE_DIR}
    "pqclean/common/*.c"
    "pqclean/common/**/*.c"
)

# Exclude x86/AVX-specific implementations (keccak4x) which don't compile for Android ARM targets.
set(PQCLEAN_COMMON_SOURCES_FILTERED "")
foreach(_src IN LISTS PQCLEAN_COMMON_SOURCES)
    string(FIND "${_src}" "keccak4x" _found4)
    string(FIND "${_src}" "keccak2x" _found2)
    if(_found4 EQUAL -1 AND _found2 EQUAL -1)
        list(APPEND PQCLEAN_COMMON_SOURCES_FILTERED "${_src}")
    else()
        message(STATUS "Excluding architecture-specific source: ${_src}")
    endif()
endforeach()

# Add our wrapper and shim which expose the standard crypto_kem_* symbols
set(WRAPPER_SOURCES
    kyber_wrapper.c
    pqclean_shim.c
)

# Create the native library (PQClean sources + wrapper/shim)
add_library(pqcrypto_kyber SHARED ${PQCLEAN_SOURCES} ${PQCLEAN_COMMON_SOURCES_FILTERED} ${WRAPPER_SOURCES})

target_include_directories(pqcrypto_kyber PRIVATE ${CMAKE_CURRENT_SOURCE_DIR} ${CMAKE_CURRENT_SOURCE_DIR}/pqclean/ml-kem-768/clean ${CMAKE_CURRENT_SOURCE_DIR}/pqclean/common)

# Position-independent code
set_target_properties(pqcrypto_kyber PROPERTIES POSITION_INDEPENDENT_CODE ON)

# Ensure symbols are visible for FFI
if (CMAKE_ANDROID_NDK)
    # Android-specific flags
    target_compile_options(pqcrypto_kyber PRIVATE -fPIC)
endif()
