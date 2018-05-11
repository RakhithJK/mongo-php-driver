dnl config.m4 for extension mongodb
PHP_ARG_ENABLE([mongodb],
               [whether to enable MongoDB support],
               [AC_HELP_STRING([--enable-mongodb],
                               [Enable MongoDB support])])

if test "$PHP_MONGODB" != "no"; then
  dnl Check PHP version is compatible with this extension
  AC_MSG_CHECKING([PHP version])

  PHP_MONGODB_PHP_VERSION=$PHP_VERSION
  PHP_MONGODB_PHP_VERSION_ID=$PHP_VERSION_ID

  if test -z "$PHP_MONGODB_PHP_VERSION"; then
    if test -z "$PHP_CONFIG"; then
      AC_MSG_ERROR([php-config not found])
    fi
    PHP_MONGODB_PHP_VERSION=`${PHP_CONFIG} --version`
    PHP_MONGODB_PHP_VERSION_ID=`echo "${PHP_MONGODB_PHP_VERSION}" | $AWK 'BEGIN { FS = "."; } { printf "%d", ([$]1 * 100 + [$]2) * 100 + [$]3;}'`
  fi

  AC_MSG_RESULT($PHP_MONGODB_PHP_VERSION)
  if test "$PHP_MONGODB_PHP_VERSION_ID" -lt "50500"; then
    AC_MSG_ERROR([not supported. Need a PHP version >= 5.5.0 (found $PHP_MONGODB_PHP_VERSION)])
  fi

  PHP_ARG_ENABLE([developer-flags],
                 [whether to enable developer build flags],
                 [AC_HELP_STRING([--enable-developer-flags],
                                 [MongoDB: Enable developer flags [default=no]])],
                 [no],
                 [no])

  if test "$PHP_DEVELOPER_FLAGS" = "yes"; then
    dnl Warn about functions which might be candidates for format attributes
    PHP_CHECK_GCC_ARG(-Wmissing-format-attribute,       _MAINTAINER_CFLAGS="$_MAINTAINER_CFLAGS -Wmissing-format-attribute")
    dnl Avoid duplicating values for an enum
    PHP_CHECK_GCC_ARG(-Wduplicate-enum,                 _MAINTAINER_CFLAGS="$_MAINTAINER_CFLAGS -Wduplicate-enum")
    dnl Warns on mismatches between #ifndef and #define header guards
    PHP_CHECK_GCC_ARG(-Wheader-guard,                   _MAINTAINER_CFLAGS="$_MAINTAINER_CFLAGS -Wheader-guard")
    dnl logical not of a non-boolean expression
    PHP_CHECK_GCC_ARG(-Wlogical-not-parentheses,        _MAINTAINER_CFLAGS="$_MAINTAINER_CFLAGS -Wlogical-not-parentheses")
    dnl Warn about suspicious uses of logical operators in expressions
    PHP_CHECK_GCC_ARG(-Wlogical-op,                     _MAINTAINER_CFLAGS="$_MAINTAINER_CFLAGS -Wlogical-op")
    dnl memory error detector.
    dnl FIXME: -fsanitize=address,undefined for clang. The PHP_CHECK_GCC_ARG macro isn't happy about that string :(
    PHP_CHECK_GCC_ARG(-fsanitize-address,               _MAINTAINER_CFLAGS="$_MAINTAINER_CFLAGS -fsanitize-address")
    dnl Enable frame debugging
    PHP_CHECK_GCC_ARG(-fno-omit-frame-pointer,          _MAINTAINER_CFLAGS="$_MAINTAINER_CFLAGS -fno-omit-frame-pointer")
    dnl Make sure we don't optimize calls
    PHP_CHECK_GCC_ARG(-fno-optimize-sibling-calls,      _MAINTAINER_CFLAGS="$_MAINTAINER_CFLAGS -fno-optimize-sibling-calls")
    PHP_CHECK_GCC_ARG(-Wlogical-op-parentheses,         _MAINTAINER_CFLAGS="$_MAINTAINER_CFLAGS -Wlogical-op-parentheses")
    PHP_CHECK_GCC_ARG(-Wpointer-bool-conversion,        _MAINTAINER_CFLAGS="$_MAINTAINER_CFLAGS -Wpointer-bool-conversion")
    PHP_CHECK_GCC_ARG(-Wbool-conversion,                _MAINTAINER_CFLAGS="$_MAINTAINER_CFLAGS -Wbool-conversion")
    PHP_CHECK_GCC_ARG(-Wloop-analysis,                  _MAINTAINER_CFLAGS="$_MAINTAINER_CFLAGS -Wloop-analysis")
    PHP_CHECK_GCC_ARG(-Wsizeof-array-argument,          _MAINTAINER_CFLAGS="$_MAINTAINER_CFLAGS -Wsizeof-array-argument")
    PHP_CHECK_GCC_ARG(-Wstring-conversion,              _MAINTAINER_CFLAGS="$_MAINTAINER_CFLAGS -Wstring-conversion")
    PHP_CHECK_GCC_ARG(-Wno-variadic-macros,             _MAINTAINER_CFLAGS="$_MAINTAINER_CFLAGS -Wno-variadic-macros")
    PHP_CHECK_GCC_ARG(-Wno-sign-compare,                _MAINTAINER_CFLAGS="$_MAINTAINER_CFLAGS -Wno-sign-compare")
    PHP_CHECK_GCC_ARG(-fstack-protector,                _MAINTAINER_CFLAGS="$_MAINTAINER_CFLAGS -fstack-protector")
    PHP_CHECK_GCC_ARG(-fno-exceptions,                  _MAINTAINER_CFLAGS="$_MAINTAINER_CFLAGS -fno-exceptions")
    PHP_CHECK_GCC_ARG(-Wformat-security,                _MAINTAINER_CFLAGS="$_MAINTAINER_CFLAGS -Wformat-security")
    PHP_CHECK_GCC_ARG(-Wformat-nonliteral,              _MAINTAINER_CFLAGS="$_MAINTAINER_CFLAGS -Wformat-nonliteral")
    PHP_CHECK_GCC_ARG(-Winit-self,                      _MAINTAINER_CFLAGS="$_MAINTAINER_CFLAGS -Winit-self")
    PHP_CHECK_GCC_ARG(-Wwrite-strings,                  _MAINTAINER_CFLAGS="$_MAINTAINER_CFLAGS -Wwrite-strings")
    PHP_CHECK_GCC_ARG(-Wenum-compare,                   _MAINTAINER_CFLAGS="$_MAINTAINER_CFLAGS -Wenum-compare")
    PHP_CHECK_GCC_ARG(-Wempty-body,                     _MAINTAINER_CFLAGS="$_MAINTAINER_CFLAGS -Wempty-body")
    PHP_CHECK_GCC_ARG(-Wparentheses,                    _MAINTAINER_CFLAGS="$_MAINTAINER_CFLAGS -Wparentheses")
    PHP_CHECK_GCC_ARG(-Wdeclaration-after-statement,    _MAINTAINER_CFLAGS="$_MAINTAINER_CFLAGS -Wdeclaration-after-statement")
    PHP_CHECK_GCC_ARG(-Wmaybe-uninitialized,            _MAINTAINER_CFLAGS="$_MAINTAINER_CFLAGS -Wmaybe-uninitialized")
    PHP_CHECK_GCC_ARG(-Wimplicit-fallthrough,           _MAINTAINER_CFLAGS="$_MAINTAINER_CFLAGS -Wimplicit-fallthrough")
    PHP_CHECK_GCC_ARG(-Werror,                          _MAINTAINER_CFLAGS="$_MAINTAINER_CFLAGS -Werror")
    PHP_CHECK_GCC_ARG(-Wextra,                          _MAINTAINER_CFLAGS="$_MAINTAINER_CFLAGS -Wextra")
    PHP_CHECK_GCC_ARG(-Wno-unused-parameter,            _MAINTAINER_CFLAGS="$_MAINTAINER_CFLAGS -Wno-unused-parameter")
    PHP_CHECK_GCC_ARG(-Wno-unused-but-set-variable,     _MAINTAINER_CFLAGS="$_MAINTAINER_CFLAGS -Wno-unused-but-set-variable")
    PHP_CHECK_GCC_ARG(-Wno-missing-field-initializers,  _MAINTAINER_CFLAGS="$_MAINTAINER_CFLAGS -Wno-missing-field-initializers")

    MAINTAINER_CFLAGS="$_MAINTAINER_CFLAGS"
    STD_CFLAGS="-g -O0 -Wall"
  fi


  PHP_ARG_ENABLE([coverage],
                 [whether to enable code coverage],
                 [AC_HELP_STRING([--enable-coverage],
                                 [MongoDB: Enable developer code coverage information [default=no]])],
                 [no],
                 [no])

  if test "$PHP_COVERAGE" = "yes"; then
      PHP_CHECK_GCC_ARG(-fprofile-arcs,                     COVERAGE_CFLAGS="$COVERAGE_CFLAGS -fprofile-arcs")
      PHP_CHECK_GCC_ARG(-ftest-coverage,                    COVERAGE_CFLAGS="$COVERAGE_CFLAGS -ftest-coverage")
      EXTRA_LDFLAGS="$COVERAGE_CFLAGS"
  fi

  PHP_MONGODB_CFLAGS="$STD_CFLAGS $MAINTAINER_CFLAGS $COVERAGE_CFLAGS"

  PHP_MONGODB_SOURCES="\
    php_phongo.c \
    phongo_compat.c \
    src/bson.c \
    src/bson-encode.c \
    src/BSON/Binary.c \
    src/BSON/BinaryInterface.c \
    src/BSON/DBPointer.c \
    src/BSON/Decimal128.c \
    src/BSON/Decimal128Interface.c \
    src/BSON/Javascript.c \
    src/BSON/JavascriptInterface.c \
    src/BSON/MaxKey.c \
    src/BSON/MaxKeyInterface.c \
    src/BSON/MinKey.c \
    src/BSON/MinKeyInterface.c \
    src/BSON/ObjectId.c \
    src/BSON/ObjectIdInterface.c \
    src/BSON/Persistable.c \
    src/BSON/Regex.c \
    src/BSON/RegexInterface.c \
    src/BSON/Serializable.c \
    src/BSON/Symbol.c \
    src/BSON/Timestamp.c \
    src/BSON/TimestampInterface.c \
    src/BSON/Type.c \
    src/BSON/Undefined.c \
    src/BSON/Unserializable.c \
    src/BSON/UTCDateTime.c \
    src/BSON/UTCDateTimeInterface.c \
    src/BSON/functions.c \
    src/MongoDB/BulkWrite.c \
    src/MongoDB/Command.c \
    src/MongoDB/Cursor.c \
    src/MongoDB/CursorId.c \
    src/MongoDB/Manager.c \
    src/MongoDB/Query.c \
    src/MongoDB/ReadConcern.c \
    src/MongoDB/ReadPreference.c \
    src/MongoDB/Server.c \
    src/MongoDB/Session.c \
    src/MongoDB/WriteConcern.c \
    src/MongoDB/WriteConcernError.c \
    src/MongoDB/WriteError.c \
    src/MongoDB/WriteResult.c \
    src/MongoDB/Exception/AuthenticationException.c \
    src/MongoDB/Exception/BulkWriteException.c \
    src/MongoDB/Exception/CommandException.c \
    src/MongoDB/Exception/ConnectionException.c \
    src/MongoDB/Exception/ConnectionTimeoutException.c \
    src/MongoDB/Exception/Exception.c \
    src/MongoDB/Exception/ExecutionTimeoutException.c \
    src/MongoDB/Exception/InvalidArgumentException.c \
    src/MongoDB/Exception/LogicException.c \
    src/MongoDB/Exception/RuntimeException.c \
    src/MongoDB/Exception/ServerException.c \
    src/MongoDB/Exception/SSLConnectionException.c \
    src/MongoDB/Exception/UnexpectedValueException.c \
    src/MongoDB/Exception/WriteException.c \
    src/MongoDB/Monitoring/CommandFailedEvent.c \
    src/MongoDB/Monitoring/CommandStartedEvent.c \
    src/MongoDB/Monitoring/CommandSubscriber.c \
    src/MongoDB/Monitoring/CommandSucceededEvent.c \
    src/MongoDB/Monitoring/Subscriber.c \
    src/MongoDB/Monitoring/functions.c \
  "

  PHP_ARG_WITH([libbson],
               [whether to use system libbson],
               [AS_HELP_STRING([--with-libbson=@<:@yes/no@:>@],
                               [MongoDB: Use system libbson [default=no]])],
               [no],
               [no])
  PHP_ARG_WITH([libmongoc],
               [whether to use system libmongoc],
               [AS_HELP_STRING([--with-libmongoc=@<:@yes/no@:>@],
                               [MongoDB: Use system libmongoc [default=no]])],
               [no],
               [no])

  if test "$PHP_LIBBSON" != "no"; then
    if test "$PHP_LIBMONGOC" = "no"; then
      AC_MSG_ERROR(Cannot use system libbson and bundled libmongoc)
    fi

    AC_PATH_PROG(PKG_CONFIG, pkg-config, no)
    AC_MSG_CHECKING(for libbson)
    if test -x "$PKG_CONFIG" && $PKG_CONFIG --exists libbson-1.0; then
      if $PKG_CONFIG libbson-1.0 --atleast-version 1.9.0; then
        LIBBSON_INC=`$PKG_CONFIG libbson-1.0 --cflags`
        LIBBSON_LIB=`$PKG_CONFIG libbson-1.0 --libs`
        LIBBSON_VER=`$PKG_CONFIG libbson-1.0 --modversion`
        AC_MSG_RESULT(version $LIBBSON_VER found)
      else
        AC_MSG_ERROR(system libbson must be upgraded to version >= 1.9.0)
      fi
    else
      AC_MSG_ERROR(pkgconfig and libbson must be installed)
    fi
    PHP_EVAL_INCLINE($LIBBSON_INC)
    PHP_EVAL_LIBLINE($LIBBSON_LIB, MONGODB_SHARED_LIBADD)
    AC_DEFINE(HAVE_SYSTEM_LIBBSON, 1, [Use system libbson])
  fi

  if test "$PHP_LIBMONGOC" != "no"; then
    if test "$PHP_LIBBSON" = "no"; then
      AC_MSG_ERROR(Cannot use system libmongoc and bundled libbson)
    fi

    AC_PATH_PROG(PKG_CONFIG, pkg-config, no)
    AC_MSG_CHECKING(for libmongoc)
    if test -x "$PKG_CONFIG" && $PKG_CONFIG --exists libmongoc-1.0; then
      if $PKG_CONFIG libmongoc-1.0 --atleast-version 1.9.0; then
        LIBMONGOC_INC=`$PKG_CONFIG libmongoc-1.0 --cflags`
        LIBMONGOC_LIB=`$PKG_CONFIG libmongoc-1.0 --libs`
        LIBMONGOC_VER=`$PKG_CONFIG libmongoc-1.0 --modversion`
        AC_MSG_RESULT(version $LIBMONGOC_VER found)

      else
        AC_MSG_ERROR(system libmongoc must be upgraded to version >= 1.9.0)
      fi
    else
      AC_MSG_ERROR(pkgconfig and libmongoc must be installed)
    fi
    PHP_EVAL_INCLINE($LIBMONGOC_INC)
    PHP_EVAL_LIBLINE($LIBMONGOC_LIB, MONGODB_SHARED_LIBADD)
    AC_DEFINE(HAVE_SYSTEM_LIBMONGOC, 1, [Use system libmongoc])
  fi

  if test "$PHP_LIBBSON" = "no" -a "$PHP_LIBMONGOC" = "no"; then
    PHP_MONGODB_BSON_CFLAGS="$STD_CFLAGS -DBSON_COMPILATION"
    PHP_MONGODB_MONGOC_CFLAGS="$STD_CFLAGS -DMONGOC_COMPILATION -DMONGOC_TRACE"

    dnl M4 doesn't know if we're building statically or as a shared module, so
    dnl attempt to include both paths while ignoring errors. If neither path
    dnl exists, report an error during configure (this is later than M4 parsing
    dnl during phpize but better than nothing).
    m4_pushdef([_include],[
      if test ! \( -f "$1" -o -f "ext/mongodb/$1" \); then
        AC_MSG_ERROR([m4 could not include $1: No such file or directory])
      fi
      m4_builtin([sinclude],[$1])
      m4_builtin([sinclude],[ext/mongodb/][$1])
    ])

    dnl Avoid using AC_CONFIG_MACRO_DIR, which might conflict with PHP
    _include([scripts/build/autotools/m4/ac_compile_check_sizeof.m4])
    _include([scripts/build/autotools/m4/ac_create_stdint_h.m4])
    _include([scripts/build/autotools/m4/as_var_copy.m4])
    _include([scripts/build/autotools/m4/ax_check_compile_flag.m4])
    _include([scripts/build/autotools/m4/ax_prototype.m4])
    _include([scripts/build/autotools/m4/ax_pthread.m4])
    _include([scripts/build/autotools/m4/pkg.m4])

    _include([scripts/build/autotools/CheckCompiler.m4])
    _include([scripts/build/autotools/CheckHost.m4])

    _include([scripts/build/autotools/libbson/CheckAtomics.m4])
    _include([scripts/build/autotools/libbson/CheckHeaders.m4])
    _include([scripts/build/autotools/libbson/Endian.m4])
    _include([scripts/build/autotools/libbson/FindDependencies.m4])
    _include([scripts/build/autotools/libbson/Versions.m4])

    _include([scripts/build/autotools/libmongoc/CheckCompression.m4])
    _include([scripts/build/autotools/libmongoc/CheckResolv.m4])
    _include([scripts/build/autotools/libmongoc/CheckSasl.m4])
    _include([scripts/build/autotools/libmongoc/CheckSSL.m4])
    _include([scripts/build/autotools/libmongoc/FindDependencies.m4])
    _include([scripts/build/autotools/libmongoc/PlatformFlags.m4])
    _include([scripts/build/autotools/libmongoc/Versions.m4])
    _include([scripts/build/autotools/libmongoc/WeakSymbols.m4])

    m4_popdef([_include])

    AC_SUBST(BSON_EXTRA_ALIGN, 0)
    AC_SUBST(BSON_OS, 1)

    AC_SUBST(MONGOC_NO_AUTOMATIC_GLOBALS, 1)

    dnl Capture user-set environment variables for metadata handshake
    dnl We can do this after the above scripts as they only modify STD_CFLAGS
    AS_VAR_COPY(MONGOC_USER_SET_CFLAGS, [CFLAGS])
    AS_VAR_COPY(MONGOC_USER_SET_LDFLAGS, [LDFLAGS])
    AS_VAR_COPY(MONGOC_CC, [CC])

    AC_SUBST(MONGOC_USER_SET_CFLAGS)
    AC_SUBST(MONGOC_USER_SET_LDFLAGS)
    AC_SUBST(MONGOC_CC)

    dnl Generated with: find src/libbson/src/bson -name '*.c' -print0 | cut -sz -d / -f 5- | sort -z | tr '\000' ' '
    PHP_MONGODB_BSON_SOURCES="bcon.c bson-atomic.c bson.c bson-clock.c bson-context.c bson-decimal128.c bson-error.c bson-iso8601.c bson-iter.c bson-json.c bson-keys.c bson-md5.c bson-memory.c bson-oid.c bson-reader.c bson-string.c bson-timegm.c bson-utf8.c bson-value.c bson-version-functions.c bson-writer.c"

    dnl Generated with: find src/libbson/src/jsonsl -name '*.c' -print0 | cut -sz -d / -f 5- | sort -z | tr '\000' ' '
    PHP_MONGODB_JSONSL_SOURCES="jsonsl.c"

    dnl Generated with: find src/libmongoc/src/mongoc -name '*.c' -print0 | cut -sz -d / -f 5- | sort -z | tr '\000' ' '
    PHP_MONGODB_MONGOC_SOURCES="mongoc-apm.c mongoc-array.c mongoc-async.c mongoc-async-cmd.c mongoc-b64.c mongoc-buffer.c mongoc-bulk-operation.c mongoc-change-stream.c mongoc-client.c mongoc-client-pool.c mongoc-client-session.c mongoc-cluster.c mongoc-cluster-cyrus.c mongoc-cluster-gssapi.c mongoc-cluster-sasl.c mongoc-cluster-sspi.c mongoc-cmd.c mongoc-collection.c mongoc-compression.c mongoc-counters.c mongoc-crypto.c mongoc-crypto-cng.c mongoc-crypto-common-crypto.c mongoc-crypto-openssl.c mongoc-cursor-array.c mongoc-cursor.c mongoc-cursor-cursorid.c mongoc-cursor-transform.c mongoc-cyrus.c mongoc-database.c mongoc-find-and-modify.c mongoc-gridfs.c mongoc-gridfs-file.c mongoc-gridfs-file-list.c mongoc-gridfs-file-page.c mongoc-gssapi.c mongoc-handshake.c mongoc-host-list.c mongoc-index.c mongoc-init.c mongoc-libressl.c mongoc-linux-distro-scanner.c mongoc-list.c mongoc-log.c mongoc-matcher.c mongoc-matcher-op.c mongoc-memcmp.c mongoc-openssl.c mongoc-queue.c mongoc-rand-cng.c mongoc-rand-common-crypto.c mongoc-rand-openssl.c mongoc-read-concern.c mongoc-read-prefs.c mongoc-rpc.c mongoc-sasl.c mongoc-scram.c mongoc-secure-channel.c mongoc-secure-transport.c mongoc-server-description.c mongoc-server-stream.c mongoc-set.c mongoc-socket.c mongoc-ssl.c mongoc-sspi.c mongoc-stream-buffered.c mongoc-stream.c mongoc-stream-file.c mongoc-stream-gridfs.c mongoc-stream-socket.c mongoc-stream-tls.c mongoc-stream-tls-libressl.c mongoc-stream-tls-openssl-bio.c mongoc-stream-tls-openssl.c mongoc-stream-tls-secure-channel.c mongoc-stream-tls-secure-transport.c mongoc-topology.c mongoc-topology-description-apm.c mongoc-topology-description.c mongoc-topology-scanner.c mongoc-uri.c mongoc-util.c mongoc-version-functions.c mongoc-write-command.c mongoc-write-command-legacy.c mongoc-write-concern.c"

    dnl Generated with: find src/libmongoc/src/zlib-1.2.11 -maxdepth 1 -name '*.c' -print0 | cut -sz -d / -f 5- | sort -z | tr '\000' ' '
    PHP_MONGODB_ZLIB_SOURCES="adler32.c compress.c crc32.c deflate.c gzclose.c gzlib.c gzread.c gzwrite.c infback.c inffast.c inflate.c inftrees.c trees.c uncompr.c zutil.c"

    PHP_ADD_SOURCES_X(PHP_EXT_DIR(mongodb)[src/libbson/src/bson], $PHP_MONGODB_BSON_SOURCES, $PHP_MONGODB_BSON_CFLAGS, shared_objects_mongodb, yes)
    PHP_ADD_SOURCES_X(PHP_EXT_DIR(mongodb)[src/libbson/src/jsonsl], $PHP_MONGODB_JSONSL_SOURCES, $PHP_MONGODB_BSON_CFLAGS, shared_objects_mongodb, yes)
    PHP_ADD_SOURCES_X(PHP_EXT_DIR(mongodb)[src/libmongoc/src/mongoc], $PHP_MONGODB_MONGOC_SOURCES, $PHP_MONGODB_MONGOC_CFLAGS, shared_objects_mongodb, yes)

    PHP_ADD_INCLUDE(PHP_EXT_SRCDIR(mongodb)[/src/libbson/src/])
    PHP_ADD_INCLUDE(PHP_EXT_SRCDIR(mongodb)[/src/libbson/src/bson/])
    PHP_ADD_INCLUDE(PHP_EXT_SRCDIR(mongodb)[/src/libbson/src/jsonsl/])
    PHP_ADD_INCLUDE(PHP_EXT_SRCDIR(mongodb)[/src/libmongoc/src/mongoc/])

    PHP_ADD_BUILD_DIR(PHP_EXT_BUILDDIR(mongodb)[/src/libbson/src/jsonsl/])
    PHP_ADD_BUILD_DIR(PHP_EXT_BUILDDIR(mongodb)[/src/libbson/src/bson/])
    PHP_ADD_BUILD_DIR(PHP_EXT_BUILDDIR(mongodb)[/src/libmongoc/src/mongoc/])

    dnl TODO: Use $ext_srcdir if we can move this after PHP_NEW_EXTENSION
    ac_config_dir=PHP_EXT_SRCDIR(mongodb)

    AC_CONFIG_FILES([
      ${ac_config_dir}/src/libbson/src/bson/bson-config.h
      ${ac_config_dir}/src/libbson/src/bson/bson-version.h
      ${ac_config_dir}/src/libmongoc/src/mongoc/mongoc-config.h
      ${ac_config_dir}/src/libmongoc/src/mongoc/mongoc-version.h
    ])

    if test "x$bundled_zlib" = "xyes"; then
      PHP_ADD_SOURCES_X(PHP_EXT_DIR(mongodb)[src/libmongoc/src/zlib-1.2.11], $PHP_MONGODB_ZLIB_SOURCES, $PHP_MONGODB_MONGOC_CFLAGS, shared_objects_mongodb, yes)
      PHP_ADD_INCLUDE(PHP_EXT_SRCDIR(mongodb)[/src/libmongoc/src/zlib-1.2.11/])
      PHP_ADD_BUILD_DIR(PHP_EXT_BUILDDIR(mongodb)[/src/libmongoc/src/zlib-1.2.11/])
      AC_CONFIG_FILES([${ac_config_dir}/src/libmongoc/src/zlib-1.2.11/zconf.h])
    fi
  fi

  PHP_NEW_EXTENSION(mongodb, $PHP_MONGODB_SOURCES, $ext_shared,, $PHP_MONGODB_CFLAGS)

  PHP_SUBST(MONGODB_SHARED_LIBADD)
  PHP_SUBST(EXTRA_LDFLAGS)

  PHP_ADD_EXTENSION_DEP(mongodb, date)
  PHP_ADD_EXTENSION_DEP(mongodb, json)
  PHP_ADD_EXTENSION_DEP(mongodb, spl)
  PHP_ADD_EXTENSION_DEP(mongodb, standard)

  PHP_ADD_INCLUDE(PHP_EXT_SRCDIR(mongodb)[/src/BSON/])
  PHP_ADD_INCLUDE(PHP_EXT_SRCDIR(mongodb)[/src/MongoDB/])
  PHP_ADD_INCLUDE(PHP_EXT_SRCDIR(mongodb)[/src/MongoDB/Exception/])
  PHP_ADD_INCLUDE(PHP_EXT_SRCDIR(mongodb)[/src/MongoDB/Monitoring/])
  PHP_ADD_INCLUDE(PHP_EXT_SRCDIR(mongodb)[/src/contrib/])

  PHP_ADD_BUILD_DIR(PHP_EXT_BUILDDIR(mongodb)[/src/BSON/])
  PHP_ADD_BUILD_DIR(PHP_EXT_BUILDDIR(mongodb)[/src/MongoDB/])
  PHP_ADD_BUILD_DIR(PHP_EXT_BUILDDIR(mongodb)[/src/MongoDB/Exception/])
  PHP_ADD_BUILD_DIR(PHP_EXT_BUILDDIR(mongodb)[/src/MongoDB/Monitoring/])
  PHP_ADD_BUILD_DIR(PHP_EXT_BUILDDIR(mongodb)[/src/contrib/])

  dnl This must come after PHP_NEW_EXTENSION, otherwise the srcdir won't be set
  PHP_ADD_MAKEFILE_FRAGMENT

AC_CONFIG_COMMANDS_POST([echo "
mongodb was configured with the following options:

Build configuration:
  CFLAGS                                           : $CFLAGS
  Extra CFLAGS                                     : $STD_CFLAGS $EXTRA_CFLAGS
  Developers flags (slow)                          : $MAINTAINER_CFLAGS
  Code Coverage flags (extra slow)                 : $COVERAGE_CFLAGS
  System mongoc                                    : $PHP_LIBMONGOC
  System libbson                                   : $PHP_LIBBSON
  LDFLAGS                                          : $LDFLAGS
  EXTRA_LDFLAGS                                    : $EXTRA_LDFLAGS
  MONGODB_SHARED_LIBADD                            : $MONGODB_SHARED_LIBADD

Please submit bugreports at:
  https://jira.mongodb.org/browse/PHPC

"])
fi

dnl: vim: et sw=2
