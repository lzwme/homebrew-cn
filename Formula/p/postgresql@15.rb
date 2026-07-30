class PostgresqlAT15 < Formula
  desc "Object-relational database system"
  homepage "https://www.postgresql.org/"
  url "https://ftp.postgresql.org/pub/source/v15.18/postgresql-15.18.tar.bz2"
  sha256 "11df0df97fe3ea4ba9a791faaf39cee1d2fe571e78885b5b55d8517d27c323b4"
  license "PostgreSQL"

  livecheck do
    url "https://ftp.postgresql.org/pub/source/"
    regex(%r{href=["']?v?(15(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "b890443db8b444981e8be8cff934f606e10aa2d23cd6b5ba4944a76226654556"
    sha256 arm64_sequoia: "409d0e72686098efd0c853726fcaa266b4ed3842d871cad9967d7c6bab1c426b"
    sha256 arm64_sonoma:  "5b9647b34e1f52939bc7b397f9fea5305fd50d27ab22f32d15ac525d432bf64a"
    sha256 sonoma:        "f5207dbea25405f2d64105af560a3e0d2dcf9d116ef34a7d0f2537700f648a1f"
    sha256 arm64_linux:   "0cba6662608b5ab451db66ef8ee9f0c08c3e0d9e70275578dcbddaae55a2d705"
    sha256 x86_64_linux:  "8dd17a19cca3a890314bafcbd51867bb2003333aa3def1ec688a1765a83125b5"
  end

  keg_only :versioned_formula

  # https://www.postgresql.org/support/versioning/
  deprecate! date: "2027-11-11", because: :unsupported
  disable! date: "2028-11-11", because: :unsupported

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
    if OS.mac?
      ENV.prepend "LDFLAGS", "-L#{formula_opt_lib("gettext")}"
      ENV.prepend "CPPFLAGS", "-I#{formula_opt_include("gettext")}"
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
    args << "PG_SYSROOT=#{MacOS.sdk_path}" if OS.mac?

    system "./configure", *args

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
    return unless OS.linux?

    inreplace lib/"postgresql/pgxs/src/Makefile.global",
              "LD = #{Superenv.shims_path}/ld",
              "LD = #{HOMEBREW_PREFIX}/bin/ld"
  end

  post_install_steps do
    mkdir_p "log"
    # Don't initialize database, it clashes when testing other PostgreSQL versions.
    init_data_dir "postgresql@15", using: :postgresql_initdb
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