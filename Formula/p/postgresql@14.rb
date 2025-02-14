class PostgresqlAT14 < Formula
  desc "Object-relational database system"
  homepage "https:www.postgresql.org"
  url "https:ftp.postgresql.orgpubsourcev14.16postgresql-14.16.tar.bz2"
  sha256 "673c26f15ebb14306ad0ea051d8acfb3915dd342de942f5b502e5354a0ab760c"
  license "PostgreSQL"

  livecheck do
    url "https:ftp.postgresql.orgpubsource"
    regex(%r{href=["']?v?(14(?:\.\d+)+)?["' >]}i)
  end

  bottle do
    sha256 arm64_sequoia: "ec2d97d524cf656a1c06384594e42f8de27cfb79ed2203f86404c591d9b6a4c5"
    sha256 arm64_sonoma:  "5b98dbed99fe2e8acb7c247255c7624bedd2c892c9b5b1964cba16656a5f25a3"
    sha256 arm64_ventura: "0e1f509c88c1c9db7dd90ae79d6c2eea7725974b7e910c5482814af3099657ff"
    sha256 sonoma:        "027e8c24358630b8c8c2d20fec4e024edf7078c6e1726f54a327f2a4348b30cb"
    sha256 ventura:       "6bb289f503ea71898b6ca2c07ce352b1ab663c623ee5da7ce5b7172f71b8859e"
    sha256 x86_64_linux:  "01c23c0db2fd7f7c7d5ff542e88507acc9d8f2a3873426b96765c32be0471a9e"
  end

  # https:www.postgresql.orgsupportversioning
  deprecate! date: "2026-11-12", because: :unsupported

  depends_on "pkgconf" => :build
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