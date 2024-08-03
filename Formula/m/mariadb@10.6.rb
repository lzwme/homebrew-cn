class MariadbAT106 < Formula
  desc "Drop-in replacement for MySQL"
  homepage "https:mariadb.org"
  url "https:archive.mariadb.orgmariadb-10.6.18sourcemariadb-10.6.18.tar.gz"
  sha256 "6898a1111f47130709e28ba2c7bd1a57e4bb57101f6e109e597d51e6d385cf18"
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
    sha256 arm64_sonoma:   "cb27e0bc5d7de68ef196a59c95157cc131e85319a90df977294b442a2514c37d"
    sha256 arm64_ventura:  "be38e39b817a0c6eef01c0d21243269da935cbc694651247be7bce8ac16447d7"
    sha256 arm64_monterey: "970e571b0c8e6dcba0ec31f73dfe73b8a1e4b858ab26ab78494b61839b61555f"
    sha256 sonoma:         "ec248a67955a67ccdbf1eba4fe1c90b4a390d62230503c8566c726c1cedf1438"
    sha256 ventura:        "cc42afccd4eec25083454fdd1190db9c96d4f192eb8e7d7bca405a388da34304"
    sha256 monterey:       "5be23da1b1e208992a2852a0b806ba0aaf5516f8331fc953cf105b5b3eeee85e"
    sha256 x86_64_linux:   "6c488b264ec037cfc98844e95c17a1b851a8cfcde1dce3db15a91d1ceb95bdfa"
  end

  keg_only :versioned_formula

  # See: https:mariadb.comkbenchanges-improvements-in-mariadb-106
  deprecate! date: "2026-06-01", because: :unsupported

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "groonga"
  depends_on "openssl@3"
  depends_on "pcre2"

  uses_from_macos "bzip2"
  uses_from_macos "krb5"
  uses_from_macos "libedit"
  uses_from_macos "libxcrypt"
  uses_from_macos "libxml2"
  uses_from_macos "ncurses"
  uses_from_macos "xz"
  uses_from_macos "zlib"

  on_linux do
    depends_on "linux-pam"
    depends_on "readline" # uses libedit on macOS
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

    # Disable RocksDB on Apple Silicon (currently not supported)
    args << "-DPLUGIN_ROCKSDB=NO" if Hardware::CPU.arm?

    system "cmake", ".", *std_cmake_args, *args

    system "make"
    system "make", "install"

    # Fix my.cnf to point to #{etc} instead of etc
    (etc"my.cnf.d").mkpath
    inreplace "#{etc}my.cnf", "!includedir etcmy.cnf.d",
                               "!includedir #{etc}my.cnf.d"
    touch etc"my.cnf.d.homebrew_dont_prune_me"

    # Don't create databases inside of the prefix!
    # See: https:github.comHomebrewhomebrewissues4975
    rm_r(prefix"data")

    # Save space
    rm_r(prefix"mysql-test")
    rm_r(prefix"sql-bench")

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