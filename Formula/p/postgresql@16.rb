class PostgresqlAT16 < Formula
  desc "Object-relational database system"
  homepage "https://www.postgresql.org/"
  url "https://ftp.postgresql.org/pub/source/v16.14/postgresql-16.14.tar.bz2"
  sha256 "f6d077142737920858ce958ccdb75c6ee137a63b5b0853c70693d401ac7e3471"
  license "PostgreSQL"

  livecheck do
    url "https://ftp.postgresql.org/pub/source/"
    regex(%r{href=["']?v?(16(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "9b3629bdb5461697a7ee5d6960e7918e827127da5e957871a5c3ddd90d28c60e"
    sha256 arm64_sequoia: "9cb334bfbd88552108d739084d4fae7ea4a50b91890397c43273d430f216ad75"
    sha256 arm64_sonoma:  "43be596e3812a3ab6bc5904646a0187c1aa5e1106d9a363a50c5a31595030842"
    sha256 sonoma:        "ef844af3ad172adf7dc453b16f92b9e05aa1d63720ecc8c2ccdbb59e2b247f10"
    sha256 arm64_linux:   "16d66784d3f7fea7ece17df4a0cf7ea601d868acbe18f6361e53241734c618b6"
    sha256 x86_64_linux:  "a05b05218e16155674612c9b6eb26df5a48119396362178512d0a492f78b28a2"
  end

  keg_only :versioned_formula

  # https://www.postgresql.org/support/versioning/
  deprecate! date: "2028-11-09", because: :unsupported
  disable! date: "2029-11-09", because: :unsupported

  depends_on "gettext" => :build
  depends_on "pkgconf" => :build
  depends_on "icu4c@78"

  # GSSAPI provided by Kerberos.framework crashes when forked.
  # See https://github.com/Homebrew/homebrew-core/issues/47494.
  depends_on "krb5"

  depends_on "lz4"
  depends_on "openssl@3"
  depends_on "readline"
  depends_on "zstd"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"
  uses_from_macos "openldap"
  uses_from_macos "perl"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "linux-pam"
    depends_on "util-linux"
    depends_on "zlib-ng-compat"
  end

  def install
    ENV.runtime_cpu_detection
    ENV.delete "PKG_CONFIG_LIBDIR"
    ENV.prepend "LDFLAGS", "-L#{formula_opt_lib("openssl@3")} -L#{formula_opt_lib("readline")}"
    ENV.prepend "CPPFLAGS", "-I#{formula_opt_include("openssl@3")} -I#{formula_opt_include("readline")}"

    # Fix 'libintl.h' file not found for extensions
    # Update config to fix `error: could not find function 'gss_store_cred_into' required for GSSAPI`
    if OS.mac?
      ENV.prepend "LDFLAGS", "-L#{formula_opt_lib("gettext")} -L#{formula_opt_lib("krb5")}"
      ENV.prepend "CPPFLAGS", "-I#{formula_opt_include("gettext")} -I#{formula_opt_include("krb5")}"
    end

    args = %W[
      --datadir=#{opt_pkgshare}
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
    ]
    args << "--with-extra-version= (#{tap.user})" if tap
    args += %w[--with-bonjour --with-tcl] if OS.mac?

    # PostgreSQL by default uses xcodebuild internally to determine this,
    # which does not work on CLT-only installs.
    args << "PG_SYSROOT=#{MacOS.sdk_path}" if OS.mac?

    system "./configure", *args, *std_configure_args(libdir: opt_lib)

    # Work around busted path magic in Makefile.global.in. This can't be specified
    # in ./configure, but needs to be set here otherwise install prefixes containing
    # the string "postgres" will get an incorrect pkglibdir.
    # See https://github.com/Homebrew/homebrew-core/issues/62930#issuecomment-709411789
    system "make", "pkglibdir=#{opt_lib}/postgresql",
                   "pkgincludedir=#{opt_include}/postgresql",
                   "includedir_server=#{opt_include}/postgresql/server"
    system "make", "install-world", "datadir=#{pkgshare}",
                                    "libdir=#{lib}",
                                    "pkglibdir=#{lib}/postgresql",
                                    "includedir=#{include}",
                                    "pkgincludedir=#{include}/postgresql",
                                    "includedir_server=#{include}/postgresql/server",
                                    "includedir_internal=#{include}/postgresql/internal"
  end

  post_install_steps do
    mkdir_p "log", base: :var
    # Don't initialize database, it clashes when testing other PostgreSQL versions.
    init_data_dir "postgresql@16", using: :postgresql_initdb, base: :var
  end

  def postgresql_datadir
    var/name
  end

  def postgresql_log_path
    var/"log/#{name}.log"
  end

  def caveats
    <<~EOS
      This formula has created a default database cluster with:
        initdb --locale=en_US.UTF-8 -E UTF-8 #{postgresql_datadir}
    EOS
  end

  service do
    run [opt_bin/"postgres", "-D", f.postgresql_datadir]
    environment_variables LC_ALL: "en_US.UTF-8"
    keep_alive true
    log_path f.postgresql_log_path
    error_log_path f.postgresql_log_path
    stop_timeout 120
    working_dir HOMEBREW_PREFIX
  end

  test do
    system bin/"initdb", "--locale=en_US.UTF-8", "-E UTF-8", testpath/"test" unless ENV["HOMEBREW_GITHUB_ACTIONS"]
    assert_equal opt_pkgshare.to_s, shell_output("#{bin}/pg_config --sharedir").chomp
    assert_equal opt_lib.to_s, shell_output("#{bin}/pg_config --libdir").chomp
    assert_equal (opt_lib/"postgresql").to_s, shell_output("#{bin}/pg_config --pkglibdir").chomp
    assert_equal (opt_include/"postgresql").to_s, shell_output("#{bin}/pg_config --pkgincludedir").chomp
    assert_equal (opt_include/"postgresql/server").to_s, shell_output("#{bin}/pg_config --includedir-server").chomp
    assert_match "-I#{formula_opt_include("gettext")}", shell_output("#{bin}/pg_config --cppflags") if OS.mac?
  end
end