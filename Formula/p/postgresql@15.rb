class PostgresqlAT15 < Formula
  desc "Object-relational database system"
  homepage "https:www.postgresql.org"
  url "https:ftp.postgresql.orgpubsourcev15.12postgresql-15.12.tar.bz2"
  sha256 "3bc8462a38ca0857270cc88b949a3f6659f0d5c44c029c482355835b61a0f6f7"
  license "PostgreSQL"

  livecheck do
    url "https:ftp.postgresql.orgpubsource"
    regex(%r{href=["']?v?(15(?:\.\d+)+)?["' >]}i)
  end

  bottle do
    sha256 arm64_sequoia: "f20aaa0f31d343df90bd0a20da68415f0807e03680882811bc56e469d4879a37"
    sha256 arm64_sonoma:  "0c5d085ceb11864335e20ef9cb7248a3ce6ef0ccd0d27c303b07eebe5b0fe162"
    sha256 arm64_ventura: "2bdfda8e68ef69bbb7949db9b7eb2b03559d0b5e31646bc5a575de2b7fe0ec6f"
    sha256 sonoma:        "2a0888df6851f4b737ecbdbb48563668317eed09983f530480faa859b6a8ad13"
    sha256 ventura:       "d54d57de09bb101f522652b48514fbeec6b31ea72fb31a734dc3feb2e9df7ef7"
    sha256 x86_64_linux:  "1cd3699addf2292e3cf0b11ab702c8d001bf00d3095fc0bef9b27fa3a65f1765"
  end

  keg_only :versioned_formula

  # https:www.postgresql.orgsupportversioning
  deprecate! date: "2027-11-11", because: :unsupported

  depends_on "gettext" => :build
  depends_on "pkgconf" => :build
  depends_on "icu4c@76"

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

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "linux-pam"
    depends_on "util-linux"
  end

  def install
    ENV.delete "PKG_CONFIG_LIBDIR"
    ENV.prepend "LDFLAGS", "-L#{Formula["openssl@3"].opt_lib} -L#{Formula["readline"].opt_lib}"
    ENV.prepend "CPPFLAGS", "-I#{Formula["openssl@3"].opt_include} -I#{Formula["readline"].opt_include}"

    # Fix 'libintl.h' file not found for extensions
    if OS.mac?
      ENV.prepend "LDFLAGS", "-L#{Formula["gettext"].opt_lib}"
      ENV.prepend "CPPFLAGS", "-I#{Formula["gettext"].opt_include}"
    end

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
    args += %w[--with-bonjour --with-tcl] if OS.mac?

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
    return unless OS.linux?

    inreplace lib"postgresqlpgxssrcMakefile.global",
              "LD = #{Superenv.shims_path}ld",
              "LD = #{HOMEBREW_PREFIX}binld"
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
    assert_match "-I#{Formula["gettext"].opt_include}", shell_output("#{bin}pg_config --cppflags") if OS.mac?
  end
end