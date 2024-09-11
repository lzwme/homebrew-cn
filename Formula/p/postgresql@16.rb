class PostgresqlAT16 < Formula
  desc "Object-relational database system"
  homepage "https:www.postgresql.org"
  url "https:ftp.postgresql.orgpubsourcev16.4postgresql-16.4.tar.bz2"
  sha256 "971766d645aa73e93b9ef4e3be44201b4f45b5477095b049125403f9f3386d6f"
  license "PostgreSQL"

  livecheck do
    url "https:ftp.postgresql.orgpubsource"
    regex(%r{href=["']?v?(16(?:\.\d+)+)?["' >]}i)
  end

  bottle do
    sha256 arm64_sequoia:  "a1aecd400e314523e21b6df87068a0c1c8a08a1510f7d7ac8c62ab6a57d85992"
    sha256 arm64_sonoma:   "c46a6c35fc22994ddd2d4b9ac42ce8d2669bf42bbf227eca3923a7450ee995bb"
    sha256 arm64_ventura:  "250201e11e8f8e15a5e6f6d634143901d011ea844f03071e4a26582293af8320"
    sha256 arm64_monterey: "a98f50066e7addcab7b0e9b8a222f44254194c1e9e53f5f313ea319b4d1df71a"
    sha256 sonoma:         "cfe682fd3eb27215b051396c8fd34f6e16515db833016c4eaccd09c9ffc64e87"
    sha256 ventura:        "74d6eb771a702af02ec01794fed4b0484ddabc622a4a7dcc89dff7e659baf1d3"
    sha256 monterey:       "fbf1a7624b33b7e2f4175a204711f6e75cecfa9ab96a037fe83d905ea92a63f9"
    sha256 x86_64_linux:   "7d030bae122c351f6c477f8e5715ac5340a4cce3f88879700ae44b7c1c22e1aa"
  end

  keg_only :versioned_formula

  # https:www.postgresql.orgsupportversioning
  deprecate! date: "2028-11-09", because: :unsupported

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "icu4c"

  # GSSAPI provided by Kerberos.framework crashes when forked.
  # See https:github.comHomebrewhomebrew-coreissues47494.
  depends_on "krb5"

  depends_on "lz4"
  depends_on "openssl@3"
  depends_on "readline"
  depends_on "zstd"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"
  uses_from_macos "openldap"
  uses_from_macos "perl"
  uses_from_macos "zlib"

  on_linux do
    depends_on "linux-pam"
    depends_on "util-linux"
  end

  def install
    ENV.delete "PKG_CONFIG_LIBDIR"
    ENV.prepend "LDFLAGS", "-L#{Formula["openssl@3"].opt_lib} -L#{Formula["readline"].opt_lib}"
    ENV.prepend "CPPFLAGS", "-I#{Formula["openssl@3"].opt_include} -I#{Formula["readline"].opt_include}"

    # Fix 'libintl.h' file not found for extensions
    ENV.prepend "LDFLAGS", "-L#{Formula["gettext"].opt_lib}"
    ENV.prepend "CPPFLAGS", "-I#{Formula["gettext"].opt_include}"

    args = std_configure_args + %W[
      --datadir=#{opt_pkgshare}
      --libdir=#{opt_lib}
      --includedir=#{opt_include}
      --sysconfdir=#{etc}
      --docdir=#{doc}
      --enable-nls
      --enable-thread-safety
      --with-gssapi
      --with-icu
      --with-ldap
      --with-libxml
      --with-libxslt
      --with-lz4
      --with-zstd
      --with-openssl
      --with-pam
      --with-perl
      --with-uuid=e2fs
      --with-extra-version=\ (#{tap.user})
    ]
    if OS.mac?
      args += %w[
        --with-bonjour
        --with-tcl
      ]
    end

    # PostgreSQL by default uses xcodebuild internally to determine this,
    # which does not work on CLT-only installs.
    args << "PG_SYSROOT=#{MacOS.sdk_path}" if OS.mac? && MacOS.sdk_root_needed?

    system ".configure", *args

    # Work around busted path magic in Makefile.global.in. This can't be specified
    # in .configure, but needs to be set here otherwise install prefixes containing
    # the string "postgres" will get an incorrect pkglibdir.
    # See https:github.comHomebrewhomebrew-coreissues62930#issuecomment-709411789
    system "make", "pkglibdir=#{opt_lib}postgresql",
                   "pkgincludedir=#{opt_include}postgresql",
                   "includedir_server=#{opt_include}postgresqlserver"
    system "make", "install-world", "datadir=#{pkgshare}",
                                    "libdir=#{lib}",
                                    "pkglibdir=#{lib}postgresql",
                                    "includedir=#{include}",
                                    "pkgincludedir=#{include}postgresql",
                                    "includedir_server=#{include}postgresqlserver",
                                    "includedir_internal=#{include}postgresqlinternal"
  end

  def post_install
    (var"log").mkpath
    postgresql_datadir.mkpath

    # Don't initialize database, it clashes when testing other PostgreSQL versions.
    return if ENV["HOMEBREW_GITHUB_ACTIONS"]

    system bin"initdb", "--locale=C", "-E", "UTF-8", postgresql_datadir unless pg_version_exists?
  end

  def postgresql_datadir
    varname
  end

  def postgresql_log_path
    var"log#{name}.log"
  end

  def pg_version_exists?
    (postgresql_datadir"PG_VERSION").exist?
  end

  def caveats
    <<~EOS
      This formula has created a default database cluster with:
        initdb --locale=C -E UTF-8 #{postgresql_datadir}
      For more details, read:
        https:www.postgresql.orgdocs#{version.major}app-initdb.html
    EOS
  end

  service do
    run [opt_bin"postgres", "-D", f.postgresql_datadir]
    environment_variables LC_ALL: "C"
    keep_alive true
    log_path f.postgresql_log_path
    error_log_path f.postgresql_log_path
    working_dir HOMEBREW_PREFIX
  end

  test do
    system bin"initdb", testpath"test" unless ENV["HOMEBREW_GITHUB_ACTIONS"]
    assert_equal opt_pkgshare.to_s, shell_output("#{bin}pg_config --sharedir").chomp
    assert_equal opt_lib.to_s, shell_output("#{bin}pg_config --libdir").chomp
    assert_equal (opt_lib"postgresql").to_s, shell_output("#{bin}pg_config --pkglibdir").chomp
    assert_equal (opt_include"postgresql").to_s, shell_output("#{bin}pg_config --pkgincludedir").chomp
    assert_equal (opt_include"postgresqlserver").to_s, shell_output("#{bin}pg_config --includedir-server").chomp
    assert_match "-I#{Formula["gettext"].opt_include}", shell_output("#{bin}pg_config --cppflags")
  end
end