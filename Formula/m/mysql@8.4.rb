class MysqlAT84 < Formula
  desc "Open source relational database management system"
  homepage "https:dev.mysql.comdocrefman8.4en"
  url "https:cdn.mysql.comDownloadsMySQL-8.4mysql-8.4.3.tar.gz"
  sha256 "7ac9564c478022f73005ff89bbb40f67b381fc06d5518416bdffec75e625b818"
  license "GPL-2.0-only" => { with: "Universal-FOSS-exception-1.0" }

  livecheck do
    url "https:dev.mysql.comdownloadsmysql8.4.html?tpl=files&os=src&version=8.4"
    regex(href=.*?mysql[._-](?:boost[._-])?v?(8\.4(?:\.\d+)*)\.ti)
  end

  bottle do
    sha256 arm64_sequoia: "c4d00155705c15c009080d11a8e2003e9269fcd6e2a7cb70c3008bd0483c3c0e"
    sha256 arm64_sonoma:  "8663cc65f5d369b2bf34a064b897a1d9f736c1c5e6d9cfa11419be49dc2e98b2"
    sha256 arm64_ventura: "dbc3be2ee5f0cde0ed46fbdb3e0334101d3e5ea90a8667181cc85dcebe5a301a"
    sha256 sonoma:        "2dcf0aec267d91dc12cef42540a38c252c8ba8ec719ad14eb7e04548df3b2747"
    sha256 ventura:       "d16bb597d1c41ffe1ca0fd43cddebb747e0492c72069fbffaa7134e2b0fc1092"
    sha256 x86_64_linux:  "a02c667c6e265d2f90f949eefbe47c1ed51f17cf9a246c8fb20158fa12d8e021"
  end

  keg_only :versioned_formula

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "abseil"
  depends_on "icu4c@75"
  depends_on "lz4"
  depends_on "openssl@3"
  depends_on "protobuf"
  depends_on "zlib" # Zlib 1.2.13+
  depends_on "zstd"

  uses_from_macos "curl"
  uses_from_macos "cyrus-sasl"
  uses_from_macos "libedit"

  on_macos do
    depends_on "llvm" if DevelopmentTools.clang_build_version <= 1400
  end

  on_linux do
    depends_on "patchelf" => :build
    depends_on "libtirpc"
  end

  fails_with :clang do
    build 1400
    cause "Requires C++20"
  end

  fails_with :gcc do
    version "9"
    cause "Requires C++20"
  end

  # Patch out check for Homebrew `boost`.
  # This should not be necessary when building inside `brew`.
  # https:github.comHomebrewhomebrew-test-botpull820
  patch :DATA

  def datadir
    var"mysql"
  end

  def install
    # Remove bundled libraries other than explicitly allowed below.
    # `boost` and `rapidjson` must use bundled copy due to patches.
    # `lz4` is still needed due to xxhash.c used by mysqlgcs
    keep = %w[boost duktape libbacktrace libcno lz4 rapidjson unordered_dense]
    (buildpath"extra").each_child { |dir| rm_r(dir) unless keep.include?(dir.basename.to_s) }

    if OS.linux?
      # Disable ABI checking
      inreplace "cmakeabi_check.cmake", "RUN_ABI_CHECK 1", "RUN_ABI_CHECK 0"

      # Work around build issue with Protobuf 22+ on Linux
      # Ref: https:bugs.mysql.combug.php?id=113045
      # Ref: https:bugs.mysql.combug.php?id=115163
      inreplace "cmakeprotobuf.cmake" do |s|
        s.gsub! 'IF(APPLE AND WITH_PROTOBUF STREQUAL "system"', 'IF(WITH_PROTOBUF STREQUAL "system"'
        s.gsub! ' INCLUDE REGEX "${HOMEBREW_HOME}.*")', ' INCLUDE REGEX "libabsl.*")'
      end
    elsif DevelopmentTools.clang_build_version <= 1400
      ENV.llvm_clang
      # Work around failure mixing newer `llvm` headers with older Xcode's libc++:
      # Undefined symbols for architecture arm64:
      #   "std::exception_ptr::__from_native_exception_pointer(void*)", referenced from:
      #       std::exception_ptr std::make_exception_ptr[abi:ne180100]<std::runtime_error>(std::runtime_error) ...
      ENV.prepend_path "HOMEBREW_LIBRARY_PATHS", Formula["llvm"].opt_lib"c++"
    end

    icu4c = deps.map(&:to_formula).find { |f| f.name.match?(^icu4c@\d+$) }
    # -DINSTALL_* are relative to `CMAKE_INSTALL_PREFIX` (`prefix`)
    # -DWITH_FIDO=system isn't set as feature isn't enabled and bundled copy was removed.
    # Formula paths are set to avoid HOMEBREW_HOME logic in CMake scripts
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
      -DBISON_EXECUTABLE=#{Formula["bison"].opt_bin}bison
      -DOPENSSL_ROOT_DIR=#{Formula["openssl@3"].opt_prefix}
      -DWITH_ICU=#{icu4c.opt_prefix}
      -DWITH_SYSTEM_LIBS=ON
      -DWITH_BOOST=boost
      -DWITH_EDITLINE=system
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
      system ".mysql-test-run.pl", "status", "--vardir=#{buildpath}mysql-test-vardir"
    end

    # Remove the tests directory
    rm_r(prefix"mysql-test")

    # Fix up the control script and link into bin.
    inreplace prefix"support-filesmysql.server",
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

    args = %W[--no-defaults --user=#{ENV["USER"]} --datadir=#{testpath}mysql --tmpdir=#{testpath}tmp]
    system bin"mysqld", *args, "--initialize-insecure", "--basedir=#{prefix}"
    port = free_port
    pid = spawn(bin"mysqld", *args, "--port=#{port}")
    begin
      sleep 5

      output = shell_output("#{bin}mysql --port=#{port} --user=root --password= --execute='show databases;'")
      assert_match "information_schema", output
      system bin"mysqladmin", "--port=#{port}", "--user=root", "--password=", "shutdown"
    ensure
      Process.kill "TERM", pid
    end
  end
end

__END__
diff --git aCMakeLists.txt bCMakeLists.txt
index 438dff720c5..47863c17e23 100644
--- aCMakeLists.txt
+++ bCMakeLists.txt
@@ -1948,31 +1948,6 @@ MYSQL_CHECK_RAPIDJSON()
 MYSQL_CHECK_FIDO()
 MYSQL_CHECK_FIDO_DLLS()

-IF(APPLE)
-  GET_FILENAME_COMPONENT(HOMEBREW_BASE ${HOMEBREW_HOME} DIRECTORY)
-  IF(EXISTS ${HOMEBREW_BASE}includeboost)
-    FOREACH(SYSTEM_LIB ICU LZ4 PROTOBUF ZSTD FIDO)
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
-  FOREACH(SYSTEM_LIB ICU LZ4 PROTOBUF ZSTD FIDO)
-    IF(WITH_${SYSTEM_LIB} STREQUAL "system")
-      INCLUDE_DIRECTORIES(SYSTEM ${HOMEBREW_BASE}include)
-      BREAK()
-    ENDIF()
-  ENDFOREACH()
-ENDIF()
-
 IF(WITH_AUTHENTICATION_WEBAUTHN OR
   WITH_AUTHENTICATION_CLIENT_PLUGINS)
   IF(WITH_FIDO STREQUAL "system" AND