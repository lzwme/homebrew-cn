class MariadbAT1011 < Formula
  desc "Drop-in replacement for MySQL"
  homepage "https:mariadb.org"
  url "https:archive.mariadb.orgmariadb-10.11.12sourcemariadb-10.11.12.tar.gz"
  sha256 "d61f23090cfc14f43e8a27c2d3ce7f80247e74481bb26a2d3a6308b8d194e167"
  license "GPL-2.0-only"

  livecheck do
    url "https:downloads.mariadb.orgrest-apimariadball-releases?olderReleases=false"
    strategy :json do |json|
      json["releases"]&.map do |release|
        next unless release["release_number"]&.start_with?(version.major_minor)
        next if release["status"] != "stable"

        release["release_number"]
      end
    end
  end

  bottle do
    sha256 arm64_sequoia: "cd0fbe5bf3e9035fb2e8799d0e91c897c47a31bc38401d31509b8d9411286d1a"
    sha256 arm64_sonoma:  "af1719894b04e042421e4317d6068263927814425836991d541333fb5ada39db"
    sha256 arm64_ventura: "f4f4a43875c097500c3da176586f19f532893e2cff43cab2cbfe91696e6e3aca"
    sha256 sonoma:        "0787ae74054567bc9fdf7d29f5ccbdbe6e51826bf9686dcb690360f116edbc72"
    sha256 ventura:       "d1eb3e6452d85a1b5b991be1133f149955bd0ee37bacd4c801842d9ad85a883b"
    sha256 arm64_linux:   "929665421463109a022d8cc7506ad3eb0f6b48aa6de5e0dd46760b97e2d5e549"
    sha256 x86_64_linux:  "0a1f70f085cc78310f369d371f92ee18334b84e27fea363ac4a89c1daff2e41d"
  end

  keg_only :versioned_formula

  # See: https:mariadb.comkbenchanges-improvements-in-mariadb-1011
  # End-of-life on 2028-02-16: https:mariadb.orgabout#maintenance-policy
  deprecate! date: "2028-02-16", because: :unsupported

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "fmt" => :build
  depends_on "openjdk" => :build
  depends_on "pkgconf" => :build

  depends_on "groonga"
  depends_on "lz4"
  depends_on "lzo"
  depends_on "openssl@3"
  depends_on "pcre2"
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "bzip2"
  uses_from_macos "krb5"
  uses_from_macos "libedit"
  uses_from_macos "libxcrypt"
  uses_from_macos "libxml2"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  on_linux do
    depends_on "linux-pam"
    depends_on "readline" # uses libedit on macOS
  end

  def install
    ENV.runtime_cpu_detection
    ENV.cxx11

    # Backport fix for CMake 4.0 in columnstore submodule
    # https:github.commariadb-corporationmariadb-columnstore-enginecommit726cc3684b4de08934c2b14f347799fd8c3aac9a
    # https:github.commariadb-corporationmariadb-columnstore-enginecommit7e17d8825409fb8cc0629bfd052ffac6e542b50e
    inreplace "storagecolumnstorecolumnstoreCMakeLists.txt",
              "CMAKE_MINIMUM_REQUIRED(VERSION 2.8.12)",
              "CMAKE_MINIMUM_REQUIRED(VERSION 3.10)"

    # Set basedir and ldata so that mysql_install_db can find the server
    # without needing an explicit path to be set. This can still
    # be overridden by calling --basedir= when calling.
    inreplace "scriptsmysql_install_db.sh" do |s|
      s.change_make_var! "basedir", "\"#{prefix}\""
      s.change_make_var! "ldata", "\"#{var}mysql\""
    end

    # Use brew groonga
    rm_r "storagemroongavendorgroonga"

    # -DINSTALL_* are relative to prefix
    args = %W[
      -DMYSQL_DATADIR=#{var}mysql
      -DINSTALL_INCLUDEDIR=includemysql
      -DINSTALL_MANDIR=shareman
      -DINSTALL_DOCDIR=sharedoc#{name}
      -DINSTALL_INFODIR=shareinfo
      -DINSTALL_MYSQLSHAREDIR=sharemysql
      -DWITH_LIBFMT=system
      -DWITH_SSL=system
      -DWITH_UNIT_TESTS=OFF
      -DDEFAULT_CHARSET=utf8mb4
      -DDEFAULT_COLLATION=utf8mb4_general_ci
      -DINSTALL_SYSCONFDIR=#{etc}
      -DCOMPILATION_COMMENT=#{tap.user}
    ]

    if OS.linux?
      args << "-DWITH_NUMA=OFF"
      args << "-DENABLE_DTRACE=NO"
      args << "-DCONNECT_WITH_JDBC=OFF"
    end

    # Disable RocksDB on Apple Silicon (currently not supported)
    args << "-DPLUGIN_ROCKSDB=NO" if Hardware::CPU.arm?

    system "cmake", "-S", ".", "-B", "_build", *std_cmake_args, *args
    system "cmake", "--build", "_build"
    system "cmake", "--install", "_build"

    # Fix my.cnf to point to #{etc} instead of etc
    (etc"my.cnf.d").mkpath
    inreplace "#{etc}my.cnf", "!includedir etcmy.cnf.d",
                               "!includedir #{etc}my.cnf.d"
    touch etc"my.cnf.d.homebrew_dont_prune_me"

    # Save space
    rm_r(prefix"mysql-test")
    rm_r(prefix"sql-bench")

    # Link the setup scripts into bin
    bin.install_symlink [
      prefix"scriptsmariadb-install-db",
      prefix"scriptsmysql_install_db",
    ]

    # Fix up the control script and link into bin
    inreplace "#{prefix}support-filesmysql.server", ^(PATH=".*)("), "\\1:#{HOMEBREW_PREFIX}bin\\2"

    bin.install_symlink prefix"support-filesmysql.server"

    # Move sourced non-executable out of bin into libexec
    libexec.install "#{bin}wsrep_sst_common"
    # Fix up references to wsrep_sst_common
    %w[
      wsrep_sst_mysqldump
      wsrep_sst_rsync
      wsrep_sst_mariabackup
    ].each do |f|
      inreplace "#{bin}#{f}", "$(dirname \"$0\")wsrep_sst_common",
                               "#{libexec}wsrep_sst_common"
    end

    # Install my.cnf that binds to 127.0.0.1 by default
    (buildpath"my.cnf").write <<~INI
      # Default Homebrew MySQL server config
      [mysqld]
      # Only allow connections from localhost
      bind-address = 127.0.0.1
    INI
    etc.install "my.cnf"
  end

  def post_install
    # Make sure the varmysql directory exists
    (var"mysql").mkpath

    # Don't initialize database, it clashes when testing other MySQL-like implementations.
    return if ENV["HOMEBREW_GITHUB_ACTIONS"]

    unless File.exist? "#{var}mysqlmysqluser.frm"
      ENV["TMPDIR"] = nil
      system bin"mysql_install_db", "--verbose", "--user=#{ENV["USER"]}",
        "--basedir=#{prefix}", "--datadir=#{var}mysql", "--tmpdir=tmp"
    end
  end

  def caveats
    <<~EOS
      A "etcmy.cnf" from another install may interfere with a Homebrew-built
      server starting up correctly.

      MySQL is configured to only allow connections from localhost by default
    EOS
  end

  service do
    run [opt_bin"mysqld_safe", "--datadir=#{var}mysql"]
    keep_alive true
    working_dir var
  end

  test do
    (testpath"mysql").mkpath
    (testpath"tmp").mkpath
    system bin"mysql_install_db", "--no-defaults", "--user=#{ENV["USER"]}",
      "--basedir=#{prefix}", "--datadir=#{testpath}mysql", "--tmpdir=#{testpath}tmp",
      "--auth-root-authentication-method=normal"
    port = free_port
    fork do
      system bin"mysqld", "--no-defaults", "--user=#{ENV["USER"]}",
        "--datadir=#{testpath}mysql", "--port=#{port}", "--tmpdir=#{testpath}tmp"
    end
    sleep 5
    assert_match "information_schema",
      shell_output("#{bin}mysql --port=#{port} --user=root --password= --execute='show databases;'")
    system bin"mysqladmin", "--port=#{port}", "--user=root", "--password=", "shutdown"
  end
end