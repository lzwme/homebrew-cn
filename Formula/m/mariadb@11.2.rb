class MariadbAT112 < Formula
  desc "Drop-in replacement for MySQL"
  homepage "https:mariadb.org"
  url "https:archive.mariadb.orgmariadb-11.2.4sourcemariadb-11.2.4.tar.gz"
  sha256 "e16f152a6b60bec0938051a8340e410d33e0708d1f84a2cf38f1b04e4133bf19"
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
    sha256 arm64_sonoma:   "469774894a1d0b5d541c8f8f69f72e3ba93853c04acd56a8e4e314f8e56d7ec3"
    sha256 arm64_ventura:  "f38825629f1343c7f8035f6e698881b82864c85af7ac3c02e95cb72e6b319d0c"
    sha256 arm64_monterey: "6a7ec6bec3a724fd3ce647a32dcdfa8c342f95db5ab7bffc61d4f707db81d755"
    sha256 sonoma:         "2e9a39094ccdaea04be094b815e7a7d8ceb4f3d95c4e5756f1839d12358ac26d"
    sha256 ventura:        "2c205a7ced7ff07db00a64bda70d87d74232377c62641a6161b79212efde61de"
    sha256 monterey:       "91dfd2a75cc471e2c7ac865e34a33f1ae8964e40e6984afb9b27e8c70d1505f4"
    sha256 x86_64_linux:   "294e1d04bae98dece5a291061d89e3cca5cc78611d28251d5026508523b5941b"
  end

  keg_only :versioned_formula

  # See: https:mariadb.comkbenchanges-improvements-in-mariadb-11-2
  # End-of-life on 2024-11-21: https:mariadb.orgabout#maintenance-policy
  disable! date: "2024-11-21", because: :unsupported

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "fmt" => :build
  depends_on "pkg-config" => :build
  depends_on "groonga"
  depends_on "lz4"
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

  fails_with gcc: "5"

  def install
    ENV.cxx11

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

    # Don't create databases inside of the prefix!
    # See: https:github.comHomebrewhomebrewissues4975
    rm_rf prefix"data"

    # Save space
    (prefix"mariadb-test").rmtree
    (prefix"sql-bench").rmtree

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
    (buildpath"my.cnf").write <<~EOS
      # Default Homebrew MySQL server config
      [mysqld]
      # Only allow connections from localhost
      bind-address = 127.0.0.1
    EOS
    etc.install "my.cnf"
  end

  def post_install
    # Make sure the varmysql directory exists
    (var"mysql").mkpath

    # Don't initialize database, it clashes when testing other MySQL-like implementations.
    return if ENV["HOMEBREW_GITHUB_ACTIONS"]

    unless File.exist? "#{var}mysqlmysqluser.frm"
      ENV["TMPDIR"] = nil
      system "#{bin}mysql_install_db", "--verbose", "--user=#{ENV["USER"]}",
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
      system "#{bin}mysqld", "--no-defaults", "--user=#{ENV["USER"]}",
        "--datadir=#{testpath}mysql", "--port=#{port}", "--tmpdir=#{testpath}tmp"
    end
    sleep 5
    assert_match "information_schema",
      shell_output("#{bin}mysql --port=#{port} --user=root --password= --execute='show databases;'")
    system "#{bin}mysqladmin", "--port=#{port}", "--user=root", "--password=", "shutdown"
  end
end