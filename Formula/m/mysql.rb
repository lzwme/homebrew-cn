class Mysql < Formula
  desc "Open source relational database management system"
  homepage "https://dev.mysql.com/doc/refman/9.0/en/"
  url "https://cdn.mysql.com/Downloads/MySQL-9.0/mysql-9.0.1.tar.gz"
  sha256 "18fa65f1ea6aea71e418fe0548552d9a28de68e2b8bc3ba9536599eb459a6606"
  license "GPL-2.0-only" => { with: "Universal-FOSS-exception-1.0" }
  revision 2

  livecheck do
    url "https://dev.mysql.com/downloads/mysql/?tpl=files&os=src"
    regex(/href=.*?mysql[._-](?:boost[._-])?v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "b16a44a6df2d40ba18ba1e6432aa7cd2e44090321eb0cdd519ee4771ec271e7e"
    sha256 arm64_sonoma:  "198abc9dd970a6107fbc86befc9d794c9b361a6aa61e3c4c92426490f0a21f64"
    sha256 arm64_ventura: "4639cc2c8340e04567c24f211c8c82028f4420575c8062a0316d54e08a430a3e"
    sha256 sonoma:        "cc17a02f2b501fd0aa5bd36a86348163e5e5d120e9ca95ce8403fa34cce67e05"
    sha256 ventura:       "e364d1c409fd659ce9f22f6fe224585b7f0a5ba42e29b733fb0ebfc2f7eea1d6"
    sha256 x86_64_linux:  "660eb5a759e16993218ada0bdc4755ef94c6291e82785648f880a3c474d9601b"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "abseil"
  depends_on "icu4c"
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

  conflicts_with "mariadb", "percona-server", because: "both install the same binaries"

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
    # Remove bundled libraries other than explicitly allowed below.
    # `boost` and `rapidjson` must use bundled copy due to patches.
    # `lz4` is still needed due to xxhash.c used by mysqlgcs
    keep = %w[boost duktape libbacktrace libcno lz4 rapidjson unordered_dense]
    (buildpath/"extra").each_child { |dir| rm_r(dir) unless keep.include?(dir.basename.to_s) }

    if OS.linux?
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
    # -DWITH_FIDO=system isn't set as feature isn't enabled and bundled copy was removed.
    # Formula paths are set to avoid HOMEBREW_HOME logic in CMake scripts
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
      -DBISON_EXECUTABLE=#{Formula["bison"].opt_bin}/bison
      -DOPENSSL_ROOT_DIR=#{Formula["openssl@3"].opt_prefix}
      -DWITH_ICU=#{Formula["icu4c"].opt_prefix}
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
    pid = spawn(bin/"mysqld", *args, "--port=#{port}")
    begin
      sleep 5

      output = shell_output("#{bin}/mysql --port=#{port} --user=root --password= --execute='show databases;'")
      assert_match "information_schema", output
      system bin/"mysqladmin", "--port=#{port}", "--user=root", "--password=", "shutdown"
    ensure
      Process.kill "TERM", pid
    end
  end
end