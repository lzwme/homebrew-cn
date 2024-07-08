class MysqlAT80 < Formula
  desc "Open source relational database management system"
  homepage "https:dev.mysql.comdocrefman8.0en"
  # TODO: Check if we can use unversioned `protobuf` at version bump
  # https:bugs.mysql.combug.php?id=111469
  # https:bugs.mysql.combug.php?id=113045
  url "https:cdn.mysql.comDownloadsMySQL-8.0mysql-boost-8.0.38.tar.gz"
  sha256 "2b8d1620d96e8adda715bf6b060c324223d9e80db487a04cbaa2be8ec5fed718"
  license "GPL-2.0-only" => { with: "Universal-FOSS-exception-1.0" }

  livecheck do
    url "https:dev.mysql.comdownloadsmysql8.0.html?tpl=files&os=src&version=8.0"
    regex(href=.*?mysql[._-](?:boost[._-])?v?(8\.0(?:\.\d+)*)\.ti)
  end

  bottle do
    sha256 arm64_sonoma:   "f6c54ec6b012c959c8f9974d4970fdce9d15ca6eea660626610bb2e4c86d1770"
    sha256 arm64_ventura:  "61c52c7943b790fdeee80d680311bf72707bb9befc6fef34550fed7468541b21"
    sha256 arm64_monterey: "723b89c1c8922f14bbfab33ae597fd6ec9931e5b37eeecd767643c3e921a2c14"
    sha256 sonoma:         "3a7d454d3ddecb4f91f8c286636b820522d5666c751be4fe6268f3ead6425359"
    sha256 ventura:        "7040b91fbd0d4c630c12fee605b76c277aecf9d5face7663c09c0b4da6f60fee"
    sha256 monterey:       "a85a095f6d98d340227d789d4d27585de7f0c0bae59b8cd1641b38aa392c3da2"
    sha256 x86_64_linux:   "24a8b5440d5fd8522ca1a03109565f780291550bbbaa92c36c1ebb40f2469c5e"
  end

  keg_only :versioned_formula

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "icu4c"
  depends_on "libevent"
  depends_on "libfido2"
  depends_on "lz4"
  depends_on "openssl@3"
  depends_on "protobuf@21" # https:bugs.mysql.combug.php?id=113045
  depends_on "zlib" # Zlib 1.2.12+
  depends_on "zstd"

  uses_from_macos "curl"
  uses_from_macos "cyrus-sasl"
  uses_from_macos "libedit"

  on_linux do
    depends_on "patchelf" => :build
    depends_on "libtirpc"
  end

  fails_with gcc: "5" # for C++17

  # Patch out check for Homebrew `boost`.
  # This should not be necessary when building inside `brew`.
  # https:github.comHomebrewhomebrew-test-botpull820
  patch :DATA

  def datadir
    var"mysql"
  end

  def install
    if OS.linux?
      # Fix libmysqlgcs.a(gcs_logging.cc.o): relocation R_X86_64_32
      # against `_ZN17Gcs_debug_options12m_debug_noneB5cxx11E' can not be used when making
      # a shared object; recompile with -fPIC
      ENV.append_to_cflags "-fPIC"

      # Disable ABI checking
      inreplace "cmakeabi_check.cmake", "RUN_ABI_CHECK 1", "RUN_ABI_CHECK 0"
    end

    # -DINSTALL_* are relative to `CMAKE_INSTALL_PREFIX` (`prefix`)
    args = %W[
      -DCOMPILATION_COMMENT=Homebrew
      -DINSTALL_DOCDIR=sharedoc#{name}
      -DINSTALL_INCLUDEDIR=includemysql
      -DINSTALL_INFODIR=shareinfo
      -DINSTALL_MANDIR=shareman
      -DINSTALL_MYSQLSHAREDIR=sharemysql
      -DINSTALL_PLUGINDIR=libplugin
      -DMYSQL_DATADIR=#{datadir}
      -DSYSCONFDIR=#{etc}
      -DWITH_SYSTEM_LIBS=ON
      -DWITH_BOOST=boost
      -DWITH_EDITLINE=system
      -DWITH_FIDO=system
      -DWITH_ICU=system
      -DWITH_LIBEVENT=system
      -DWITH_LZ4=system
      -DWITH_PROTOBUF=system
      -DWITH_SSL=system
      -DWITH_ZLIB=system
      -DWITH_ZSTD=system
      -DWITH_UNIT_TESTS=OFF
      -DWITH_INNODB_MEMCACHED=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    (prefix"mysql-test").cd do
      system ".mysql-test-run.pl", "status", "--vardir=#{Dir.mktmpdir}"
    end

    # Remove the tests directory
    rm_rf prefix"mysql-test"

    # Don't create databases inside of the prefix!
    # See: https:github.comHomebrewhomebrewissues4975
    rm_rf prefix"data"

    # Fix up the control script and link into bin.
    inreplace "#{prefix}support-filesmysql.server",
              ^(PATH=".*)("),
              "\\1:#{HOMEBREW_PREFIX}bin\\2"
    bin.install_symlink prefix"support-filesmysql.server"

    # Install my.cnf that binds to 127.0.0.1 by default
    (buildpath"my.cnf").write <<~EOS
      # Default Homebrew MySQL server config
      [mysqld]
      # Only allow connections from localhost
      bind-address = 127.0.0.1
      mysqlx-bind-address = 127.0.0.1
    EOS
    etc.install "my.cnf"
  end

  def post_install
    # Make sure the varmysql directory exists
    (var"mysql").mkpath

    # Don't initialize database, it clashes when testing other MySQL-like implementations.
    return if ENV["HOMEBREW_GITHUB_ACTIONS"]

    unless (datadir"mysqlgeneral_log.CSM").exist?
      ENV["TMPDIR"] = nil
      system bin"mysqld", "--initialize-insecure", "--user=#{ENV["USER"]}",
        "--basedir=#{prefix}", "--datadir=#{datadir}", "--tmpdir=tmp"
    end
  end

  def caveats
    s = <<~EOS
      We've installed your MySQL database without a root password. To secure it run:
          mysql_secure_installation

      MySQL is configured to only allow connections from localhost by default

      To connect run:
          mysql -u root
    EOS
    if (my_cnf = ["etcmy.cnf", "etcmysqlmy.cnf"].find { |x| File.exist? x })
      s += <<~EOS

        A "#{my_cnf}" from another install may interfere with a Homebrew-built
        server starting up correctly.
      EOS
    end
    s
  end

  service do
    run [opt_bin"mysqld_safe", "--datadir=#{var}mysql"]
    keep_alive true
    working_dir var"mysql"
  end

  test do
    (testpath"mysql").mkpath
    (testpath"tmp").mkpath
    system bin"mysqld", "--no-defaults", "--initialize-insecure", "--user=#{ENV["USER"]}",
      "--basedir=#{prefix}", "--datadir=#{testpath}mysql", "--tmpdir=#{testpath}tmp"
    port = free_port
    fork do
      system "#{bin}mysqld", "--no-defaults", "--user=#{ENV["USER"]}",
        "--datadir=#{testpath}mysql", "--port=#{port}", "--tmpdir=#{testpath}tmp"
    end
    sleep 5
    assert_match "information_schema",
      shell_output("#{bin}mysql --port=#{port} --user=root --password= --execute='show databases;'")
    system "#{bin}mysqladmin", "--port=#{port}", "--user=root", "--password=", "shutdown"
  end
end

__END__
diff --git aCMakeLists.txt bCMakeLists.txt
index 42e63d0..5d21cc3 100644
--- aCMakeLists.txt
+++ bCMakeLists.txt
@@ -1942,31 +1942,6 @@ MYSQL_CHECK_RAPIDJSON()
 MYSQL_CHECK_FIDO()
 MYSQL_CHECK_FIDO_DLLS()

-IF(APPLE)
-  GET_FILENAME_COMPONENT(HOMEBREW_BASE ${HOMEBREW_HOME} DIRECTORY)
-  IF(EXISTS ${HOMEBREW_BASE}includeboost)
-    FOREACH(SYSTEM_LIB ICU LIBEVENT LZ4 PROTOBUF ZSTD FIDO)
-      IF(WITH_${SYSTEM_LIB} STREQUAL "system")
-        MESSAGE(FATAL_ERROR
-          "WITH_${SYSTEM_LIB}=system is not compatible with Homebrew boost\n"
-          "MySQL depends on ${BOOST_PACKAGE_NAME} with a set of patches.\n"
-          "Including headers from ${HOMEBREW_BASE}include "
-          "will break the build.\n"
-          "Please use WITH_${SYSTEM_LIB}=bundled\n"
-          "or do 'brew uninstall boost' or 'brew unlink boost'"
-          )
-      ENDIF()
-    ENDFOREACH()
-  ENDIF()
-  # Ensure that we look in usrlocalinclude or opthomebrewinclude
-  FOREACH(SYSTEM_LIB ICU LIBEVENT LZ4 PROTOBUF ZSTD FIDO)
-    IF(WITH_${SYSTEM_LIB} STREQUAL "system")
-      INCLUDE_DIRECTORIES(SYSTEM ${HOMEBREW_BASE}include)
-      BREAK()
-    ENDIF()
-  ENDFOREACH()
-ENDIF()
-
 IF(WITH_AUTHENTICATION_FIDO OR WITH_AUTHENTICATION_CLIENT_PLUGINS)
   IF(WITH_FIDO STREQUAL "system" AND
     NOT WITH_SSL STREQUAL "system")