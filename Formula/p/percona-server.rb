class PerconaServer < Formula
  desc "Drop-in MySQL replacement"
  homepage "https:www.percona.com"
  url "https:downloads.percona.comdownloadsPercona-Server-8.0Percona-Server-8.0.36-28sourcetarballpercona-server-8.0.36-28.tar.gz"
  sha256 "8a4b44bd9cf79a38e6275e8f5f9d4e8d2c308854b71fd5bf5d1728fff43a6844"
  license "BSD-3-Clause"
  revision 5

  livecheck do
    url "https:docs.percona.compercona-serverlatest"
    regex(href=.*?v?(\d+(?:[.-]\d+)+)\.htmli)
    strategy :page_match do |page, regex|
      page.scan(regex).map do |match|
        # Convert a version like 1.2.3-4.0 to 1.2.3-4 (but leave a version like
        # 1.2.3-4.5 as-is).
        match[0].sub((-\d+)\.0$, '\1')
      end
    end
  end

  bottle do
    sha256 arm64_sequoia: "fec95e510b9791fb9797228d29d757e9c4c1453d36d8390a53794df17806512f"
    sha256 arm64_sonoma:  "4ae492edceda80ef8b82348a449092c4b4e5a1f7fd3d52a851f11cb82b07b694"
    sha256 arm64_ventura: "1587b3cb95c97e79ac2e6d86596d3c948fe5516feffab946a68b976f4b76e4ff"
    sha256 sonoma:        "c89b003df5aa0d63ed12c7aab667422f563235e70b982074e07f7fb828fa5cb8"
    sha256 ventura:       "f0abcb7718fa4ecd85751b3a80e83664af0146bba7d37b089bc96f8678010076"
    sha256 x86_64_linux:  "e878b7107cb796cb84b2472943e95203991dbdd9b6c5b075bbdeb0c2ba271461"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "abseil"
  depends_on "icu4c@76"
  depends_on "libevent"
  depends_on "libfido2"
  depends_on "lz4"
  depends_on "openldap" # Needs `ldap_set_urllist_proc`, not provided by LDAP.framework
  depends_on "openssl@3"
  depends_on "protobuf"
  depends_on "zlib" # Zlib 1.2.13+
  depends_on "zstd"

  uses_from_macos "curl"
  uses_from_macos "cyrus-sasl"
  uses_from_macos "krb5"
  uses_from_macos "libedit"

  on_linux do
    depends_on "patchelf" => :build
    depends_on "libtirpc"
    depends_on "readline"
  end

  conflicts_with "mariadb", "mysql", because: "percona, mariadb, and mysql install the same binaries"

  # https:bugs.mysql.combug.php?id=86711
  # https:github.comHomebrewhomebrew-corepull20538
  fails_with :clang do
    build 800
    cause "Wrong inlining with Clang 8.0, see MySQL Bug #86711"
  end

  # https:github.comperconapercona-serverblobPercona-Server-#{version}cmakeboost.cmake
  resource "boost" do
    url "https:boostorg.jfrog.ioartifactorymainrelease1.77.0sourceboost_1_77_0.tar.bz2"
    sha256 "fc9f85fc030e233142908241af7a846e60630aa7388de9a5fafb1f3a26840854"
  end

  # Backport support for newer Protobuf. Remove with 8.0.39  8.4.2
  patch do
    url "https:github.comperconapercona-servercommit089c011f8e2a865e4bd97715653b4bc0973c43a1.patch?full_index=1"
    sha256 "aac166f579e636923abeb86cc89934efaf0185df35355aab2d08192d9bf9efd8"
  end
  # Backport support for Protobuf 22+ on Linux. Remove with 8.0.40  8.4.3
  patch do
    url "https:github.commysqlmysql-servercommit269abc0409b22bb87ec88bd4d53dfb7a1403eace.patch?full_index=1"
    sha256 "ffcee32804e7e1237907432adb3590fcbf30c625eea836df6760c05a312a84e1"
  end

  # Patch out check for Homebrew `boost`.
  # This should not be necessary when building inside `brew`.
  # https:github.comHomebrewhomebrew-test-botpull820
  patch do
    url "https:raw.githubusercontent.comHomebrewformula-patches030f7433e89376ffcff836bb68b3903ab90f9cdcmysqlboost-check.patch"
    sha256 "af27e4b82c84f958f91404a9661e999ccd1742f57853978d8baec2f993b51153"
  end

  def install
    # Find Homebrew OpenLDAP instead of the macOS framework
    inreplace "cmakeldap.cmake", "NAMES ldap_r ldap", "NAMES ldap"

    # Fix mysqlrouter_passwd RPATH to link to metadata_cache.so
    inreplace "routersrchttpsrcCMakeLists.txt",
              "ADD_INSTALL_RPATH(mysqlrouter_passwd \"${ROUTER_INSTALL_RPATH}\")",
              "\\0\nADD_INSTALL_RPATH(mysqlrouter_passwd \"${RPATH_ORIGIN}..${ROUTER_INSTALL_PLUGINDIR}\")"

    # Disable ABI checking
    inreplace "cmakeabi_check.cmake", "RUN_ABI_CHECK 1", "RUN_ABI_CHECK 0" if OS.linux?

    # -DINSTALL_* are relative to `CMAKE_INSTALL_PREFIX` (`prefix`)
    args = %W[
      -DCOMPILATION_COMMENT=Homebrew
      -DDEFAULT_CHARSET=utf8mb4
      -DDEFAULT_COLLATION=utf8mb4_0900_ai_ci
      -DINSTALL_DOCDIR=sharedoc#{name}
      -DINSTALL_INCLUDEDIR=includemysql
      -DINSTALL_INFODIR=shareinfo
      -DINSTALL_MANDIR=shareman
      -DINSTALL_MYSQLSHAREDIR=sharemysql
      -DINSTALL_PLUGINDIR=libpercona-serverplugin
      -DMYSQL_DATADIR=#{var}mysql
      -DSYSCONFDIR=#{etc}
      -DWITH_EMBEDDED_SERVER=ON
      -DWITH_INNODB_MEMCACHED=ON
      -DWITH_UNIT_TESTS=OFF
      -DWITH_SYSTEM_LIBS=ON
      -DWITH_EDITLINE=system
      -DWITH_FIDO=system
      -DWITH_ICU=system
      -DWITH_LIBEVENT=system
      -DWITH_LZ4=system
      -DWITH_PROTOBUF=system
      -DWITH_SSL=system
      -DOPENSSL_ROOT_DIR=#{Formula["openssl@3"].opt_prefix}
      -DWITH_ZLIB=system
      -DWITH_ZSTD=system
    ]

    # MySQL >5.7.x mandates Boost as a requirement to build & has a strict
    # version check in place to ensure it only builds against expected release.
    # This is problematic when Boost releases don't align with MySQL releases.
    (buildpath"boost").install resource("boost")
    args << "-DWITH_BOOST=#{buildpath}boost"

    # Percona MyRocks does not compile on macOS
    # https:bugs.launchpad.netpercona-server+bug1741639
    args << "-DWITHOUT_ROCKSDB=1"

    # TokuDB does not compile on macOS
    # https:bugs.launchpad.netpercona-server+bug1531446
    args << "-DWITHOUT_TOKUDB=1"

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    (prefix"mysql-test").cd do
      test_args = ["--vardir=#{Dir.mktmpdir}"]
      # For Linux, disable failing on warning: "Setting thread 31563 nice to 0 failed"
      # Docker containers lack CAP_SYS_NICE capability by default.
      test_args << "--nowarnings" if OS.linux?
      system ".mysql-test-run.pl", "status", *test_args
    end

    # Remove the tests directory
    rm_r(prefix"mysql-test")

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
    EOS
    etc.install "my.cnf"
  end

  def post_install
    # Make sure the varmysql directory exists
    (var"mysql").mkpath

    # Don't initialize database, it clashes when testing other MySQL-like implementations.
    return if ENV["HOMEBREW_GITHUB_ACTIONS"]

    unless (var"mysqlmysqluser.frm").exist?
      ENV["TMPDIR"] = nil
      system bin"mysqld", "--initialize-insecure", "--user=#{ENV["USER"]}",
        "--basedir=#{prefix}", "--datadir=#{var}mysql", "--tmpdir=tmp"
    end
  end

  def caveats
    s = <<~EOS
      We've installed your MySQL database without a root password. To secure it run:
          mysql_secure_installation
      MySQL is configured to only allow connections from localhost by default
      To connect run:
          mysql -uroot
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
      system bin"mysqld", "--no-defaults", "--user=#{ENV["USER"]}",
        "--datadir=#{testpath}mysql", "--port=#{port}", "--tmpdir=#{testpath}tmp"
    end
    sleep 5
    assert_match "information_schema",
      shell_output("#{bin}mysql --port=#{port} --user=root --password= --execute='show databases;'")
    system bin"mysqladmin", "--port=#{port}", "--user=root", "--password=", "shutdown"
  end
end