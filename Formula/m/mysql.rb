class Mysql < Formula
  desc "Open source relational database management system"
  homepage "https:dev.mysql.comdocrefman9.1en"
  url "https:cdn.mysql.comDownloadsMySQL-9.1mysql-9.1.0.tar.gz"
  sha256 "52c3675239bfd9d3c83224ff2002aa6e286fab97bf5b2b5ca1a85c9c347766fc"
  license "GPL-2.0-only" => { with: "Universal-FOSS-exception-1.0" }

  livecheck do
    url "https:dev.mysql.comdownloadsmysql?tpl=files&os=src"
    regex(href=.*?mysql[._-](?:boost[._-])?v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 arm64_sequoia: "ce5130d06a5cc67cc8765824b2326cbd31512a98e9e9a24d2731661c98f59108"
    sha256 arm64_sonoma:  "8237328ccc461ad8349b4053b4844ec2f642fb82acf1abd003cee114084795e4"
    sha256 arm64_ventura: "309c643f1fd3d69c0b4497640b3e2cee714181b84df1017b2fb67f270f81f356"
    sha256 sonoma:        "cfc7ac19401342fdf6c58278580023165589836e82bb2c1f7d6d96cd4c5a5c13"
    sha256 ventura:       "49fea7d8535c82b9490ba7119462699ac7bfb205c6656c62073ea5109497bc43"
    sha256 x86_64_linux:  "69c9e53513ab2cb01979bd3c956f10e9ce150f8850cc7ee3ff3c9b5afec8049b"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "abseil"
  depends_on "icu4c@76"
  depends_on "lz4"
  depends_on "openssl@3"
  depends_on "protobuf"
  depends_on "zlib" # Zlib 1.2.13+
  depends_on "zstd"

  uses_from_macos "curl"
  uses_from_macos "cyrus-sasl"
  uses_from_macos "libedit"

  # std::string_view is not fully compatible with the libc++ shipped
  # with ventura, so we need to use the LLVM libc++ instead.
  on_ventura :or_older do
    depends_on "llvm@18"
    fails_with :clang
  end

  on_linux do
    depends_on "patchelf" => :build
    depends_on "libtirpc"
  end

  conflicts_with "mariadb", "percona-server", because: "both install the same binaries"

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
    elsif MacOS.version <= :ventura
      ENV["CC"] = Formula["llvm@18"].opt_bin"clang"
      ENV["CXX"] = Formula["llvm@18"].opt_bin"clang++"

      # The dependencies need to be explicitly added to the environment
      deps.each do |dep|
        next if dep.build? || dep.test?

        ENV.append "CXXFLAGS", "-I#{dep.to_formula.opt_include}"
        ENV.append "LDFLAGS", "-L#{dep.to_formula.opt_lib}"
      end

      ENV.append "LDFLAGS", "-L#{Formula["llvm@18"].opt_lib}c++ -L#{Formula["llvm@18"].opt_lib} -lunwind"
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

    # Add the dependencies to the CMake args
    if OS.mac? && MacOS.version <=(:ventura)
      %W[
        -DABSL_INCLUDE_DIR=#{Formula["abseil"].opt_include}
        -DICU_ROOT=#{Formula["icu4c@76"].opt_prefix}
        -DLZ4_INCLUDE_DIR=#{Formula["lz4"].opt_include}
        -DOPENSSL_INCLUDE_DIR=#{Formula["openssl@3"].opt_include}
        -DPROTOBUF_INCLUDE_DIR=#{Formula["protobuf"].opt_include}
        -DZLIB_INCLUDE_DIR=#{Formula["zlib"].opt_include}
        -DZSTD_INCLUDE_DIR=#{Formula["zstd"].opt_include}
      ].each do |arg|
        args << arg
      end
    end

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
      Upgrading from MySQL <8.4 to MySQL >9.0 requires running MySQL 8.4 first:
       - brew services stop mysql
       - brew install mysql@8.4
       - brew services start mysql@8.4
       - brew services stop mysql@8.4
       - brew services start mysql

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