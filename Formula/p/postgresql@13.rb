class PostgresqlAT13 < Formula
  desc "Object-relational database system"
  homepage "https:www.postgresql.org"
  url "https:ftp.postgresql.orgpubsourcev13.17postgresql-13.17.tar.bz2"
  sha256 "022b0a6e7bc374a777eece33708895d7b60cae07d492b286b296a49d7395d78b"
  license "PostgreSQL"

  livecheck do
    url "https:ftp.postgresql.orgpubsource"
    regex(%r{href=["']?v?(13(?:\.\d+)+)?["' >]}i)
  end

  bottle do
    sha256 arm64_sequoia: "7745713fbe04d190ed3be55a0f4538fee3300fda77f34ce6d0f750e3e1eb87a1"
    sha256 arm64_sonoma:  "5b4ef8e48e14f5732ba0f740fd03b9350c857213b15e9e844dc1caba8f54d002"
    sha256 arm64_ventura: "b7d6bd3d6a39351952f81e09ca23a850a1db6258a915987e5f95254c66a5f00c"
    sha256 sonoma:        "cd256078447b76e5cffcb638e04996a52625348a7be74155556bf7ab3581a3cf"
    sha256 ventura:       "f7221bf82699756c42c9619f3836759a6974890ed3b0f66c7404781b2caf2bcb"
    sha256 x86_64_linux:  "45c7899bb5700ae0c0ecf833fd856341ed2592a4f65d197b0bed0970ea9e5950"
  end

  keg_only :versioned_formula

  # https:www.postgresql.orgsupportversioning
  deprecate! date: "2025-11-13", because: :unsupported

  depends_on "pkg-config" => :build
  depends_on "icu4c@76"

  # GSSAPI provided by Kerberos.framework crashes when forked.
  # See https:github.comHomebrewhomebrew-coreissues47494.
  depends_on "krb5"

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
    ENV.delete "PKG_CONFIG_LIBDIR" if OS.mac? && MacOS.version == :catalina
    ENV.prepend "LDFLAGS", "-L#{Formula["openssl@3"].opt_lib} -L#{Formula["readline"].opt_lib}"
    ENV.prepend "CPPFLAGS", "-I#{Formula["openssl@3"].opt_include} -I#{Formula["readline"].opt_include}"

    args = %W[
      --disable-debug
      --prefix=#{prefix}
      --datadir=#{opt_pkgshare}
      --libdir=#{opt_lib}
      --includedir=#{opt_include}
      --sysconfdir=#{etc}
      --docdir=#{doc}
      --enable-thread-safety
      --with-gssapi
      --with-icu
      --with-ldap
      --with-libxml
      --with-libxslt
      --with-openssl
      --with-pam
      --with-perl
      --with-uuid=e2fs
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
          mv -v "#{old_postgres_data_dir}" "#{postgresql_datadir}"

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
    assert_equal opt_pkgshare.to_s, shell_output("#{bin}pg_config --sharedir").chomp
    assert_equal opt_lib.to_s, shell_output("#{bin}pg_config --libdir").chomp
    assert_equal (opt_lib"postgresql").to_s, shell_output("#{bin}pg_config --pkglibdir").chomp
    assert_equal (opt_include"postgresql").to_s, shell_output("#{bin}pg_config --pkgincludedir").chomp
    assert_equal (opt_include"postgresqlserver").to_s, shell_output("#{bin}pg_config --includedir-server").chomp
  end
end