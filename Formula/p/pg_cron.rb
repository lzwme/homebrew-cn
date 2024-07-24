class PgCron < Formula
  desc "Run periodic jobs in PostgreSQL"
  homepage "https:github.comcitusdatapg_cron"
  url "https:github.comcitusdatapg_cronarchiverefstagsv1.6.3.tar.gz"
  sha256 "ea2af24ab8c501037a15d5c74351ef53dbd0a0a3cd035c78f7108574030d61ee"
  license "PostgreSQL"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "18579d04dbfeae9fec0abca5e02c0308b6ea1828d38c2dce716790d087bc1548"
    sha256 cellar: :any,                 arm64_ventura:  "cc6ff6a3ebb9af143b8232fc35dc99d3627832cf5d37a4db649796ab0a3d9cbe"
    sha256 cellar: :any,                 arm64_monterey: "70f6faa52706ce0472f447abd104fccd8af93682b6451946872b47f5e0aaf365"
    sha256 cellar: :any,                 sonoma:         "8ce58d463c2391f0cf195319a4209a548cef25b29e0a87e0c13ec96462b699b8"
    sha256 cellar: :any,                 ventura:        "7ee8bba1cc6631d080b5ff1a903f17852185e51c36d40153b2754c3c500d6f0a"
    sha256 cellar: :any,                 monterey:       "bd64ef477661416302f0de6821043ce0774220947ee08da4659630324439b598"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a226081425b80e8258d7c14cb9859b0d4aa6290e580d437b52c70d3296100f9"
  end

  depends_on "postgresql@14"

  on_macos do
    depends_on "gettext" # for libintl
  end

  def postgresql
    Formula["postgresql@14"]
  end

  def install
    # Work around for ld: Undefined symbols: _libintl_ngettext
    # Issue ref: https:github.comcitusdatapg_cronissues269
    ENV["PG_LDFLAGS"] = "-lintl" if OS.mac?

    system "make", "install", "PG_CONFIG=#{postgresql.opt_bin}pg_config",
                              "pkglibdir=#{libpostgresql.name}",
                              "datadir=#{sharepostgresql.name}"
  end

  test do
    ENV["LC_ALL"] = "C"
    pg_ctl = postgresql.opt_bin"pg_ctl"
    psql = postgresql.opt_bin"psql"
    port = free_port

    system pg_ctl, "initdb", "-D", testpath"test"
    (testpath"testpostgresql.conf").write <<~EOS, mode: "a+"

      shared_preload_libraries = 'pg_cron'
      port = #{port}
    EOS
    system pg_ctl, "start", "-D", testpath"test", "-l", testpath"log"
    begin
      system psql, "-p", port.to_s, "-c", "CREATE EXTENSION \"pg_cron\";", "postgres"
    ensure
      system pg_ctl, "stop", "-D", testpath"test"
    end
  end
end