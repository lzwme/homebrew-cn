class PostgresqlAT14 < Formula
  desc "Object-relational database system"
  homepage "https:www.postgresql.org"
  url "https:ftp.postgresql.orgpubsourcev14.14postgresql-14.14.tar.bz2"
  sha256 "84727fbccdbd1efe01d8de64bc1b33095db773ad2457cefcedc2d8258ebc09d6"
  license "PostgreSQL"

  livecheck do
    url "https:ftp.postgresql.orgpubsource"
    regex(%r{href=["']?v?(14(?:\.\d+)+)?["' >]}i)
  end

  bottle do
    sha256 arm64_sequoia: "12b74c51edfd5b5f2a912563a6d216c2e0145bda27bbffdba185fa709e96e661"
    sha256 arm64_sonoma:  "23d8a2dcc2fa1829946d3104a972d924f49ed6d15fb3929eaa95b4b289aa4af8"
    sha256 arm64_ventura: "60d7d44587f8914878f82025e09e2c8c3d65b7a5db52702c6d06bde08f5962e3"
    sha256 sonoma:        "c07b2dfb52dd7467162734f8f1b659f497a3874ca521c5e83025cf9457981bea"
    sha256 ventura:       "f26eba2bc496e3f3773c4ad6a6c1c62757fde5ec2d996850066eca9680130f52"
    sha256 x86_64_linux:  "190513a4004fc9c4150d72ac5d2237a58f58cd24bbe19a4c1c4a4adc843edb1f"
  end

  # https:www.postgresql.orgsupportversioning
  deprecate! date: "2026-11-12", because: :unsupported

  depends_on "pkg-config" => :build
  depends_on "icu4c@76"

  # GSSAPI provided by Kerberos.framework crashes when forked.
  # See https:github.comHomebrewhomebrew-coreissues47494.
  depends_on "krb5"

  depends_on "lz4"
  depends_on "openssl@3"
  depends_on "readline"

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
    ENV.prepend "LDFLAGS", "-L#{Formula["openssl@3"].opt_lib} -L#{Formula["readline"].opt_lib}"
    ENV.prepend "CPPFLAGS", "-I#{Formula["openssl@3"].opt_include} -I#{Formula["readline"].opt_include}"

    args = %W[
      --disable-debug
      --prefix=#{prefix}
      --datadir=#{HOMEBREW_PREFIX}share#{name}
      --libdir=#{HOMEBREW_PREFIX}lib#{name}
      --includedir=#{HOMEBREW_PREFIX}include#{name}
      --enable-thread-safety
      --with-gssapi
      --with-icu
      --with-ldap
      --with-libxml
      --with-libxslt
      --with-lz4
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
    system "make"
    system "make", "install-world", "datadir=#{pkgshare}",
                                    "libdir=#{lib}#{name}",
                                    "pkglibdir=#{lib}#{name}",
                                    "includedir=#{include}#{name}",
                                    "pkgincludedir=#{include}#{name}",
                                    "includedir_server=#{include}#{name}server",
                                    "includedir_internal=#{include}#{name}internal"
    return unless OS.linux?

    inreplace libname"pgxssrcMakefile.global",
              "LD = #{Superenv.shims_path}ld",
              "LD = #{HOMEBREW_PREFIX}binld"
  end

  def post_install
    (var"log").mkpath
    postgresql_datadir.mkpath

    odeprecated old_postgres_data_dir, new_postgres_data_dir if old_postgres_data_dir.exist?

    # Don't initialize database, it clashes when testing other PostgreSQL versions.
    return if ENV["HOMEBREW_GITHUB_ACTIONS"]

    system bin"initdb", "--locale=C", "-E", "UTF-8", postgresql_datadir unless pg_version_exists?
  end

  def postgresql_datadir
    if old_postgres_data_dir.exist?
      old_postgres_data_dir
    else
      new_postgres_data_dir
    end
  end

  def postgresql_log_path
    var"log#{name}.log"
  end

  def pg_version_exists?
    (postgresql_datadir"PG_VERSION").exist?
  end

  def new_postgres_data_dir
    varname
  end

  def old_postgres_data_dir
    var"postgres"
  end

  # Figure out what version of PostgreSQL the old data dir is
  # using
  def old_postgresql_datadir_version
    pg_version = old_postgres_data_dir"PG_VERSION"
    pg_version.exist? && pg_version.read.chomp
  end

  def caveats
    caveats = ""

    # Extract the version from the formula name
    pg_formula_version = version.major.to_s
    # ... and check it against the old data dir postgres version number
    # to see if we need to print a warning re: data dir
    if old_postgresql_datadir_version == pg_formula_version
      caveats += <<~EOS
        Previous versions of postgresql shared the same data directory.

        You can migrate to a versioned data directory by running:
          mv -v "#{old_postgres_data_dir}" "#{new_postgres_data_dir}"

        (Make sure PostgreSQL is stopped before executing this command)

      EOS
    end

    caveats += <<~EOS
      This formula has created a default database cluster with:
        initdb --locale=C -E UTF-8 #{postgresql_datadir}
    EOS

    caveats
  end

  service do
    run [opt_bin"postgres", "-D", f.postgresql_datadir]
    keep_alive true
    log_path f.postgresql_log_path
    error_log_path f.postgresql_log_path
    working_dir HOMEBREW_PREFIX
  end

  test do
    system bin"initdb", testpath"test" unless ENV["HOMEBREW_GITHUB_ACTIONS"]
    assert_equal "#{HOMEBREW_PREFIX}share#{name}", shell_output("#{bin}pg_config --sharedir").chomp
    assert_equal "#{HOMEBREW_PREFIX}lib#{name}", shell_output("#{bin}pg_config --libdir").chomp
    assert_equal "#{HOMEBREW_PREFIX}lib#{name}", shell_output("#{bin}pg_config --pkglibdir").chomp
    assert_equal "#{HOMEBREW_PREFIX}include#{name}", shell_output("#{bin}pg_config --includedir").chomp
  end
end