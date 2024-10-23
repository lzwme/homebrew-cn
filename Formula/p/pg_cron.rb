class PgCron < Formula
  desc "Run periodic jobs in PostgreSQL"
  homepage "https:github.comcitusdatapg_cron"
  url "https:github.comcitusdatapg_cronarchiverefstagsv1.6.4.tar.gz"
  sha256 "52d1850ee7beb85a4cb7185731ef4e5a90d1de216709d8988324b0d02e76af61"
  license "PostgreSQL"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0e3405e81c0a9cd72737ace18b03c7bab3f628b2eecc90dfee060cb11fcc8f2e"
    sha256 cellar: :any,                 arm64_sonoma:  "fcae9666effa620d2671ddac687d6278e9a4cb37377045db37c57b78b1bc05d1"
    sha256 cellar: :any,                 arm64_ventura: "2e3e52857674d76f7597b01179bfcbffec3c3fc07c3d5d26e47225b5839c9c10"
    sha256 cellar: :any,                 sonoma:        "bbc13204d53324ab935d664ebdf5d93cf0d7309a68ec00abf04311f9e8651b0a"
    sha256 cellar: :any,                 ventura:       "09dd67e9dc4b56b8ba4288293c8c89ce686f774b5b41fba182f82f882b933272"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d1bcd0a3e67e633137b4a02e74998e5b1276961bac3c9aba6c8390022f4ca675"
  end

  depends_on "postgresql@14" => [:build, :test]
  depends_on "postgresql@17" => [:build, :test]
  depends_on "libpq"

  on_macos do
    depends_on "gettext" # for libintl
  end

  def postgresqls
    deps.filter_map { |f| f.to_formula if f.name.start_with?("postgresql@") }
        .sort_by(&:version)
  end

  def install
    # Work around for ld: Undefined symbols: _libintl_ngettext
    # Issue ref: https:github.comcitusdatapg_cronissues269
    ENV["PG_LDFLAGS"] = "-lintl" if OS.mac?

    postgresqls.each do |postgresql|
      ENV["PG_CONFIG"] = postgresql.opt_bin"pg_config"
      # We force linkage to `libpq` to allow building for multiple `postgresql@X` formulae.
      # The major soversion is hardcoded to at least make sure compatibility version hasn't changed.
      # If it does change, then need to confirm if APIABI change impacts running on older PostgreSQL.
      system "make", "install", "libpq=#{Formula["libpq"].opt_libshared_library("libpq", 5)}",
                                "pkglibdir=#{libpostgresql.name}",
                                "datadir=#{sharepostgresql.name}"
      system "make", "clean"
    end
  end

  test do
    ENV["LC_ALL"] = "C"
    postgresqls.each do |postgresql|
      pg_ctl = postgresql.opt_bin"pg_ctl"
      psql = postgresql.opt_bin"psql"
      port = free_port

      datadir = testpathpostgresql.name
      system pg_ctl, "initdb", "-D", datadir
      (datadir"postgresql.conf").write <<~EOS, mode: "a+"

        shared_preload_libraries = 'pg_cron'
        port = #{port}
      EOS
      system pg_ctl, "start", "-D", datadir, "-l", testpath"log-#{postgresql.name}"
      begin
        system psql, "-p", port.to_s, "-c", "CREATE EXTENSION \"pg_cron\";", "postgres"
      ensure
        system pg_ctl, "stop", "-D", datadir
      end
    end
  end
end