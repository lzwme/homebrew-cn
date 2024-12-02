class PostgresqlAT17 < Formula
  desc "Object-relational database system"
  homepage "https:www.postgresql.org"
  url "https:ftp.postgresql.orgpubsourcev17.2postgresql-17.2.tar.bz2"
  sha256 "82ef27c0af3751695d7f64e2d963583005fbb6a0c3df63d0e4b42211d7021164"
  license "PostgreSQL"

  livecheck do
    url "https:ftp.postgresql.orgpubsource"
    regex(%r{href=["']?v?(17(?:\.\d+)+)?["' >]}i)
  end

  bottle do
    sha256 arm64_sequoia: "e0efcbfe6f8bcfa1c63820af7a076f9d8b91b3c609c2e0f5dbfbf8b4df2d29f0"
    sha256 arm64_sonoma:  "a45a33fd8b472daddba43a815b190e6b8c447d74a38c4e4f08e8203d788903ce"
    sha256 arm64_ventura: "8d19972f3766f1b5782b4a6cf4d6914fc3622d433ecc7052692680162033dc7a"
    sha256 sonoma:        "617f5d1fae49e2e78d06e54f4e28380a540ea99414a38bb86d85d0011bd44073"
    sha256 ventura:       "6a2cc48e92fc17bc655ea16d07f544909d60331ab896b4bf5a8a174f39a1dba3"
    sha256 x86_64_linux:  "a6a55f600db3fca37affdabbbbf4513c0049f7635894a9e538e22e8c4627766f"
  end

  keg_only :versioned_formula

  # https:www.postgresql.orgsupportversioning
  deprecate! date: "2029-11-08", because: :unsupported

  depends_on "docbook" => :build
  depends_on "docbook-xsl" => :build
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
    # Update config to fix `error: could not find function 'gss_store_cred_into' required for GSSAPI`
    if OS.mac?
      ENV.prepend "LDFLAGS", "-L#{Formula["gettext"].opt_lib} -L#{Formula["krb5"].opt_lib}"
      ENV.prepend "CPPFLAGS", "-I#{Formula["gettext"].opt_include} -I#{Formula["krb5"].opt_include}"
    end

    args = %W[
      --datadir=#{HOMEBREW_PREFIX}share#{name}
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
    ]
    args << "--with-extra-version= (#{tap.user})" if tap
    args += %w[--with-bonjour --with-tcl] if OS.mac?

    # PostgreSQL by default uses xcodebuild internally to determine this,
    # which does not work on CLT-only installs.
    args << "PG_SYSROOT=#{MacOS.sdk_path}" if OS.mac? && MacOS.sdk_root_needed?

    system ".configure", *args, *std_configure_args(libdir: HOMEBREW_PREFIX"lib#{name}")
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

      When uninstalling, some dead symlinks are left behind so you may want to run:
        brew cleanup --prune-prefix
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