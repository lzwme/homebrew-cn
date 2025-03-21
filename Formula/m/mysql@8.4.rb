class MysqlAT84 < Formula
  desc "Open source relational database management system"
  homepage "https:dev.mysql.comdocrefman8.4en"
  url "https:cdn.mysql.comDownloadsMySQL-8.4mysql-8.4.4.tar.gz"
  sha256 "fb290ef748894434085249c31bca52ac71853124446ab218bb3bc502bf0082a5"
  license "GPL-2.0-only" => { with: "Universal-FOSS-exception-1.0" }
  revision 2

  livecheck do
    url "https:dev.mysql.comdownloadsmysql8.4.html?tpl=files&os=src&version=8.4"
    regex(href=.*?mysql[._-](?:boost[._-])?v?(8\.4(?:\.\d+)*)\.ti)
  end

  bottle do
    sha256 arm64_sequoia: "2b68b04e39b493bcc2ae9501d4ae84992d516b242cacf8dfa443e50accaaaa4f"
    sha256 arm64_sonoma:  "0f9da3c6e1b6b8b38eb2f434ccbb0733a5c33fde5573bdd808ae2f830d87eab0"
    sha256 arm64_ventura: "a904afe1967ac2b0704525448874bb68e9b056ff0e6bf2f73908f7fdcc1eba8e"
    sha256 sonoma:        "486ea3bbac3612ca8c8f7a65b971048e198ef0b1ff1afdd8ac4de7db2cdf609e"
    sha256 ventura:       "2c0d6f9020367d6f9d1d497b810cd9bf7376c8a727feddae6084c62e35be22e7"
    sha256 arm64_linux:   "4d3143a672f4e805dff250da614761182271b24385f644c458a103d6149531ec"
    sha256 x86_64_linux:  "6903b73fa0dea0f22334d8e5e2887ab790aafa079c054b91110865cc35ffda6a"
  end

  keg_only :versioned_formula

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "abseil"
  depends_on "icu4c@77"
  depends_on "lz4"
  depends_on "openssl@3"
  depends_on "protobuf@29"
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
    keep = %w[boost libbacktrace libcno lz4 rapidjson unordered_dense]
    (buildpath"extra").each_child { |dir| rm_r(dir) unless keep.include?(dir.basename.to_s) }

    if OS.linux?
      # Disable ABI checking
      inreplace "cmakeabi_check.cmake", "RUN_ABI_CHECK 1", "RUN_ABI_CHECK 0"
    elsif DevelopmentTools.clang_build_version <= 1400
      ENV.llvm_clang
      # Work around failure mixing newer `llvm` headers with older Xcode's libc++:
      # Undefined symbols for architecture arm64:
      #   "std::exception_ptr::__from_native_exception_pointer(void*)", referenced from:
      #       std::exception_ptr std::make_exception_ptr[abi:ne180100]<std::runtime_error>(std::runtime_error) ...
      ENV.prepend_path "HOMEBREW_LIBRARY_PATHS", Formula["llvm"].opt_lib"c++"
    end

    icu4c = deps.find { |dep| dep.name.match?(^icu4c(@\d+)?$) }
                .to_formula
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
      -DWITH_EDITLINE=system
      -DWITH_LZ4=system
      -DWITH_PROTOBUF=system
      -DWITH_SSL=system
      -DWITH_ZLIB=system
      -DWITH_ZSTD=system
      -DWITH_UNIT_TESTS=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    cd prefix"mysql-test" do
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
    (buildpath"my.cnf").write <<~INI
      # Default Homebrew MySQL server config
      [mysqld]
      # Only allow connections from localhost
      bind-address = 127.0.0.1
      mysqlx-bind-address = 127.0.0.1
    INI
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

    port = free_port
    socket = testpath"mysql.sock"
    mysqld_args = %W[
      --no-defaults
      --mysqlx=OFF
      --user=#{ENV["USER"]}
      --port=#{port}
      --socket=#{socket}
      --basedir=#{prefix}
      --datadir=#{testpath}mysql
      --tmpdir=#{testpath}tmp
    ]
    client_args = %W[
      --port=#{port}
      --socket=#{socket}
      --user=root
      --password=
    ]

    system bin"mysqld", *mysqld_args, "--initialize-insecure"
    pid = spawn(bin"mysqld", *mysqld_args)
    begin
      sleep 5
      output = shell_output("#{bin}mysql #{client_args.join(" ")} --execute='show databases;'")
      assert_match "information_schema", output
    ensure
      system bin"mysqladmin", *client_args, "shutdown"
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