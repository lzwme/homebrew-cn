class PostgresqlAT17 < Formula
  desc "Object-relational database system"
  homepage "https:www.postgresql.org"
  url "https:ftp.postgresql.orgpubsourcev17.0postgresql-17.0.tar.bz2"
  sha256 "7e276131c0fdd6b62588dbad9b3bb24b8c3498d5009328dba59af16e819109de"
  license "PostgreSQL"

  livecheck do
    url "https:ftp.postgresql.orgpubsource"
    regex(%r{href=["']?v?(17(?:\.\d+)+)?["' >]}i)
  end

  bottle do
    sha256 arm64_sequoia: "7345b4a703b655b5ef7bcb37a3dbc90b5406e4d06e7c4b8d30f8bd43f8499974"
    sha256 arm64_sonoma:  "34876e4d4b26909d79f757d60f7cb34c6e2531c03120f103f5063a6cf62facd3"
    sha256 arm64_ventura: "f2facfda470d494aea051eb64ba54c60171e5866fa032ef7c3fba3b488a69f13"
    sha256 sonoma:        "a5258e4c8218b8ba6d91bb368581548042dc618e07a788e19d0fdf6b7297d7fd"
    sha256 ventura:       "e25fa2f7a5dc496172f262913071f1a85ce03711b1edfd41a8e9f4a38d2c0b2e"
    sha256 x86_64_linux:  "3a5e1daf6f1cef652cb39b869e0d8490c3bf29fcadc1869fbe7c92a7f37d6810"
  end

  keg_only :versioned_formula

  # https:www.postgresql.orgsupportversioning
  deprecate! date: "2029-11-08", because: :unsupported

  depends_on "docbook" => :build
  depends_on "docbook-xsl" => :build
  depends_on "gettext" => :build
  depends_on "pkg-config" => :build
  depends_on "icu4c"
  # GSSAPI provided by Kerberos.framework crashes when forked.
  # See https:github.comHomebrewhomebrew-coreissues47494.
  depends_on "krb5"
  depends_on "lz4"
  depends_on "openssl@3"
  depends_on "readline"
  depends_on "zstd"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
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
    # Modify Makefile to link macOS binaries using Cellar path. Otherwise, binaries are linked
    # using #{HOMEBREW_PREFIX}lib path set during .configure, which will cause audit failures
    # for broken linkage as the paths are not created until post-install step.
    inreplace "srcMakefile.shlib", "-install_name '$(libdir)", "-install_name '#{lib}postgresql"

    ENV["XML_CATALOG_FILES"] = etc"xmlcatalog"
    ENV.delete "PKG_CONFIG_LIBDIR"
    ENV.prepend "LDFLAGS", "-L#{Formula["openssl@3"].opt_lib} -L#{Formula["readline"].opt_lib}"
    ENV.prepend "CPPFLAGS", "-I#{Formula["openssl@3"].opt_include} -I#{Formula["readline"].opt_include}"

    # Fix 'libintl.h' file not found for extensions
    if OS.mac?
      ENV.prepend "LDFLAGS", "-L#{Formula["gettext"].opt_lib}"
      ENV.prepend "CPPFLAGS", "-I#{Formula["gettext"].opt_include}"
    end

    args = std_configure_args + %W[
      --datadir=#{HOMEBREW_PREFIX}share#{name}
      --libdir=#{HOMEBREW_PREFIX}lib#{name}
      --includedir=#{HOMEBREW_PREFIX}include#{name}
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
    system "make"
    # We use an unversioned `postgresql` subdirectory rather than `#{name}` so that the
    # post-installed symlinks can use non-conflicting `#{name}` and be retained on `brew unlink`.
    # Removing symlinks may break PostgreSQL as its binaries expect paths from .configure step.
    system "make", "install-world", "datadir=#{share}postgresql",
                                    "libdir=#{lib}postgresql",
                                    "includedir=#{include}postgresql"

    # Modify the Makefile back so dependents pick up common path
    makefile = lib"postgresqlpgxssrcMakefile.shlib"
    inreplace makefile, "-install_name '#{lib}postgresql", "-install_name '$(libdir)"
  end

  def post_install
    (var"log").mkpath
    postgresql_datadir.mkpath

    # Manually link files from keg to non-conflicting versioned directories in HOMEBREW_PREFIX.
    %w[include lib share].each do |dir|
      dst_dir = HOMEBREW_PREFIXdirname
      src_dir = prefixdir"postgresql"
      src_dir.find do |src|
        dst = dst_dirsrc.relative_path_from(src_dir)

        # Retain existing real directories for extensions if directory structure matches
        next if dst.directory? && !dst.symlink? && src.directory? && !src.symlink?

        rm_r(dst) if dst.exist? || dst.symlink?
        if src.symlink? || src.file?
          Find.prune if src.basename.to_s == ".DS_Store"
          dst.parent.install_symlink src
        elsif src.directory?
          dst.mkpath
        end
      end
    end

    # Also link versioned executables
    bin.each_child { |f| (HOMEBREW_PREFIX"bin").install_symlink f => "#{f.basename}-#{version.major}" }

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
    [bin"pg_config", HOMEBREW_PREFIX"binpg_config-#{version.major}"].each do |pg_config|
      assert_equal "#{HOMEBREW_PREFIX}share#{name}", shell_output("#{pg_config} --sharedir").chomp
      assert_equal "#{HOMEBREW_PREFIX}lib#{name}", shell_output("#{pg_config} --libdir").chomp
      assert_equal "#{HOMEBREW_PREFIX}lib#{name}", shell_output("#{pg_config} --pkglibdir").chomp
      assert_equal "#{HOMEBREW_PREFIX}include#{name}", shell_output("#{pg_config} --pkgincludedir").chomp
      assert_equal "#{HOMEBREW_PREFIX}include#{name}server", shell_output("#{pg_config} --includedir-server").chomp
      assert_match "-I#{Formula["gettext"].opt_include}", shell_output("#{pg_config} --cppflags") if OS.mac?
    end
  end
end