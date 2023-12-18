class MariadbAT105 < Formula
  desc "Drop-in replacement for MySQL"
  homepage "https:mariadb.org"
  url "https:archive.mariadb.orgmariadb-10.5.23sourcemariadb-10.5.23.tar.gz"
  sha256 "3f7c33b208cb799db014a874f56718eadff22ee95781fa360aa6bc696109acfe"
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
    sha256 arm64_sonoma:   "9328221907f57809dd15d25ab472e1263fd50aae39b59bd88b4fc3a8e2a97348"
    sha256 arm64_ventura:  "eba1eb7d12e783a4331d0dbca560771035e523b85a49dde719a285f3705b8b91"
    sha256 arm64_monterey: "21d100eb692a2593c47847e08ef8e7b7c876afa20621217d8874167cb58ea656"
    sha256 sonoma:         "8e421c95ed7f82a593056e96825c18543502eb53af4e7d65a3c4463964ca8561"
    sha256 ventura:        "16c53e5788154e1feca1c73e68d782e997724d1a52eee2ba80d80f430b33d043"
    sha256 monterey:       "fd9ab6bb58b00513b6861f8ceb8311507ba459cbccb089498bb26f04099555dd"
    sha256 x86_64_linux:   "ce3b7537b6b512d05ec3141b628286cae66fe4ab8cabe4d160bff70f0bbbfada"
  end

  keg_only :versioned_formula

  # See: https:mariadb.comkbenchanges-improvements-in-mariadb-105
  # End-of-life on 2025-06-24: https:mariadb.orgabout#maintenance-policy
  deprecate! date: "2025-06-24", because: :unsupported

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "groonga"
  depends_on "openssl@3"
  depends_on "pcre2"

  uses_from_macos "bzip2"
  uses_from_macos "libxcrypt"
  uses_from_macos "libxml2"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  on_linux do
    depends_on "linux-pam"
  end

  fails_with gcc: "5"

  def install
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
      -DWITH_READLINE=yes
      -DWITH_SSL=yes
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

    if OS.mac?
      args << "-DWITH_READLINE=NO" # uses libedit on macOS
    end

    # disable TokuDB, which is currently not supported on macOS
    args << "-DPLUGIN_TOKUDB=NO"

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
    (prefix"mysql-test").rmtree
    (prefix"sql-bench").rmtree

    # Link the setup script into bin
    bin.install_symlink prefix"scriptsmysql_install_db"

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