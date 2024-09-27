class MysqlAT84 < Formula
  desc "Open source relational database management system"
  homepage "https://dev.mysql.com/doc/refman/8.4/en/"
  url "https://cdn.mysql.com/Downloads/MySQL-8.4/mysql-8.4.2.tar.gz"
  sha256 "5657a78dc86bf0bf2227e0b05f8de5a2c447a816a112ffa26fa70083bcbe9814"
  license "GPL-2.0-only" => { with: "Universal-FOSS-exception-1.0" }
  revision 3

  livecheck do
    url "https://dev.mysql.com/downloads/mysql/8.4.html?tpl=files&os=src&version=8.4"
    regex(/href=.*?mysql[._-](?:boost[._-])?v?(8\.4(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "153d542acfc60c0251db0eafee58110068e81545db10e43d8d9f32ba376273a1"
    sha256 arm64_sonoma:  "e6c9cffe252decf8d8d12adb3f53ab946a8d44f06e5d332fd43063a3bfb108ef"
    sha256 arm64_ventura: "49f6fa28b4472a009d25c80c0858550895ab6eb034c5ca7872e41271e46f0e49"
    sha256 sonoma:        "31e9f393141afe7ccd941f0a303b883ce0d1affc1020874f0ca5a5b8515d1f80"
    sha256 ventura:       "aa57da8ebd466ee86d03829e9056cd90cd66a2652d54805da587cc3be5501030"
    sha256 x86_64_linux:  "db6af053c44d6b384a54ff1a2432ef3dc1e68daedbd6ef783af25484e340ce0d"
  end

  keg_only :versioned_formula

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "abseil"
  depends_on "icu4c"
  depends_on "libfido2"
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

  def datadir
    var/"mysql"
  end

  def install
    if OS.linux?
      # Fix libmysqlgcs.a(gcs_logging.cc.o): relocation R_X86_64_32
      # against `_ZN17Gcs_debug_options12m_debug_noneB5cxx11E' can not be used when making
      # a shared object; recompile with -fPIC
      ENV.append_to_cflags "-fPIC"

      # Disable ABI checking
      inreplace "cmake/abi_check.cmake", "RUN_ABI_CHECK 1", "RUN_ABI_CHECK 0"

      # Work around build issue with Protobuf 22+ on Linux
      # Ref: https://bugs.mysql.com/bug.php?id=113045
      # Ref: https://bugs.mysql.com/bug.php?id=115163
      inreplace "cmake/protobuf.cmake" do |s|
        s.gsub! 'IF(APPLE AND WITH_PROTOBUF STREQUAL "system"', 'IF(WITH_PROTOBUF STREQUAL "system"'
        s.gsub! ' INCLUDE REGEX "${HOMEBREW_HOME}.*")', ' INCLUDE REGEX "libabsl.*")'
      end
    elsif DevelopmentTools.clang_build_version <= 1400
      ENV.llvm_clang
      # Work around failure mixing newer `llvm` headers with older Xcode's libc++:
      # Undefined symbols for architecture arm64:
      #   "std::exception_ptr::__from_native_exception_pointer(void*)", referenced from:
      #       std::exception_ptr std::make_exception_ptr[abi:ne180100]<std::runtime_error>(std::runtime_error) ...
      ENV.prepend_path "HOMEBREW_LIBRARY_PATHS", Formula["llvm"].opt_lib/"c++"
    end

    # -DINSTALL_* are relative to `CMAKE_INSTALL_PREFIX` (`prefix`)
    args = %W[
      -DCOMPILATION_COMMENT=Homebrew
      -DINSTALL_DOCDIR=share/doc/#{name}
      -DINSTALL_INCLUDEDIR=include/mysql
      -DINSTALL_INFODIR=share/info
      -DINSTALL_MANDIR=share/man
      -DINSTALL_MYSQLSHAREDIR=share/mysql
      -DINSTALL_PLUGINDIR=lib/plugin
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

    (prefix/"mysql-test").cd do
      system "./mysql-test-run.pl", "status", "--vardir=#{buildpath}/mysql-test-vardir"
    end

    # Remove the tests directory
    rm_r(prefix/"mysql-test")

    # Fix up the control script and link into bin.
    inreplace prefix/"support-files/mysql.server",
              /^(PATH=".*)(")/,
              "\\1:#{HOMEBREW_PREFIX}/bin\\2"
    bin.install_symlink prefix/"support-files/mysql.server"

    # Install my.cnf that binds to 127.0.0.1 by default
    (buildpath/"my.cnf").write <<~EOS
      # Default Homebrew MySQL server config
      [mysqld]
      # Only allow connections from localhost
      bind-address = 127.0.0.1
      mysqlx-bind-address = 127.0.0.1
    EOS
    etc.install "my.cnf"
  end

  def post_install
    # Make sure the var/mysql directory exists
    (var/"mysql").mkpath

    # Don't initialize database, it clashes when testing other MySQL-like implementations.
    return if ENV["HOMEBREW_GITHUB_ACTIONS"]

    unless (datadir/"mysql/general_log.CSM").exist?
      ENV["TMPDIR"] = nil
      system bin/"mysqld", "--initialize-insecure", "--user=#{ENV["USER"]}",
                           "--basedir=#{prefix}", "--datadir=#{datadir}", "--tmpdir=/tmp"
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
    if (my_cnf = ["/etc/my.cnf", "/etc/mysql/my.cnf"].find { |x| File.exist? x })
      s += <<~EOS

        A "#{my_cnf}" from another install may interfere with a Homebrew-built
        server starting up correctly.
      EOS
    end
    s
  end

  service do
    run [opt_bin/"mysqld_safe", "--datadir=#{var}/mysql"]
    keep_alive true
    working_dir var/"mysql"
  end

  test do
    (testpath/"mysql").mkpath
    (testpath/"tmp").mkpath

    args = %W[--no-defaults --user=#{ENV["USER"]} --datadir=#{testpath}/mysql --tmpdir=#{testpath}/tmp]
    system bin/"mysqld", *args, "--initialize-insecure", "--basedir=#{prefix}"
    port = free_port
    fork { exec bin/"mysqld", *args, "--port=#{port}" }
    sleep 5

    output = shell_output("#{bin}/mysql --port=#{port} --user=root --password= --execute='show databases;'")
    assert_match "information_schema", output
    system bin/"mysqladmin", "--port=#{port}", "--user=root", "--password=", "shutdown"
  end
end