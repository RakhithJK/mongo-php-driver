if test "$PHP_MONGODB_CLIENT_SIDE_ENCRYPTION" != "no"; then
  AC_MSG_CHECKING([which crypto library to use for libmongocrypt])
  AC_MSG_RESULT([$PHP_MONGODB_SSL])

  dnl Disable Windows crypto
  AC_SUBST(MONGOCRYPT_ENABLE_CRYPTO_CNG, 0)

  if test "$PHP_MONGODB_SSL" = "darwin"; then
    PHP_MONGODB_CLIENT_SIDE_ENCRYPTION="yes"

    AC_SUBST(MONGOCRYPT_ENABLE_CRYPTO, 1)
    AC_SUBST(MONGOCRYPT_ENABLE_CRYPTO_LIBCRYPTO, 0)
    AC_SUBST(MONGOCRYPT_ENABLE_CRYPTO_COMMON_CRYPTO, 1)
  elif test "$PHP_MONGODB_SSL" = "openssl" -o "$PHP_MONGODB_SSL" = "libressl"; then
    PHP_MONGODB_CLIENT_SIDE_ENCRYPTION="yes"

    AC_SUBST(MONGOCRYPT_ENABLE_CRYPTO, 1)
    AC_SUBST(MONGOCRYPT_ENABLE_CRYPTO_LIBCRYPTO, 1)
    AC_SUBST(MONGOCRYPT_ENABLE_CRYPTO_COMMON_CRYPTO, 0)
  elif test "$PHP_MONGODB_CLIENT_SIDE_ENCRYPTION" = "auto"; then
    PHP_MONGODB_CLIENT_SIDE_ENCRYPTION="no"

    AC_MSG_RESULT(No SSL library found. Compiling without libmongocrypt. Please specify a library using the --with-mongodb-ssl option)
  else
    AC_MSG_ERROR(Need an SSL library to compile with libmongocrypt. Please specify it using the --with-mongodb-ssl option)
  fi
fi
